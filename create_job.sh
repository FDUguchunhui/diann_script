#!/bin/bash

# Define the directory containing the files
working_dirctory='/rsrch6/home/biostatistics/cgu3'
input_directory="data"
log_directory="/rsrch6/home/biostatistics/cgu3/diann/log"
library_file="/mnt/library/UNIPROT_2301_SP_HUMAN_Citrullination.predicted.speclib"
singularity_image="diann-1.9.1.img"
lsf_directory="tasks"
num_threads=48
email="cgu3@mdanderson.org"

# Ensure the output and tasks directories exist
mkdir -p "$log_directory"
mkdir -p "$lsf_directory"

# Loop through each .d file in the specified directory
for file in "$working_dirctory"/"$input_directory"/spectrum/*.d; do
    # Extract the base filename without path
    filename=$(basename "$file")
    
    # Create a job script for each file
    job_script="#BSUB -J diann-${filename%.d}
#BSUB -W 24:00
#BSUB -o $log_directory/${filename%.d}.out
#BSUB -e $log_directory/${filename%.d}.err
#BSUB -cwd /rsrch6/home/biostatistics/cgu3
#BSUB -q medium
#BSUB -n 28
#BSUB -M 168
#BSUB -R \"rusage[mem=50]\"
#BSUB -B
#BSUB -N
#BSUB -u $email

echo \$(hostname)
cd /rsrch6/home/biostatistics/cgu3/diann
pwd

# Run DIANN
singularity exec --bind $input_directory:/mnt $singularity_image /diann-1.9.1/diann-linux \
--f /mnt/spectrum/$filename \
--lib $library_file \
--threads $num_threads --verbose 1 \
--out /mnt/output/${filename%.d}_report.tsv --qvalue 0.01 --matrices --temp temp \
--out-lib output/${filename%.d}_report-lib.parquet --qvalue 0.01 --matrices \
--temp /mnt/temp --out-lib --gen-spec-lib --unimod4 --var-mods 5 \
--var-mod UniMod:35,15.994915,M --relaxed-prot-inf --rt-profiling --var-mod Citrullination,0.984016,R"

    # Write the job script to a file
    echo "$job_script" > "$lsf_directory/${filename%.d}_job.lsf"
done

echo "Job scripts created for all .d files in $input_directory."