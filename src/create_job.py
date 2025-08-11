import os
import click

def get_folder_size(folder):
    total_size = 0
    for dirpath, _, filenames in os.walk(folder):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            if os.path.isfile(fp):  # Ensure it's a file
                total_size += os.path.getsize(fp)
    return total_size


def main(file_folder, library, ptm_params, root, min_memory, queue, threads, max_memory, wall_time, qvalue, output_name, singularity_image, temp_dir, email):
    """Generate DIA-NN job scripts for spectrum data processing."""
    
    # Assign arguments
    working_directory = root
    library_file = library
    num_threads = threads
    if not output_name:
        output_name = os.path.basename(file_folder)

    # Change to working directory
    os.makedirs(working_directory, exist_ok=True)
    os.chdir(working_directory)
    click.echo(f"Current working directory: {os.getcwd()}")

    # Define LSF directory
    lsf_directory = f"DIANN_Testing/tasks/{output_name}/{os.path.basename(library_file)}"
    os.makedirs(lsf_directory, exist_ok=True)
    os.makedirs(os.path.join(working_directory, lsf_directory), exist_ok=True)

    # Check if file folder exists
    if not os.path.exists(file_folder):
        click.echo(f"Error: File folder '{file_folder}' does not exist.", err=True)
        return

    # Process each .d file
    d_files = [f for f in os.listdir(file_folder) if f.endswith('.d')]
    
    if not d_files:
        click.echo(f"No .d files found in {file_folder}", err=True)
        return

    for filename in d_files:
            file_path = os.path.join(file_folder, filename)
            output_sub_dir = f"DIANN_Testing/output/{output_name}/{os.path.basename(library_file)}/{filename[:-2]}"
            temp_sub_dir = f"{temp_dir}/{filename[:-2]}"
            file_size = get_folder_size(file_path) / (1024 * 1024)  # Convert to MB

            job_script = f"""
#BSUB -cwd "{working_directory}"

mkdir -p "{output_sub_dir}"
mkdir -p "{temp_sub_dir}"
rm -f "{output_sub_dir}/std_out.txt"
rm -f "{output_sub_dir}/std_err.txt"
touch "{output_sub_dir}/std_out.txt"
touch "{output_sub_dir}/std_err.txt"

#BSUB -J "diann_{filename[:-2]}"
#BSUB -o "{output_sub_dir}/std_out.txt"
#BSUB -e "{output_sub_dir}/std_err.txt"
#BSUB -W {wall_time}
#BSUB -q {queue}
#BSUB -n {num_threads}
#BSUB -M {max_memory}
#BSUB -R "rusage[mem={min_memory}]"
#BSUB -u "{email}"

echo "Current working directory"
pwd
echo "Raw data size (MB): {file_size}"


singularity exec --bind "{working_directory}:/mnt" "{singularity_image}" /diann-1.9.2/diann-linux \\
--f "/mnt/{file_folder}/{filename}" \\
--lib "/mnt/{library_file}" \\
--threads {num_threads} --verbose 1 \\
--out "/mnt/{output_sub_dir}/{filename[:-2]}_report.tsv" --qvalue {qvalue} --matrices \\
--out-lib "/mnt/{output_sub_dir}/{filename[:-2]}_report-lib.parquet" \\
--temp "/mnt/{temp_sub_dir}" --gen-spec-lib \\
{ptm_params}
    """

            job_file_path = os.path.join(lsf_directory, f"{filename[:-2]}.lsf")
            with open(job_file_path, "w") as job_file:
                job_file.write(job_script)

            click.echo(f"{job_file_path} created")

    click.echo(f"Job scripts created for all .d files in {file_folder}.")

@click.command()
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
def cli_main(file_folder, library, ptm_params, root, min_memory, queue, threads, max_memory, wall_time, qvalue, output_name, singularity_image, temp_dir, email):
    """Generate DIA-NN job scripts for spectrum data processing."""
    main(file_folder, library, ptm_params, root, min_memory, queue, threads, max_memory, wall_time, qvalue, output_name, singularity_image, temp_dir, email)

if __name__ == '__main__':
    cli_main()