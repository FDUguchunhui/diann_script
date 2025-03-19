import os
import argparse

def get_folder_size(folder):
    total_size = 0
    for dirpath, _, filenames in os.walk(folder):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            if os.path.isfile(fp):  # Ensure it's a file
                total_size += os.path.getsize(fp)
    return total_size


def main():
    # Default values
    DEFAULT_WORKING_DIR = "/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui"
    DEFAULT_QUEUE = "long"
    DEFAULT_NUM_THREADS = 28
    DEFAULT_MIN_MEMORY = 100
    DEFAULT_MAX_MEMORY = 350
    DEFAULT_WALL_TIME = "240:00"
    DEFAULT_SINGULARITY_IMAGE = "diann/diann-1.9.2.img"
    DEFAULT_TEMP_DIR = "DIANN_Testing/temp"
    DEFAULT_EMAIL = "cgu3@mdanderson.org"
    DEFAULT_QVALUE = 0.01

    # Argument parsing
    parser = argparse.ArgumentParser(description="Generate DIA-NN job scripts", 
                                    formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("-f", required=True, help="Spectrum data folder (required)")
    parser.add_argument("-l", required=True, help="Library file (required)")
    parser.add_argument("-p", required=True, help="PTM parameters (required)")
    parser.add_argument("-r", default=DEFAULT_WORKING_DIR, help="Working directory (default: %(default)s)")
    parser.add_argument("-m", type=int, default=DEFAULT_MIN_MEMORY, help="Minimum memory (MB) (default: %(default)s)")
    parser.add_argument("-q", default=DEFAULT_QUEUE, help="Job queue (default: %(default)s)")
    parser.add_argument("-n", type=int, default=DEFAULT_NUM_THREADS, help="Number of threads (default: %(default)s)")
    parser.add_argument("-M", type=int, default=DEFAULT_MAX_MEMORY, help="Max memory usage per job (MB) (default: %(default)s)")
    parser.add_argument("-W", default=DEFAULT_WALL_TIME, help="Wall time limit (default: %(default)s)")
    parser.add_argument("-v", type=float, default=DEFAULT_QVALUE, help="Q-value for DIA-NN (default: %(default)s)")
    parser.add_argument("-o", default="", help="Custom output name (default: same as file_folder name)")
    args = parser.parse_args()

    # Assign arguments
    working_directory = args.r
    file_folder = args.f
    library_file = args.l
    ptm_params = args.p
    queue = args.q
    num_threads = args.n
    min_memory = args.m
    max_memory = args.M
    wall_time = args.W
    qvalue = args.v
    output_name = args.o if args.o else os.path.basename(file_folder)

    # Change to working directory
    os.makedirs(working_directory, exist_ok=True)
    os.chdir(working_directory)
    print(f"Current working directory: {os.getcwd()}")

    # Define LSF directory
    lsf_directory = f"diann/tasks/{output_name}/{os.path.splitext(os.path.basename(library_file))[0]}"
    os.makedirs(lsf_directory, exist_ok=True)
    os.makedirs(os.path.join(working_directory, lsf_directory), exist_ok=True)

    # Process each .d file
    for filename in os.listdir(file_folder):
        if filename.endswith(".d"):
            file_path = os.path.join(file_folder, filename)
            output_sub_dir = f"DIANN_Testing/output/{output_name}/{os.path.basename(library_file)}/{filename[:-2]}"
            temp_sub_dir = f"{DEFAULT_TEMP_DIR}/{filename[:-2]}"
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
#BSUB -u "{DEFAULT_EMAIL}"

echo "Current working directory"
pwd
echo "Raw data size (MB): {file_size}"


singularity exec --bind "{working_directory}:/mnt" "{DEFAULT_SINGULARITY_IMAGE}" /diann-1.9.2/diann-linux \
--f "/mnt/{file_folder}/{filename}" \
--lib "/mnt/{library_file}" \
--threads {num_threads} --verbose 1 \
--out "/mnt/{output_sub_dir}/{filename[:-2]}_report.tsv" --qvalue {qvalue} --matrices \
--out-lib "/mnt/{output_sub_dir}/{filename[:-2]}_report-lib.parquet" \
--temp "/mnt/{temp_sub_dir}" --gen-spec-lib \
{ptm_params}
    """

            job_file_path = os.path.join(lsf_directory, f"{filename[:-2]}.lsf")
            with open(job_file_path, "w") as job_file:
                job_file.write(job_script)

            print(f"{job_file_path} created")

    print(f"Job scripts created for all .d files in {file_folder}.")

if __name__ == 'main':
    main()