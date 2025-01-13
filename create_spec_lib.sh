#!/bin/bash

# Function to display help message
show_help() {
  echo "Usage: $0 [-r working_directory] [-f file_folder] [-l library_file] [-n library_name] [-p searching parameters] "
  echo
  echo "Options:"
  echo "  -r  Set the working (root) directory (default: /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui), everything else should be relative path to it"
  echo "  -m  Set minimal memory required, i.e. 100"
  echo "  -f  Set the fasta file, i.e. DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta, enclose with double quota if has blanks"
  echo "  -n  Set name for the created library, this only use as identifier for naming, i.e. diann37. It will be used combined with base FASTA for the final naming"
  echo "  -p  Set spectrum library search parameters, exmaple \"--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod UniMod:37,42.046950,KR\""
  echo "  -h  Show this help message"
}

# Parse command-line arguments
while getopts "hr:m:f:n:p:" opt; do
  case $opt in
    r) working_directory="$OPTARG" ;;
    m) min_memory="$OPTARG" ;;
    f) fasta_file="$OPTARG" ;;
    n) library_name="$OPTARG" ;;
    p) search_params="$OPTARG" ;;
    h) show_help; exit 0 ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

# other parameters
temp_directory="DIANN_Testing/temp"
output_directory="DIANN_Testing/output"
singularity_image="diann/diann-1.9.2.img"
num_threads=48
email="cgu3@mdanderson.org"

# Change to the working directory and print the current directory
cd "$working_directory" || { echo "Failed to change directory to $working_directory"; exit 1; }
pwd  # This will print the current working directory

basename=${fasta_file##*/}       # Remove the directory part
fasta_name=${basename%%.*}             # Remove the file extension
# spectrum_folder_name=${spectrum_folder##*/} # spetrum_folder
task_name="${fasta_name}_${library_name}"
# combine spectrum_folder_name with library_name
output_sub_dir="$output_directory/${task_name}"
temp_sub_dir="${temp_directory}/${task_name}"
# Define the directory to save created LSF script
lsf_directory="diann/tasks"
mkdir -p $lsf_directory
# create output sub-directory for each file



# Create a job script for each file
job_script="
#BSUB -cwd \"${working_directory}\"

mkdir -p \"${output_directory}\"
mkdir -p \"${temp_sub_dir}\"
# overwrite log instead of appending
rm "$output_sub_dir/std_out.txt"
rm "$output_sub_dir/std_err.txt"
touch "$output_sub_dir/std_out.txt"
touch "$output_sub_dir/std_err.txt"

#BSUB -J diann_create_${task_name}
#BSUB -W 240:00
#BSUB -o \"$output_sub_dir/std_out.txt\"
#BSUB -e \"$output_sub_dir/std_err.txt\"
#BSUB -q long
#BSUB -n 28
#BSUB -M 350
#BSUB -R \"rusage[mem=${min_memory}]\"
#BSUB -B
#BSUB -N
#BSUB -u \"$email\"

# Run DIANN
singularity exec --bind \"${working_directory}:/mnt\" \"$singularity_image\" /diann-1.9.2/diann-linux \\
--lib \"\" \\
--threads $num_threads --verbose 1 \\
--out \"/mnt/${output_directory}/${task_name}_report.tsv\" \\
--qvalue 0.01 --matrices \\
--temp \"/mnt/${temp_sub_dir}\" \\
--out-lib \"/mnt/${output_directory}/${task_name}_report-lib.parquet\" \\
--gen-spec-lib --predictor \\
--fasta \"/mnt/${fasta_file}\" --fasta-search \\
\"$search_params\" \\
"


# Write the job script to a file
echo "$job_script" > "$lsf_directory/${task_name}.lsf"
echo "$lsf_directory/${task_name}.lsf created"
