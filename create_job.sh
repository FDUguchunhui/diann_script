#!/bin/bash

# Default values for arguments
working_directory="/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui"
queue="long"
num_threads=28
min_memory=100
max_memory=350
wall_time="240:00"
singularity_image="diann/diann-1.9.2.img"
temp_directory="DIANN_Testing/temp"
email="cgu3@mdanderson.org"
qvalue=0.01  # Default Q-value
output_name=""  # Default output name (set per file if not provided)

# Function to display help message
show_help() {
  echo "Usage: $0 [-r working_directory] [-f file_folder] [-l library_file] [-p ptm_params] [-q queue] [-n num_threads] [-M min_memory] [-W wall_time] [-v qvalue] [-o output_name]"
  echo
  echo "Options:"
  echo "  -r  Set the working (root) directory (default: $working_directory)"
  echo "  -m  Set minimal memory required (default: $min_memory MB)"
  echo "  -f  Set the spectrum data folder (required)"
  echo "  -l  Set the library file (required)"
  echo "  -p  Set the PTM parameters (required)"
  echo "  -q  Set the job queue (default: $queue)"
  echo "  -n  Set the number of threads (default: $num_threads)"
  echo "  -M  Set the max memory usage per job (default: $max_memory MB)"
  echo "  -W  Set the wall time limit (default: $wall_time)"
  echo "  -v  Set the q-value for DIA-NN (default: $qvalue)"
  echo "  -o  Set a custom output name (default: same as file_folder name)"
  echo "  -h  Show this help message"
}

# Parse command-line arguments
while getopts "hr:m:f:l:p:q:n:M:W:v:o:" opt; do
  case $opt in
    r) working_directory="$OPTARG" ;;
    m) min_memory="$OPTARG" ;;
    f) file_folder="$OPTARG" ;;
    l) library_file="$OPTARG" ;;
    p) ptm_params="$OPTARG" ;;
    q) queue="$OPTARG" ;;
    n) num_threads="$OPTARG" ;;
    M) max_memory="$OPTARG" ;;
    W) wall_time="$OPTARG" ;;
    v) qvalue="$OPTARG" ;;  # Assign q-value
    o) output_name="$OPTARG" ;;  # Assign custom output name
    h) show_help; exit 0 ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

# Check if required arguments are provided
if [[ -z "$file_folder" || -z "$library_file" || -z "$ptm_params" ]]; then
  echo "Error: Arguments -f (file_folder), -l (library_file), and -p (ptm_params) are required."
  show_help
  exit 1
fi

# Set default output_name if not provided
if [[ -z "$output_name" ]]; then
  output_name="${file_folder##*/}"
fi

# Change to the working directory
cd "$working_directory" || { echo "Failed to change directory to $working_directory"; exit 1; }
pwd

# Modify lsf_directory to use output_name instead of file_folder
lsf_directory="diann/tasks/${output_name}/${library_file##*/}"  
mkdir -p "$lsf_directory"
mkdir -p "$working_directory/$lsf_directory"

# Loop through each .d file in the specified directory
for file in "$file_folder"/*.d; do
    filename=$(basename "$file")
    
    output_sub_dir="DIANN_Testing/output/${output_name}/${library_file##*/}/${filename%.d}"
    temp_sub_dir="$temp_directory/${filename%.d}"
    file_size=$(du -sh "$file" | cut -f1)
    
    job_script="
#BSUB -cwd \"$working_directory\"
#BSUB -J diann_${filename%.d}
#BSUB -o \"$output_sub_dir/std_out.txt\"
#BSUB -e \"$output_sub_dir/std_err.txt\"
#BSUB -W $wall_time
#BSUB -q $queue
#BSUB -n $num_threads
#BSUB -M $max_memory
#BSUB -R \"rusage[mem=${min_memory}]\"
#BSUB -u \"$email\"

echo \"Current working directory\"
pwd
echo \"Raw data size (mb): $file_size\"

mkdir -p \"$output_sub_dir\"
mkdir -p \"$temp_sub_dir\"
rm -f \"$output_sub_dir/std_out.txt\"
rm -f \"$output_sub_dir/std_err.txt\"
touch \"$output_sub_dir/std_out.txt\"
touch \"$output_sub_dir/std_err.txt\"

singularity exec --bind \"${working_directory}:/mnt\" \"${singularity_image}\" /diann-1.9.2/diann-linux \\
--f /mnt/${file_folder}/${filename} \\
--lib /mnt/${library_file} \\
--threads ${num_threads} --verbose 1 \\
--out /mnt/${output_sub_dir}/${filename%.d}_report.tsv --qvalue ${qvalue} --matrices \\
--out-lib /mnt/${output_sub_dir}/${filename%.d}_report-lib.parquet \\
--temp /mnt/${temp_sub_dir} --gen-spec-lib \\
${ptm_params}
"

    echo "$job_script" > "$lsf_directory/${filename%.d}.lsf"
    echo "$lsf_directory/${filename%.d}.lsf created"
done

echo "Job scripts created for all .d files in $file_folder."
