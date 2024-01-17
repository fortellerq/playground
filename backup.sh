#!/bin/bash
#
# forteller 27.02.2022
# 
# 24/01/17 - v0.2 - added verbose output when removing old backups
# 22/02/27 - v0.1 - initial version

# Check if directories exist
if [ ! -d "/$1" ]; then
  echo "Incorrect source specified!"
  exit 1;
fi

if [ ! -d "$2" ]; then
  echo "Incorrect target specified!"
  exit 2;
fi

#Variables definitions
line="\n\n------------------------------------------\n\n"
source_dir="$1"
target_dir="$2"
source_path_first_char=`echo "$source_dir" | cut -c1`
source_path_last_char=`echo "$source_dir" | rev | cut -c1`
target_path_last_char=`echo "$target_dir" | rev | cut -c1`

#Ensure that filename_prefix extctraction works ok / strip last slash
if [[ "$source_path_last_char" == "/" ]]; then
  printf "Removing last slash from source directory\n"
  source_dir=`echo "$source_dir" | rev | cut -c2- | rev`
fi

#Ensure that target dir works ok
if [[ "$target_path_last_char" != "/" ]]; then
  printf "Adding slash to target directory\n"
  target_dir="${target_dir}/"
fi

filename_prefix=`echo "$source_dir" | rev | cut -d"/" -f1 | rev`
backup_filename="${filename_prefix}_`date +%d`_`date +%m`_`date +%Y`.tar"

if [[ -f $target_dir$backup_filename ]]; then
  printf "Target file exists! Script will now quit\n";
  exit 3;
fi

#Actual logic
printf "Target file: $target_dir$backup_filename\n";
printf "Source path: $source_dir";
printf $line

date "+%d/%m/%Y %T";
printf "Listing target directory contents before doing anything:\n";
ls_before=`ls -lah "$target_dir"`;
df_before=`df -h $target_dir | awk 'NR==2{print$4}'`;
printf "$ls_before";
printf "\nFree space: $df_before";
printf $line;

#Removing first slash for tar to stop complaining
if [[ "$source_path_first_char" == "/" ]]; then
  source_dir=`echo "$source_dir" | cut -c2-`
fi

date "+%d/%m/%Y %T";
printf "Now creating backup archive"
tar cf "$target_dir""$backup_filename" -C / "$source_dir"
printf $line

date "+%d/%m/%Y %T";
printf "Now deleting files older than 5 days"
find $target_dir -type f -mtime +5 -exec rm -vf {} \;
printf $line

date "+%d/%m/%Y %T";
printf "Listing target directory contents:\n"
ls_after=`ls -lah "$target_dir"`;
df_after=`df -h $target_dir | awk 'NR==2{print$4}'`;
printf "$ls_after";
printf "\nFree space: $df_after";
printf $line;

date "+%d/%m/%Y %T";
printf "Direcotry listing differences:\n"
diff -y --suppress-common-lines <(printf "Before\n$ls_before" ) <(printf "After\n$ls_after")
printf "\n"
exit 0;
