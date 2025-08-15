# DIA-NN Search Tools (DiaSea2)

This project provides a unified command-line interface for performing high-throughput searches using DIA-NN, including creating spectral libraries, generating job files for processing `.d` files, running batch jobs, and merging results.

## Installation

To install the necessary tools, clone this repository and install it locally:
```bash
git clone https://github.com/FDUguchunhui/diann_script
cd diann_script
pip install -e .
```

The method above provide your extra flexibility to change and update. Alternatively, 
```bash
pip install git+https://github.com/FDUguchunhui/diann_script
```

After installation, the `diann-analysis` command will be available with several subcommands.

## Usage

This section describes how to use the different commands provided in this project. All commands are accessed through the main `diann-analysis` CLI with various subcommands.

### 1. Creating a Spectral Library

The `diann-analysis create-lib` command is used to create a spectral library. The generated library will be named based on the original FASTA file and the targeted PTM, e.g., `[FASTA_FILE_USED]_[CUSTOMIZED_NAME]_report-lib.parquet`.

**Command Syntax:**

```bash
diann-analysis create-lib -r ROOT_PATH -m MEMORY -f FASTA_FILE_PATH -p PARAMS [-n LIB_NAME] [-o OUTPUT_PATH] [-t TEMP_DIRECTORY] [-d OUTPUT_DIRECTORY] [-s SINGULARITY_IMAGE] [--num-threads NUM_THREADS] [-e EMAIL]
```

**Arguments:**

*   `-r, --root ROOT_PATH`: Set the working (root) directory (default: `/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui`).
*   `-f, --fasta FASTA_FILE_PATH`: FASTA file path relative to root (required).
*   `-n, --lib-name LIB_NAME`: Library name identifier for the generated library (optional). If provided, the final name will be the fasta name + the lib_name. If not provided, only the fasta name will be used.
*   `-p, --params PARAMS`: DIA-NN spectrum library search parameters (required).
*   `-m, --memory MEMORY`: Minimal memory required in MB (default: 100).
*   `-o, --output OUTPUT_PATH`: Output path relative to root for the generated LSF job file (default: `diann/tasks`).
*   `-t, --temp-directory TEMP_DIRECTORY`: Temporary directory path (default: `DIANN_Testing/temp`).
*   `-d, --output-directory OUTPUT_DIRECTORY`: Output directory for library generation (default: `DIANN_Testing/output/library_generation`).
*   `-s, --singularity-image SINGULARITY_IMAGE`: Singularity image path (default: `diann/diann-1.9.2.img`).
*   `--num-threads NUM_THREADS`: Number of threads (default: 48).
*   `-e, --email EMAIL`: Email address for job notifications (default: `cgu3@mdanderson.org`). Email are not set to be sent since tasks are run in batch.

**Example:**

```bash
diann-analysis create-lib -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/Cryptodatabase_UNIPROT2505_Human.fasta -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling" -o DIANN_Testing/task/library_generation -e [YOUR-EMAIL]
```

check logs in for potential errors 
```
DIANN_Testing/output/library_generation/Cryptodatabase_UNIPROT2505_Human_Cryptodatabase_UNIPROT2505_Human/std_out.txt
```

**Example 2:**

```bash
# citrullination
diann-analysis create-lib -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n citrullination -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Citrullination,0.984016,R"
```

### 2. Creating Jobs for .d Files

The `diann-analysis create-job` command creates task files for each `.d` file in a specified folder. These task files are placed in the `diann/tasks` directory.

**Command Syntax:**

```bash
diann-analysis create-job -f FILE_FOLDER -l LIBRARY -p PTM_PARAMS [-r ROOT] [-m MIN_MEMORY] [-q QUEUE] [-n THREADS] [-M MAX_MEMORY] [-W WALL_TIME] [-v QVALUE] [-o OUTPUT_NAME] [-s SINGULARITY_IMAGE] [-t TEMP_DIR] [-e EMAIL] [-T TASKS_DIR]
```

**Arguments:**

*   `-f, --file-folder FILE_FOLDER`: Spectrum data folder (required).
*   `-l, --library LIBRARY`: Library file (required).
*   `-p, --ptm-params PTM_PARAMS`: PTM parameters (required).
*   `-r, --root ROOT`: Working directory (default: `/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui`).
*   `-m, --min-memory MIN_MEMORY`: Minimum memory in MB (default: 100).
*   `-q, --queue QUEUE`: Job queue (default: `long`).
*   `-n, --threads THREADS`: Number of threads (default: 28).
*   `-M, --max-memory MAX_MEMORY`: Max memory usage per job in MB (default: 350).
*   `-W, --wall-time WALL_TIME`: Wall time limit (default: `240:00`).
*   `-v, --qvalue QVALUE`: Q-value for DIA-NN (default: 0.01).
*   `-o, --output-name OUTPUT_NAME`: Custom output name (default: same as file_folder name).
*   `-s, --singularity-image SINGULARITY_IMAGE`: Singularity image path (default: `diann/diann-1.9.2.img`).
*   `-t, --temp-dir TEMP_DIR`: Temporary directory (default: `DIANN_Testing/temp`).
*   `-e, --email EMAIL`: Email address for job notifications (default: `cgu3@mdanderson.org`).
*   `-T, --tasks-dir TASKS_DIR`: Tasks directory path (default: `DIANN_Testing/tasks`).

