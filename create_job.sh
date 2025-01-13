#!/bin/bash

# # Define the root working directory for shell script, use absolute path, every other path should be specified as relative path to this one
# working_directory="/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui"
# # Default values for arguments
# file_folder="DIANN_Testing/data/BrC_CtrlF"
# library_file="DIANN_Testing/library/UNIPROT2301_SP_HUMAN_Hypusine.predicted.speclib"
# # For citrullination "--unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --relaxed-prot-inf --rt-profiling --var-mod Citrullination,0.984016,R"
# For Phosophrolation STY ""
# ptm_params="--unimod4 --var-mods 5 --relaxed-prot-inf --rt-profiling --var-mod Hypusine,87.068414,K --var-mod Deoxyhypusine,71.073499,K"

# Function to display help message
show_help() {
  echo "Usage: $0 [-r working_directory] [-f file_folder] [-l library_file] [-p ptm_params]"
  echo
  echo "Options:"
  echo "  -r  Set the working (root) directory (default: /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui), everything else should be relative path to it"
  echo "  -m  Set minimal memory required"
  echo "  -f  Set the spectrum data folder (default: DIANN_Testing/BrC_CtrlF)"
  echo "  -l  Set the library file (default: DIANN_Testing/library/UNIPROT2301_SP_HUMAN_Hypusine.predicted.speclib)"
  echo "  -p  Set the PTM parameters (default: --unimod4 --var-mods 5 --relaxed-prot-inf --rt-profiling --var-mod Hypusine,87.068414,K --var-mod Deoxyhypusine,71.073499,K)"
  echo "  -h  Show this help message"
}

# Parse command-line arguments
while getopts "hr:m:f:l:p:" opt; do
  case $opt in
    r) working_directory="$OPTARG" ;;
    m) min_memory="$OPTARG" ;;
    f) file_folder="$OPTARG" ;;
    l) library_file="$OPTARG" ;;
    p) ptm_params="$OPTARG" ;;
    h) show_help; exit 0 ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

# Check if required arguments are provided
if [ -z "$working_directory" ] || [ -z "$file_folder" ] || [ -z "$library_file" ] || [ -z "$ptm_params" ]; then
  echo "Error: All arguments -r, -f, -l, and -p are required."
  show_help
  exit 1
fi

singularity_image="diann/diann-1.9.2.img"
temp_directory="DIANN_Testing/temp"
num_threads=56
email="cgu3@mdanderson.org"


# Change to the working directory and print the current directory
cd "$working_directory" || { echo "Failed to change directory to $working_directory"; exit 1; }
pwd  # This will print the current working directory

# Ensure the tasks directories exist
mkdir -p "$working_directory"/"$lsf_directory"

basename=${library_file##*/}       # Remove the directory part
library_name=${basename%%.*}             # Remove the file extension
file_folder_name=${file_folder##*/}
task_name="${file_folder_name}_${library_name}"
# combine file_folder_name with library_name
output_directory="DIANN_Testing/output/$task_name"
# Define the directory to save created LSF script
lsf_directory="diann/tasks/$task_name"
mkdir -p "$lsf_directory"

# Loop through each .d file in the specified directory
for file in "$file_folder"/*.d; do
    # Extract the base filename without path
    filename=$(basename "$file")
    # create output sub-directory for each file
    output_sub_dir="$output_directory"/"${filename%.d}"
    temp_sub_dir="$temp_directory"/"${filename%.d}"
    # Check file size
    file_size=$(du -sh "$file" | cut -f1)
    # Create a job script for each file
    job_script="
#BSUB -cwd \"$working_directory\"

mkdir -p \"$output_sub_dir\"
mkdir -p \"$temp_sub_dir\"
# overwrite log instead of appending
rm "$output_sub_dir/std_out.txt"
rm "$output_sub_dir/std_err.txt"
touch "$output_sub_dir/std_out.txt"
touch "$output_sub_dir/std_err.txt"

#BSUB -J diann_${filename%.d}
#BSUB -o \"$output_sub_dir/std_out.txt\"
#BSUB -e \"$output_sub_dir/std_err.txt\"
#BSUB -W 240:00
#BSUB -q long
#BSUB -n 28
#BSUB -M 350
#BSUB -R \"rusage[mem=$min_memory]\"
# Don't send email when job start to avoid too many emails when run in batch
##BSUB -B 
# Don't send email when job end
##BSUB -N
#BSUB -u \"$email\"

# debug information
echo \"current working directory\"
pwd
echo \"raw data size (mb): $file_size\"

# Run DIANN
singularity exec --bind \"$working_directory\":/mnt \"$singularity_image\" /diann-1.9.2/diann-linux \\
--f /mnt/\"$file_folder/$filename\" \\
--lib /mnt/\"$library_file\" \\
--threads \"$num_threads\" --verbose 1 \\
--out /mnt/\"$output_sub_dir/${filename%.d}\"_report.tsv --qvalue 0.01 --matrices \\
--out-lib /mnt/\"$output_sub_dir/${filename%.d}\"_report-lib.parquet --qvalue 0.01 --matrices \\
--temp /mnt/\"$temp_sub_dir\" --gen-spec-lib \\
\"${ptm_params}\"
"

    # Write the job script to a file
    echo "$job_script" > "$lsf_directory/${filename%.d}.lsf"
    echo "$lsf_directory/${filename%.d}.lsf created"
done

echo "Job scripts created for all .d files in $file_folder."
