#!/usr/bin/env python3
"""
Batch LSF job submission module for DIA-NN Analysis.
"""

import subprocess
import sys
from pathlib import Path


def main(lsf_directory: str):
    """Submit all .lsf files in the specified directory using bsub."""
    # Check if the argument is provided (equivalent to bash [ -z "$1" ])
    if not lsf_directory:
        print("Usage: run_batch.py lsf_directory")
        sys.exit(1)
    
    lsf_path = Path(lsf_directory)
    
    # Check if directory exists
    if not lsf_path.exists():
        print(f"Error: Directory '{lsf_directory}' does not exist.")
        sys.exit(1)
    
    if not lsf_path.is_dir():
        print(f"Error: '{lsf_directory}' is not a directory.")
        sys.exit(1)
    
    # Loop through each .lsf file in the specified directory
    lsf_files = list(lsf_path.glob("*.lsf"))
    
    if not lsf_files:
        print(f"No .lsf files found in {lsf_directory}")
        return
    
    for job_file in lsf_files:
        # Submit the job using bsub (equivalent to bsub < "$job_file")
        try:
            with open(job_file, 'r') as f:
                result = subprocess.run(["bsub"], stdin=f, capture_output=True, text=True)
                if result.returncode == 0:
                    print(f"Successfully submitted: {job_file.name}")
                else:
                    print(f"Error submitting {job_file.name}: {result.stderr}")
        except Exception as e:
            print(f"Error processing {job_file.name}: {e}")
    
    print(f"All .lsf files in {lsf_directory} have been submitted.") 