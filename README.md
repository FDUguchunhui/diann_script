# Diann High-throughput Seadragon Search Tools (DiaSea2)

This project provides a set of scripts and tools for performing high-throughput searches using DIANN, including creating spectral libraries, generating job files for processing `.d` files, running batch jobs, and merging results.

## Installation

To install the necessary tools, run the following command:

```bash
pip install git+https://github.com/FDUguchunhui/diann_script
```

## Usage

This section describes how to use the different scripts provided in this project.

### 1. Creating a Searching Library

The `create_lib_job` CLI command is used to create a spectral library. The generated library will be named based on the original FASTA file and the targeted PTM, e.g., `[FASTA_FILE_USED]_[CUSTOMIZED_NAME]_report-lib.predicted.speclib`.

**Command Syntax:**

```bash
create_lib_job -r ROOT_PATH -m MIN_MEMORY_REQUIRED -f FASTA_FILE_PATH_RELATIVE_TO_ROOT -n CUSTOMIZED_NAME [-p SEARCHING_PARAMETERS]
```

**Arguments:**

*   `-r ROOT_PATH`: Root directory of the project (required).
*   `-m MIN_MEMORY_REQUIRED`: Minimum memory required (required).
*   `-f FASTA_FILE_PATH_RELATIVE_TO_ROOT`: Path to the FASTA file relative to the root directory (required).
*   `-n CUSTOMIZED_NAME`: A customized name for the library (required).
*   `[-p SEARCHING_PARAMETERS]`: Optional searching parameters. These should be quoted and should match the parameters used later for creating jobs.

**Example:**

```bash
create_lib_job -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n citrullination -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Citrullination,0.984016,R"
```

### 2. Creating Jobs for .d Files

The `create_job` CLI command creates task files for each `.d` file in a specified folder. These task files are placed in the `diann/tasks` directory.

**Command Syntax:**

```bash
create_job -r ROOT_PATH -m MIN_MEMORY_REQUIRED -f DATA_FOLDER_PATH_RELATIVE_TO_ROOT -l SEARCHING_LIBRARY_PATH_RELATIVE_TO_ROOT [-p SEARCHING_PARAMETERS] [-v QVALUE_THRESHOLD] [-M MAX_MEMORY_REQUIRED] [-o OUTPUT_NAME] [-q QUEUE] [-W WALL_TIME]
```

**Arguments:**

*   `-r ROOT_PATH`: Root directory of the project (required).
*   `-f DATA_FOLDER_PATH_RELATIVE_TO_ROOT`: Path to the folder containing `.d` files, relative to the root directory (required).
*   `-l SEARCHING_LIBRARY_PATH_RELATIVE_TO_ROOT`: Path to the searching library relative to the root directory (required).
*   `-p SEARCHING_PARAMETERS`: Searching parameters (required). These should be the same parameters used when creating the library and must be quoted.
*   `[-m MIN_MEMORY_REQUIRED]`: Minimum memory required (optional).
*   `[-v QVALUE_THRESHOLD]`: Q-value threshold (optional, default: 0.01).
*   `[-M MAX_MEMORY_REQUIRED]`: Maximum memory required (optional).
*   `[-o OUTPUT_NAME]`: Custom output name (optional). Useful for differentiating results from different parameter settings.
*   `[-q QUEUE]`: LSF queue to submit jobs to (optional).
*   `[-W WALL_TIME]`: Wall time for LSF jobs (optional).

To get detailed information about each argument, run:

```bash
create_job -h
```

**Task File Structure:**

The task files are organized as follows:

```
- diann/task
    ├── DATA_FOLDER_NAME or OUTPUT_NAME
    │   ├── PTM_SEARCHING_LIBRARY
    │   │   ├── INDIVIDUAL_TASK_OF_DATA_FILE_1
    │   │   ├── INDIVIDUAL_TASK_OF_DATA_FILE_2
    │   │   ├── ...
```

**Output Structure:**

DIANN results will be saved in `DIANN_Testing/output` with a structure mirroring the task file structure, making it easy to identify the source data, library, and raw file for each result.

**Example:**

```bash
create_job -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_citrullination_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Citrullination,0.984016,R"
```

### 3. Running Batch Jobs

After creating the task files, use the `./run_batch.sh` script to submit the jobs.

**Command Syntax:**

```bash
diann/run_batch.sh [PATH_TO_TASK_FOLDER]
```

Replace `[PATH_TO_TASK_FOLDER]` with the path to the lowest-level task folder (the one containing the individual task files, not other folders).

### 4. Merging Results

The `merge` CLI command is used to merge results from multiple files.

**Command Syntax:**

```bash
merge PATH_TO_FOLDER_OF_FILES OUTPUT_PATH [-f|--full] [--parquet]
```

**Arguments:**

*   `PATH_TO_FOLDER_OF_FILES`: Path to the folder containing the result files to merge (required positional argument).
*   `OUTPUT_PATH`: Path for the merged output file (required positional argument).
*   `[-f|--full]`: Optional flag to keep all columns, even if merging results from a single `.d` file (by default, columns related to normalization, global, and lib are removed in this case).
*   `[--parquet]`: Optional flag to save the merged file in parquet format (saves space) instead of the default tsv format.
