# DIA-NN Analysis Tools (DiaSea2)

This project provides a unified command-line interface for performing high-throughput searches using DIA-NN, including creating spectral libraries, generating job files for processing `.d` files, running batch jobs, and merging results.

## Installation

To install the necessary tools, clone this repository and install it locally:

```bash
git clone https://github.com/FDUguchunhui/diann_script
cd diann_script
pip install -e .
```

Alternatively, if you have the source code locally, navigate to the project directory and run:

```bash
pip install -e .
```

After installation, the `diann-analysis` command will be available with several subcommands.

## Usage

This section describes how to use the different commands provided in this project. All commands are accessed through the main `diann-analysis` CLI with various subcommands.

### 1. Creating a Spectral Library

The `diann-analysis create-lib` command is used to create a spectral library. The generated library will be named based on the original FASTA file and the targeted PTM, e.g., `[FASTA_FILE_USED]_[CUSTOMIZED_NAME]_report-lib.parquet`.

**Command Syntax:**

```bash
diann-analysis create-lib -r ROOT_PATH -m MEMORY -f FASTA_FILE_PATH -n LIB_NAME -p PARAMS [-o OUTPUT_PATH]
```

**Arguments:**

*   `-r, --root ROOT_PATH`: Set the working (root) directory (default: `/rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui`).
*   `-m, --memory MEMORY`: Minimal memory required in MB (default: 100).
*   `-f, --fasta FASTA_FILE_PATH`: FASTA file path relative to root (required).
*   `-n, --lib-name LIB_NAME`: Library name identifier for the generated library (required).
*   `-p, --params PARAMS`: DIA-NN spectrum library search parameters (required).
*   `-o, --output OUTPUT_PATH`: Output path relative to root for the generated LSF job file (default: `diann/tasks`).

**Example:**

```bash
diann-analysis create-lib -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n citrullination -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Citrullination,0.984016,R"
```

### 2. Creating Jobs for .d Files

The `diann-analysis create-job` command creates task files for each `.d` file in a specified folder. These task files are placed in the `diann/tasks` directory.

**Command Syntax:**

```bash
diann-analysis create-job -f FILE_FOLDER -l LIBRARY -p PTM_PARAMS [-r ROOT] [-m MIN_MEMORY] [-q QUEUE] [-n THREADS] [-M MAX_MEMORY] [-W WALL_TIME] [-v QVALUE] [-o OUTPUT_NAME]
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

To get detailed information about each argument, run:

```bash
diann-analysis create-job --help
```

**Task File Structure:**

The task files are organized as follows:

```
- diann/tasks
    ├── DATA_FOLDER_NAME or OUTPUT_NAME
    │   ├── PTM_SEARCHING_LIBRARY
    │   │   ├── INDIVIDUAL_TASK_OF_DATA_FILE_1.lsf
    │   │   ├── INDIVIDUAL_TASK_OF_DATA_FILE_2.lsf
    │   │   ├── ...
```

**Output Structure:**

DIA-NN results will be saved in `DIANN_Testing/output` with a structure mirroring the task file structure, making it easy to identify the source data, library, and raw file for each result.

**Example:**

```bash
diann-analysis create-job -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_citrullination_report-lib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Citrullination,0.984016,R"
```

### 3. Running Batch Jobs

After creating the task files, use the `diann-analysis run-batch` command to submit all `.lsf` files in the specified directory to the LSF batch system.

**Command Syntax:**

```bash
diann-analysis run-batch LSF_DIRECTORY
```

**Arguments:**

*   `LSF_DIRECTORY`: Directory containing the `.lsf` files to submit (required positional argument).

Replace `LSF_DIRECTORY` with the path to the lowest-level task folder (the one containing the individual `.lsf` task files, not other folders).

**Example:**

```bash
diann-analysis run-batch diann/tasks/RAINBOW/UNIPROT_human_revi_2024_12_19_ProteinAG_citrullination_report-lib
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
diann-analysis merge DIANN_Testing/output/RAINBOW/library_results ./merged_results --full --parquet
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
   diann-analysis create-lib -f DIANN_Testing/library/protein.fasta -n phosphorylation -p "--var-mod UniMod:21,79.966331,STY"
   ```

2. **Create job files for your data:**
   ```bash
   diann-analysis create-job -f DIANN_Testing/data/experiment1 -l DIANN_Testing/library/protein_phosphorylation_report-lib -p "--var-mod UniMod:21,79.966331,STY"
   ```

3. **Submit the jobs:**
   ```bash
   diann-analysis run-batch diann/tasks/experiment1/protein_phosphorylation_report-lib
   ```

4. **Merge the results:**
   ```bash
   diann-analysis merge DIANN_Testing/output/experiment1 ./final_results --parquet
   ```
