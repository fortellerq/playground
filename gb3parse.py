# forteller 24.11.2024
# ChatGPT mostly :)
#
# 24/11/24 - v0.1 - initial version
#
# Usage: python3 gb3parse.py <path_to_geekbench3_output_file>"

import sys

def parse_geekbench3_results(filepath):
    with open(filepath, 'r') as file:
        lines = file.readlines()

    # Initialize variables
    cpu_name = None
    geekbench_single_core = None
    geekbench_multi_core = None
    benchmark_summary = []
    results = []

    current_test_name = None  # To track the test name for scores

    # Parse the file line by line
    for line in lines:
        line = line.rstrip()  # Remove trailing whitespace

        # Extract CPU name from "Processor" line
        if line.startswith("  Processor") and not cpu_name:
            cpu_name = line.split("  Processor", 1)[1].strip()

        # Extract Geekbench single-core and multi-core scores
        if line.startswith("Geekbench Score"):
            scores = line.split()
            geekbench_single_core = scores[-2]  # Second-to-last element
            geekbench_multi_core = scores[-1]  # Last element

        # Extract Benchmark Summary scores
        if "Score" in line and line.startswith("  "):
            parts = line.split()
            if len(parts) >= 3:
                summary_name = " ".join(parts[:-2]).strip()
                single_core_score = parts[-2]
                multi_core_score = parts[-1]
                benchmark_summary.append([f"{summary_name} Single-Core", single_core_score])
                benchmark_summary.append([f"{summary_name} Multi-Core", multi_core_score])

        # Detect new test name (lines with two spaces, not four)
        if line.startswith("  ") and not line.startswith("    "):
            current_test_name = line.strip()

        # Extract single-core and multi-core scores for tests
        if current_test_name and line.startswith("    single-core"):
            parts = line.split()
            score = parts[1]
            results.append([f"{current_test_name} single-core", score])
        elif current_test_name and line.startswith("    multi-core"):
            parts = line.split()
            score = parts[1]
            results.append([f"{current_test_name} multi-core", score])

    # Build the CSV output
    csv_output = f"Name,{cpu_name}\n"
    if geekbench_single_core:
        csv_output += f"Single-Core Score,{geekbench_single_core}\n"
    if geekbench_multi_core:
        csv_output += f"Multi-Core Score,{geekbench_multi_core}\n"

    # Add benchmark summary scores
    for summary in benchmark_summary:
        csv_output += f"{summary[0]},{summary[1]}\n"

    # Add detailed test results
    for result in results:
        csv_output += f"{result[0]},{result[1]}\n"

    return csv_output


if __name__ == "__main__":
    # Ensure a file path is provided
    if len(sys.argv) < 2:
        print("Usage: python3 gb3parse_final_combined.py <path_to_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    try:
        # Parse the Geekbench 3 output file and print the results
        csv_data = parse_geekbench3_results(input_file)
        print(csv_data)
    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")
