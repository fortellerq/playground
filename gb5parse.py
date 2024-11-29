# forteller 24.11.2024
# ChatGPT mostly :)
#
# 24/11/24 - v0.1 - initial version
#
# Usage: python3 gb5parse.py <path_to_geekbench_output_file>"

import re
import sys

def parse_geekbench_results(filepath):
    with open(filepath, 'r') as file:
        lines = file.readlines()

    # Initialize variables
    current_section = None  # Tracks whether we're in Single-Core or Multi-Core section
    results = []
    cpu_name = None
    single_core_score = None
    multi_core_score = None

    # Regular expressions to extract data
    cpu_pattern = re.compile(r"^\s*Name\s+(.*?CPU.*?@.*?GHz)")  # Matches the CPU name
    result_pattern = re.compile(r"(.+?)\s{2,}(\d+)(?:\s+.+)?$")  # Matches test name and score
    single_score_pattern = re.compile(r"Single-Core Score\s+(\d+)")  # Single-Core Score
    multi_score_pattern = re.compile(r"Multi-Core Score\s+(\d+)")   # Multi-Core Score

    # Process lines
    for line in lines:
        line = line.strip()  # Remove leading/trailing whitespace

        # Extract CPU name
        if not cpu_name:
            if line.startswith("Name"):
                cpu_name = line.split("Name", 1)[1].strip()

        # Extract Single-Core Score
        if not single_core_score:
            single_score_match = single_score_pattern.match(line)
            if single_score_match:
                single_core_score = single_score_match.group(1)

        # Extract Multi-Core Score
        if not multi_core_score:
            multi_score_match = multi_score_pattern.match(line)
            if multi_score_match:
                multi_core_score = multi_score_match.group(1)

        # Detect "Single-Core" or "Multi-Core" sections
        if line.startswith("Single-Core"):
            current_section = "Single-Core"
        elif line.startswith("Multi-Core"):
            current_section = "Multi-Core"

        # Extract test name and score within the current section
        elif current_section:
            result_match = result_pattern.match(line)
            if result_match:
                test_name, score = result_match.groups()
                combined_name = f"{test_name.strip()} {current_section}"
                results.append([combined_name, score])

    # Format results into CSV format
    csv_output = f"Name,{cpu_name}\n"  # Header with CPU name
    if single_core_score:
        csv_output += f"Single-Core Score,{single_core_score}\n"  # Add Single-Core Score
    if multi_core_score:
        csv_output += f"Multi-Core Score,{multi_core_score}\n"  # Add Multi-Core Score

    for result in results:
        csv_output += f"{result[0]},{result[1]}\n"

    return csv_output


if __name__ == "__main__":
    # Check if script was called with the correct arguments
    if len(sys.argv) < 2:
        print("Usage: python3 script_name.py <path_to_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    try:
        # Process the input file and print results to stdout
        csv_data = parse_geekbench_results(input_file)
        print(csv_data)
    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")
