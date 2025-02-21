#!/usr/bin/env python3
import argparse
import logging
import re
from pathlib import Path
import pandas as pd

def read_csv_filename(filename: Path, input_dir: Path) -> pd.DataFrame:
    """
    Reads a TSV file and adds extra columns extracted from the filename.

    Parameters:
        filename (Path): The path to the TSV file.
        input_dir (Path): The base input directory to calculate relative paths.

    Returns:
        pd.DataFrame: The processed DataFrame with added columns.
    """
    try:
        # Read the TSV file; adjust the separator if necessary.
        df = pd.read_csv(filename, sep='\t')
    except Exception as e:
        logging.error(f"Error reading file '{filename}': {e}")
        raise

    # Compute relative path from input_dir (excluding file name)
    df['source'] = (input_dir.name /filename.parent.relative_to(input_dir)).as_posix()
    df = df.drop(columns=['File.Name'])

    pattern = r"^([A-Z0-9]+)_([A-Z0-9]+)_([A-Z]+)_(.+?)_([A-Z0-9]+-[A-Z0-9]+)_([0-9]+_[0-9]+)$"
    ids = df['Run'].str.extract(pattern, flags=re.IGNORECASE)
    ids.columns = ['IPAS', 'plate', 'assay', 'ID', 'evotip', 'well']
    df = pd.concat([df, ids], axis=1)

    return df

def main():
    # Set up command line arguments.
    parser = argparse.ArgumentParser(
        description='Process TSV report files from an input directory and combine them into a single CSV file.'
    )
    parser.add_argument(
        'input_dir',
        type=str,
        help='Path to the input directory containing TSV report files.'
    )
    parser.add_argument(
        'output_dir',
        type=str,
        help='Path to the output directory where the final CSV file will be saved.'
    )
    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Enable verbose logging output.'
    )
    args = parser.parse_args()

    # Configure logging.
    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s'
    )

    input_dir = Path(args.input_dir).resolve()
    output_dir = Path(args.output_dir).resolve()

    if not input_dir.is_dir():
        logging.error(f"Input directory '{input_dir}' does not exist or is not a directory.")
        return

    # Recursively process each subfolder inside the input directory.
    dataframes = []
    empty_folders = []

    for folder in input_dir.iterdir():
        if folder.is_dir():
            # Find all files in the current folder that end with "_report.tsv".
            files = list(folder.glob("**/*_report.tsv"))  # Recursively search in all subdirectories

            if not files:
                logging.warning(f"No '_report.tsv' files found in folder: {folder}")
                empty_folders.append(folder.name)
                continue

            logging.debug(f"Found {len(files)} file(s) in folder: {folder}")

            for file in files:
                logging.debug(f"Processing file: {file}")
                try:
                    df = read_csv_filename(file, input_dir)
                    dataframes.append(df)
                except Exception as e:
                    logging.error(f"Failed to process file '{file}': {e}")

    if not dataframes:
        logging.error("No data processed from input files.")
        return

    # Combine all DataFrames into one.
    final_peptide = pd.concat(dataframes, ignore_index=True)

    # Create a 'batchID' column by concatenating 'plate' and 'well' with an underscore.
    final_peptide['batchID'] = final_peptide['plate'].astype(str) + "_" + final_peptide['well'].astype(str)

    # Determine the output file name based on the last folder level of the input directory.
    output_filename = input_dir.name + ".tsv"
    output_file = output_dir / output_filename

    try:
        final_peptide.to_csv(output_file, index=False, sep='\t')
        logging.info(f"Final TSV saved to: {output_file}")
    except Exception as e:
        logging.error(f"Error saving TSV to '{output_file}': {e}")

if __name__ == '__main__':
    main()
