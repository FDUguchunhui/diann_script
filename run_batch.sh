#!/bin/bash

# Define the directory containing the .lsf files
lsf_directory="tasks/BrC_CtrlF_UNIPROT2301_SP_HUMAN_Hypusine"

# Loop through each .lsf file in the specified directory
for job_file in "$lsf_directory"/*.lsf; do
    # Submit the job using bsub
    bsub < "$job_file"
done

echo "All .lsf files in $lsf_directory have been submitted."
