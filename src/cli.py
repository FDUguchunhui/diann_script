#!/usr/bin/env python3
"""
DIA-NN Analysis CLI - A unified command line interface for DIA-NN analysis tools.
"""

import click
from .create_job import main as create_job_main
from .create_lib_job import main as create_lib_job_main
from .merge import main as merge_main
from .run_batch import main as run_batch_main


@click.group()
@click.version_option(version="0.1.0")
def cli():
    """DIA-NN Analysis Tools - A collection of utilities for DIA-NN data processing and analysis."""
    pass


@cli.command("create-job")
@click.option("-f", "--file-folder", required=True, help="Spectrum data folder (required)")
@click.option("-l", "--library", required=True, help="Library file (required)")
@click.option("-p", "--ptm-params", required=True, help="PTM parameters (required)")
@click.option("-r", "--root", default="/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui", 
              help="Working directory")
@click.option("-m", "--min-memory", type=int, default=100, help="Minimum memory (MB)")
@click.option("-q", "--queue", default="long", help="Job queue")
@click.option("-n", "--threads", type=int, default=28, help="Number of threads")
@click.option("-M", "--max-memory", type=int, default=350, help="Max memory usage per job (MB)")
@click.option("-W", "--wall-time", default="240:00", help="Wall time limit")
@click.option("-v", "--qvalue", type=float, default=0.01, help="Q-value for DIA-NN")
@click.option("-o", "--output-name", default="", help="Custom output name (default: same as file_folder name)")
@click.option("-s", "--singularity-image", default="diann/diann-1.9.2.img", help="Singularity image path")
@click.option("-t", "--temp-dir", default="DIANN_Testing/temp", help="Temporary directory")
@click.option("-e", "--email", default="cgu3@mdanderson.org", help="Email address for job notifications")
@click.option("-T", "--tasks-dir", default="DIANN_Testing/tasks", help="Tasks directory path")
def create_job(file_folder, library, ptm_params, root, min_memory, queue, threads, max_memory, wall_time, qvalue, output_name, singularity_image, temp_dir, email, tasks_dir):
    """Generate DIA-NN job scripts for spectrum data processing."""
    create_job_main(file_folder, library, ptm_params, root, min_memory, queue, threads, max_memory, wall_time, qvalue, output_name, singularity_image, temp_dir, email, tasks_dir)


@cli.command("create-lib")
@click.option("-r", "--root", default="/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui", 
              help="Set the working (root) directory")
@click.option("-m", "--memory", default=100, type=int, 
              help="Minimal memory required (e.g., 100)")
@click.option("-f", "--fasta", required=True, 
              help="FASTA file path relative to root")
@click.option("-n", "--lib-name", default="", 
              help="Library name. The identifier given to the generated library. If provided, the final name will be the fasta name + the lib_name. If not provided, only the fasta name will be used.")
@click.option("-p", "--params", required=True, 
              help="DIANN spectrum library search parameters.")
@click.option("-o", "--output", default="diann/tasks", 
              help="The output path relative to the root for the generated LSF job file.")
@click.option("-t", "--temp-directory", default="DIANN_Testing/temp", 
              help="Temporary directory path")
@click.option("-d", "--output-directory", default="DIANN_Testing/output/library_generation", 
              help="Output directory for library generation")
@click.option("-s", "--singularity-image", default="diann/diann-1.9.2.img", 
              help="Singularity image path")
@click.option("--num-threads", default=48, type=int, 
              help="Number of threads")
@click.option("-e", "--email", default="cgu3@mdanderson.org", 
              help="Email address for job notifications")
def create_lib(root, memory, fasta, lib_name, params, output, temp_directory, output_directory, singularity_image, num_threads, email):
    """Generate LSF script for DIANN library creation."""
    create_lib_job_main(root, memory, fasta, lib_name, params, output, temp_directory, output_directory, singularity_image, num_threads, email)


@cli.command("merge")
@click.argument('input_dir', type=click.Path(exists=True, file_okay=False, dir_okay=True))
@click.argument('output_dir', type=click.Path(file_okay=False, dir_okay=True))
@click.option('-f', '--full', is_flag=True, help='Get all information when merging files; default is partial information.')
@click.option('-v', '--verbose', is_flag=True, help='Enable verbose logging output.')
@click.option('--parquet', is_flag=True, help='Save the output file as Parquet instead of CSV.')
def merge(input_dir, output_dir, full, verbose, parquet):
    """Process TSV report files from an input directory and combine them into a single output file."""
    merge_main(input_dir, output_dir, full, verbose, parquet)


@cli.command("run-batch")
@click.argument('lsf_directory')
def run_batch(lsf_directory):
    """Submit all .lsf files in the specified directory to the LSF batch system."""
    run_batch_main(lsf_directory)


if __name__ == '__main__':
    cli() 