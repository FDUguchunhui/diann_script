#!/bin/bash

# Default values for arguments
spectrum_folder="DIANN_Testing/BrC_CtrlF"
library_file="DIANN_Testing/library/UNIPROT2301_SP_HUMAN_Hypusine.predicted.speclib"

# Parse command-line arguments
while getopts "s:l:" opt; do
  case $opt in
    s) spectrum_folder="$OPTARG" ;;
    l) library_file="$OPTARG" ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done


# Define the root working directory for shell script
working_directory="/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui"
singularity_image="diann/diann-1.9.2.img"
# Define the mount directory for the diann image; it can be access through /mnt then
mount_directory="/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui"
temp_directory="DIANN_Testing/temp"
num_threads=48
email="cgu3@mdanderson.org"


# Change to the working directory and print the current directory
cd "$working_directory" || { echo "Failed to change directory to $working_directory"; exit 1; }
pwd  # This will print the current working directory

# Ensure the output and tasks directories exist
mkdir -p "$mount_directory"/"$log_directory"
mkdir -p "$mount_directory"/"$lsf_directory"


basename=${library_file##*/}       # Remove the directory part
library_name=${basename%%.*}             # Remove the file extension
spectrum_folder_name=${spectrum_folder##*/}
task_name="${spectrum_folder_name}_${library_name}"
# combine spectrum_folder_name with library_name
output_directory="DIANN_Testing/output/$task_name"
# Define the directory to save created LSF script
lsf_directory="diann/tasks/$task_name"
mkdir -p $lsf_directory

# Loop through each .d file in the specified directory
for file in "$spectrum_folder"/*.d; do
    # Extract the base filename without path
    filename=$(basename "$file")
    # create output sub-directory for each file
    output_sub_dir="$output_directory"/"${filename%.d}"
    temp_sub_dir="$temp_directory"/"${filename%.d}"
    mkdir -p "$mount_directory"/"$output_sub_dir"
    mkdir -p "$mount_directory"/"$temp_sub_dir"
    # Create a job script for each file
    job_script="#BSUB -J diann-"${filename%.d}"
#BSUB -W 24:00
#BSUB -o "$output_sub_dir"/"std_out.txt"
#BSUB -e "$output_sub_dir"/"std_err.txt"
#BSUB -cwd "$working_directory"
#BSUB -q medium
#BSUB -n 28
#BSUB -M 350
#BSUB -R \"rusage[mem=100]\"
# Don't send email when job start to avoid too many emails when run in batch
##BSUB -B 
# Don't send email when job end
##BSUB -N
#BSUB -u "$email"

echo \$(hostname)
pwd

# Run DIANN
singularity exec --bind "$mount_directory":/mnt "$singularity_image" /diann-1.9.2/diann-linux \\
--f /mnt/"$spectrum_folder"/"$filename" \\
--lib /mnt/"$library_file" \\
--threads "$num_threads" --verbose 1 \\
--out /mnt/"$output_sub_dir"/"${filename%.d}"_report.tsv --qvalue 0.01 --matrices \\
--out-lib /mnt/"$output_sub_dir"/"${filename%.d}"_report-lib.parquet --qvalue 0.01 --matrices \\
--temp /mnt/"$temp_sub_dir" --out-lib --gen-spec-lib --unimod4 --var-mods 5 \\
--relaxed-prot-inf --rt-profiling --var-mod Hypusine,87.068414,K --var-mod Deoxyhypusine,71.073499,K"

    # Write the job script to a file
    echo "$job_script" > "$lsf_directory/${filename%.d}_job.lsf"
    echo "$lsf_directory/${filename%.d}_job.lsf created"
done

echo "Job scripts created for all .d files in $spectrum_folder."
