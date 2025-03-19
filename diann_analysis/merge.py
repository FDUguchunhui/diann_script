#!/usr/bin/env python3
import argparse
import logging
import re
from pathlib import Path
import pandas as pd

def read_csv_filename(filename: Path, input_dir: Path, partial=True) -> pd.DataFrame:
    """
    Reads a TSV file and adds extra columns extracted from the filename.

    Parameters:
        filename (Path): The path to the TSV file.
        input_dir (Path): The base input directory to calculate relative paths.
        partial (bool): Whether to keep all columns or only partial columns.

    Returns:
        pd.DataFrame: The processed DataFrame with added columns.
    """
    try:
        df = pd.read_csv(filename, sep='\t')
    except Exception as e:
        logging.error(f"Error reading file '{filename}': {e}")
        raise

    df['source'] = (input_dir.name / filename.parent.relative_to(input_dir)).as_posix()
    df = df.drop(columns=['File.Name'], errors='ignore')

    if partial:
        df = df.drop(columns=['PG.Normalised', 'PG.MaxLFQ', 'Genes.Normalised', 
                              'Genes.MaxLFQ', 'Global.Q.Value', 'Global.PG.Q.Value', 'Precursor.Normalised', 
                              'Lib.Q.Value', 'Lib.PG.Q.Value', 'Ms1.Normalised', 'Normalisation.Factor', 
                              'Lib.PTM.Site.Confidence'], errors='ignore')
    
    pattern = r"^([A-Z0-9]+)_([A-Z0-9]+)_([A-Z]+)_(.+?)_([A-Z0-9]+-[A-Z0-9]+)_([0-9]+_[0-9]+)$"
    ids = df['Run'].str.extract(pattern, flags=re.IGNORECASE)
    ids.columns = ['IPAS', 'plate', 'assay', 'ID', 'evotip', 'well']
    df = pd.concat([df, ids], axis=1)

    return df

def main():
    parser = argparse.ArgumentParser(
        description='Process TSV report files from an input directory and combine them into a single output file.'
    )
    parser.add_argument(
        'input_dir',
        type=str,
        help='Path to the input directory containing TSV report files.'
    )
    parser.add_argument(
        'output_dir',
        type=str,
        help='Path to the output directory where the final file will be saved.'
    )
    
    parser.add_argument(
        '-f', '--full',
        action='store_true',
        help='Whether to get all information when merging files; default is partial information.'
    )

    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Enable verbose logging output.'
    )
    
    parser.add_argument(
        '--parquet',
        action='store_true',
        help='Save the output file as CSV instead of Parquet.'
    )
    
    args = parser.parse_args()

    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s'
    )

    if not args.full:
        logging.info('''You are now requesting a merged file with partial information, which means some
        columns will not be included. To have all columns use "-f or --full" flag.''')

    input_dir = Path(args.input_dir).resolve()
    output_dir = Path(args.output_dir).resolve()

    if not input_dir.is_dir():
        logging.error(f"Input directory '{input_dir}' does not exist or is not a directory.")
        return

    dataframes = []
    empty_folders = []

    for folder in input_dir.iterdir():
        if folder.is_dir():
            files = list(folder.glob("**/*_report.tsv"))

            if not files:
                logging.warning(f"No '_report.tsv' files found in folder: {folder}")
                empty_folders.append(folder.name)
                continue

            logging.debug(f"Found {len(files)} file(s) in folder: {folder}")

            for file in files:
                logging.debug(f"Processing file: {file}")
                try:
                    df = read_csv_filename(file, input_dir, partial=(not args.full))
                    dataframes.append(df)
                except Exception as e:
                    logging.error(f"Failed to process file '{file}': {e}")

    if not dataframes:
        logging.error("No data processed from input files.")
        return

    final_peptide = pd.concat(dataframes, ignore_index=True)
    final_peptide['batchID'] = final_peptide['plate'].astype(str) + "_" + final_peptide['well'].astype(str)

    output_filename = input_dir.name + (".parquet" if args.parquet else ".csv")
    output_file = output_dir / output_filename

    try:
        if args.parquet:
            final_peptide.to_parquet(output_file, index=False)
        else:
            final_peptide.to_csv(output_file, index=False, sep='\t')
        logging.info(f"Final file saved to: {output_file}")
    except Exception as e:
        logging.error(f"Error saving file to '{output_file}': {e}")

if __name__ == '__main__':
    main()