To get detailed information about each argument, run:

```bash
diann-analysis create-job --help
```

**Task File Structure:**

The task files are organized as follows (using the default tasks directory `DIANN_Testing/tasks`, which can be customized with `--tasks-dir`):

```
- TASKS_DIR (default: DIANN_Testing/tasks)
    ├── DATA_FOLDER_NAME or OUTPUT_NAME
    │   ├── PTM_SEARCHING_LIBRARY
    │   │   ├── INDIVIDUAL_TASK_OF_DATA_FILE_1.lsf
    │   │   ├── INDIVIDUAL_TASK_OF_DATA_FILE_2.lsf
    │   │   ├── ...
```

**Output Structure:**

DIA-NN results will be saved in `DIANN_Testing/output` by default but can be override by setting **-T**,and with a structure mirroring the task file structure, making it easy to identify the source data, library, and raw file for each result.

**Example:**


```bash
diann-analysis create-job -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/PLCO -l DIANN_Testing/library/Cryptodatabase_UNIPROT2505_Human_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling" -T DIANN_Testing/tasks
```


**Example 2**
```bash
diann-analysis create-job -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/$folder_name -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_deoxyhypusine_report-lib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Deoxyhypusine,71.073499,K"
```

check log in for errors for each task
```
DIANN_Testing/output/RAINBOW/UNIPROT_human_revi_2024_12_19_ProteinAG_citrullination_report-lib/IPAS8000_PL375_FT_MCED_1_S4-A1_1_346/std_out.txt
```


### 3. Running Batch Jobs

After creating the task files, use the `diann-analysis run-batch` command to submit all `.lsf` files in the specified directory to the LSF batch system.

**Command Syntax:**

```bash
diann-analysis run-batch LSF_DIRECTORY
```

**Arguments:**

*   `LSF_DIRECTORY`: Directory containing the `.lsf` files to submit (required positional argument).

Replace `LSF_DIRECTORY` with the path to the lowest-level task folder (the one containing the individual `.lsf` task files, not other folders). The path will be within your configured tasks directory (default: `DIANN_Testing/tasks`).

**Example:**

```bash
diann-analysis run-batch DIANN_Testing/tasks/PLCO/Cryptodatabase_UNIPROT2505_Human_report-lib.predicted.speclib
```

### 4. Merging Results

The `diann-analysis merge` command is used to process TSV report files from an input directory and combine them into a single output file.

**Command Syntax:**

```bash
diann-analysis merge INPUT_DIR OUTPUT_DIR [-f|--full] [-v|--verbose] [--parquet]
```

**Arguments:**

*   `INPUT_DIR`: Path to the folder containing the result files to merge (required positional argument).
*   `OUTPUT_DIR`: Path for the merged output directory (required positional argument).
*   `-f, --full`: Optional flag to get all information when merging files; default is partial information.
*   `-v, --verbose`: Optional flag to enable verbose logging output.
*   `--parquet`: Optional flag to save the output file as Parquet instead of CSV.

**Example:**

```bash
diann-analysis merge DIANN_Testing/output/RAINBOW/UNIPROT_human_revi_2024_12_19_ProteinAG_citrullination_report-lib ./merged --full --parquet
```

## Command Reference

For help with any command, use the `--help` flag:

```bash
diann-analysis --help                    # General help
diann-analysis create-lib --help         # Help for library creation
diann-analysis create-job --help         # Help for job creation
diann-analysis run-batch --help          # Help for batch execution
diann-analysis merge --help              # Help for merging results
```

## Workflow Example

Here's a complete workflow example:

1. **Create a spectral library:**
   ```bash
   # With custom library name
   diann-analysis create-lib -f DIANN_Testing/library/protein.fasta -n phosphorylation -p "--var-mod UniMod:21,79.966331,STY"
   
   # Or without custom name (uses only FASTA name)
   diann-analysis create-lib -f DIANN_Testing/library/protein.fasta -p "--var-mod UniMod:21,79.966331,STY"
   ```

2. **Create job files for your data:**
   ```bash
   diann-analysis create-job -f DIANN_Testing/data/experiment1 -l DIANN_Testing/library/protein_phosphorylation_report-lib -p "--var-mod UniMod:21,79.966331,STY"
   ```

3. **Submit the jobs:**
   ```bash
   diann-analysis run-batch DIANN_Testing/tasks/experiment1/protein_phosphorylation_report-lib
   ```

4. **Merge the results:**
   ```bash
   diann-analysis merge DIANN_Testing/output/experiment1 ./final_results --parquet
   ```
