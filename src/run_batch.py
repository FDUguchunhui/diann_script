#!/usr/bin/env python3
"""
Batch LSF job submission module for DIA-NN Analysis.
"""

import subprocess
from pathlib import Path


def main(lsf_directory: str):
    """Submit all .lsf files in the specified directory using bsub."""
    lsf_path = Path(lsf_directory)
    
    # Loop through each .lsf file in the specified directory
    for job_file in lsf_path.glob("*.lsf"):
        # Submit the job using bsub
        subprocess.run(["bsub"], stdin=open(job_file, 'r'))
    
    print(f"All .lsf files in {lsf_directory} have been submitted.") 