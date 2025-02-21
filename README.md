# diann_script


# To create a searching library

The created library will be name as [FASTA_FILE_USED]_[CUSTOMIZED_NAME]_report-lib.predicted.speclib to reflect the original FASTA file used and what PTM it target to create the library

```
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n citrullination -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Citrullination,0.984016,R"
```


# To create jobs for a .d files in a folder

Assume you already set working directory as diann folder you can
```
./create_spec_lib.sh -r ROOT_PATH -m MIN_MEMORY_REQUIRED -f DATA_FOLDER_PATH_RELATIVE_TO_ROOT -l SEARCHING_LIBRARY_PATH_RELATIVE_TO_ROOT [-p SEARCHING_PARAMETERS] [-v QVALUE_THRESHOLD] [-M MAX_MEMORY_REQUIRED] [-o OUTPUT_NAME] [-q QUEUE] [-W WALL_TIME]
```

The "-r ROOT_PATH -f DATA_FOLDER_PATH_RELATIVE_TO_ROOT -l SEARCHING_LIBRARY_PATH_RELATIVE_TO_ROOT -p SEARCHING_PARAMETERS " are required arguments and "[-m MIN_MEMORY_REQUIRED] [-v QVALUE_THRESHOLD] [-M MAX_MEMORY_REQUIRED] [-o OUTPUT_NAME] [-q QUEUE] [-W WALL_TIME]" are optional arguments for refined control. The "-p SEARCHING_PARAMETERS" should be the same for the command when you create the library use in "-l SEARCHING_PARAMETERS", and must be quoted to avoid split by shell.

You can run code below to get details information about each arguments and whether they are required or optional (and default value)
```
./create_spec_lib.sh -h
```

The script will create a task file for every .d file in [FILE_PATH] into diann/tasks folder (automatically created if not there). The structure of data/tasks will be group by 
```
- diann/task
    ├── DATA_FOLDER_NAME
    │   ├── PTM_SEARCHING_LIBRARY
    │   │   ├── INDIVIDUAL_TASK_OF_DATA_FILE_1
    │   │   ├── INDIVIDUAL_TASK_OF_DATA_FILE_2
    │   │   ├── ...
```

The create LSF tasks will set output to DIANN_Testing/output, the output structure following the same pattern as in DIANN/tasks. In this way, you can easily know the which campaign the raw data is from and what search library was used to generate the results, and what is the raw file the result is from.
 
You can specifie "-o [OUTPUT_NAME]" to set a difference name from [DATA_FOLDER_NAME], which is useful when you want to try different parameter setting without override results. For example if you set "-v 0.05" which is q-value threshold of 0.05, you can specify "-o RAINBOW_QVALUE_005" to remind you the result is for files in RAINBOW and with a customized q-value of 0.05 instead of default 0.01. Now the results of DIANN will be saved into:

```
- diann/task
    ├── OUTPUT_NAME
    │   ├── PTM_SEARCHING_LIBRARY
    │   │   ├── INDIVIDUAL_TASK_OF_DATA_FILE_1
    │   │   ├── INDIVIDUAL_TASK_OF_DATA_FILE_2
    │   │   ├── ...
```

Here is an example:
```
diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_citrullination_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Citrullination,0.984016,R"
```

After the jobs has been created, you can run
```
diann/run_batch.sh [PATH_TO_TASK_FOLDER]
```
to submit all tasks in a folder, here please use the lowest folder path (i.e. the folder doesn't contain other folders) to submit tasks.


# To merge results from multiple files

Run CLI merge with two required positional arguments. If you are combining results from run using only one .d files, the merge process will automatically remove columns related to normalization, global, and lib, since those columns are only informative when you run with multiple experiment and/or using MBR(match-between-runs). You can override this behavior by using "-f" flag.
```
python diann_analysis/merge.py PATH_TO_FOLDER_OF_FILES OUTPUT_PATH [-f|--full]
```

