#!/bin/bash

# Define the root working directory for shell script
working_directory="/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui"
# Define log ouput directory for the shell script
log_directory="/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui/diann/log"
singularity_image="diann/diann-1.9.1.img"
# Define the mount directory for the diann image; it can be access through /mnt then
mount_directory="/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui"
# change if necessary ****
fasta_file="DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta"
ptm_name="diann37"
temp_directory="DIANN_Testing/temp"
num_threads=48
search_params="--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:37,42.046950,KR"
email="cgu3@mdanderson.org"


# Change to the working directory and print the current directory
cd "$working_directory" || { echo "Failed to change directory to $working_directory"; exit 1; }
pwd  # This will print the current working directory

# Ensure the output and tasks directories exist
mkdir -p "$mount_directory"/"$log_directory"
mkdir -p "$mount_directory"/"$lsf_directory"


basename=${fasta_file##*/}       # Remove the directory part
library_name=${basename%%.*}             # Remove the file extension
spectrum_folder_name=${spectrum_folder##*/}
task_name="${library_name}_${ptm_name}"
# combine spectrum_folder_name with library_name
output_directory="DIANN_Testing/output/$task_name"
temp_sub_dir="$temp_directory"/"${task_name}"
# Define the directory to save created LSF script
lsf_directory="diann/tasks"
mkdir -p $lsf_directory
# create output sub-directory for each file
mkdir -p "$mount_directory"/"$output_directory"
mkdir -p "$mount_directory"/"$temp_sub_dir"

# Create a job script for each file
job_script="
#BSUB -J diann_create_${task_name}
#BSUB -W 24:00
#BSUB -o "$log_directory"/"${task_name}".out
#BSUB -e "$log_directory"/"${task_name}".err
#BSUB -cwd "$working_directory"
#BSUB -q medium
#BSUB -n 28
#BSUB -M 350
#BSUB -R \"rusage[mem=100]\"
#BSUB -B
#BSUB -N
#BSUB -u "$email"

echo \$(hostname)
pwd

# Run DIANN
singularity exec --bind "$mount_directory":/mnt "$singularity_image" /diann-1.9.1/diann-linux \\
--lib "" \\
--threads "$num_threads" --verbose 1 \\
--out /mnt/"$output_directory"/"${task_name}"_report.tsv \\
--qvalue 0.01 --matrices \\
--temp  /mnt/"$temp_sub_dir" \\
--out-lib /mnt/"$output_sub_dir"/"${task_name}"_report-lib.parquet \\
--gen-spec-lib --predictor \\
--fasta /mnt/"$fasta_file" --fasta-search \\
"$search_params"
"
# Write the job script to a file
echo "$job_script" > "$lsf_directory/${task_name}.lsf"
echo "$lsf_directory/${task_name}.lsf created"
