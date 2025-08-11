#!/usr/bin/env python3

import os
import click

def main(root, memory, fasta, lib_name, params, output):
    """Generate LSF script for DIANN library creation. 
    
    It won't automatically execute the task. You will have to double check the LSF file 
    and make necessary change before submitting.
    
    Example: 
    diann_create_spec_lib -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui 
    -f DIANN_Testing/library/Cryptodatabase_UNIPROT2505_Human.fasta 
    -n Cryptodatabase_UNIPROT2505_Human 
    -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling" 
    -m 100
    """
    # Assign arguments to variables
    working_directory = root
    min_memory = memory
    fasta_file = fasta
    library_name = lib_name
    search_params = params
    lsf_directory = output

    # Constants
    temp_directory = "DIANN_Testing/temp"
    output_directory = "DIANN_Testing/output/library_generation"
    singularity_image = "diann/diann-1.9.2.img"
    num_threads = 48
    email = "cgu3@mdanderson.org"
 

    os.makedirs(lsf_directory, exist_ok=True)

    # Change to working directory
    os.chdir(working_directory)
    click.echo(f"Current working directory: {os.getcwd()}")

    # Derive names
    basename = os.path.basename(fasta_file)
    fasta_name = os.path.splitext(basename)[0]
    task_name = f"{fasta_name}_{library_name}"
    output_sub_dir = os.path.join(output_directory, task_name)
    temp_sub_dir = os.path.join(temp_directory, task_name)

    # LSF job script content
    job_script = f"""\
#BSUB -cwd "{working_directory}"

mkdir -p "{output_sub_dir}"
mkdir -p "{temp_sub_dir}"
rm "{output_sub_dir}/std_out.txt"
rm "{output_sub_dir}/std_err.txt"
touch "{output_sub_dir}/std_out.txt"
touch "{output_sub_dir}/std_err.txt"

#BSUB -J diann_create_{task_name}
#BSUB -W 240:00
#BSUB -o "{output_sub_dir}/std_out.txt"
#BSUB -e "{output_sub_dir}/std_err.txt"
#BSUB -q long
#BSUB -n 28
#BSUB -M 350
#BSUB -R "rusage[mem={min_memory}]"
#BSUB -B
#BSUB -N
#BSUB -u "{email}"

singularity exec --bind "{working_directory}:/mnt" "{singularity_image}" /diann-1.9.2/diann-linux \\
--lib "" \\
--threads {num_threads} --verbose 1 \\
--out "/mnt/{output_sub_dir}/{task_name}_report.tsv" \\
--qvalue 0.01 --matrices \\
--temp "/mnt/{temp_sub_dir}" \\
--out-lib "/mnt/{output_sub_dir}/{task_name}_report-lib.parquet" \\
--gen-spec-lib --predictor \\
--fasta "/mnt/{fasta_file}" --fasta-search \\
{search_params}
"""

    # Write to .lsf file
    lsf_path = os.path.join(lsf_directory, f"{task_name}.lsf")
    with open(lsf_path, "w") as f:
        f.write(job_script)

    click.echo(f"{lsf_path} created")

@click.command()
@click.option("-r", "--root", default="/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui", 
              help="Set the working (root) directory")
@click.option("-m", "--memory", default=100, type=int, 
              help="Minimal memory required (e.g., 100)")
@click.option("-f", "--fasta", required=True, 
              help="FASTA file path relative to root")
@click.option("-n", "--lib-name", required=True, 
              help="Library name. The identifier given to the generated library. You should make it self-descriptive to indicate which fasta it used and what notable search parameters used. The final name will be the fasta name + the lib_name")
@click.option("-p", "--params", required=True, 
              help="DIANN spectrum library search parameters. Only the searching parameters related to peptides are required. Other parameters are set to parameters suitable for most setting. However you can always override those settings here")
@click.option("-o", "--output", default="diann/tasks", 
              help="The output path relative to the root for the generated LSF job file.")
def cli_main(root, memory, fasta, lib_name, params, output):
    """Generate LSF script for DIANN library creation."""
    main(root, memory, fasta, lib_name, params, output)

if __name__ == "__main__":
    cli_main()
