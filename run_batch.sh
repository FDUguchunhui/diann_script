#!/bin/bash

# Check if the positional argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 lsf_directory"
  exit 1
fi

# Define the directory containing the .lsf files
lsf_directory="$1"

# Loop through each .lsf file in the specified directory
for job_file in "$lsf_directory"/*.lsf; do
    # Submit the job using bsub
    bsub < "$job_file"
done

echo "All .lsf files in $lsf_directory have been submitted."