#!/usr/bin/env python3
import click
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

def main(input_dir, output_dir, full, verbose, parquet):
    """Process TSV report files from an input directory and combine them into a single output file."""

    logging.basicConfig(
        level=logging.DEBUG if verbose else logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s'
    )

    if not full:
        logging.info('''You are now requesting a merged file with partial information, which means some
        columns will not be included. To have all columns use "-f or --full" flag.''')

    input_path = Path(input_dir).resolve()
    output_path = Path(output_dir).resolve()

    if not input_path.is_dir():
        click.echo(f"Error: Input directory '{input_path}' does not exist or is not a directory.", err=True)
        return

    dataframes = []
    empty_folders = []

    for folder in input_path.iterdir():
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
                    df = read_csv_filename(file, input_path, partial=(not full))
                    dataframes.append(df)
                except Exception as e:
                    logging.error(f"Failed to process file '{file}': {e}")

    if not dataframes:
        click.echo("Error: No data processed from input files.", err=True)
        return

    final_peptide = pd.concat(dataframes, ignore_index=True)
    final_peptide['batchID'] = final_peptide['plate'].astype(str) + "_" + final_peptide['well'].astype(str)

    output_filename = input_path.name + (".parquet" if parquet else ".csv")
    output_file = output_path / output_filename

    try:
        output_path.mkdir(parents=True, exist_ok=True)
        if parquet:
            final_peptide.to_parquet(output_file, index=False)
        else:
            final_peptide.to_csv(output_file, index=False, sep='\t')
        click.echo(f"Final file saved to: {output_file}")
    except Exception as e:
        click.echo(f"Error saving file to '{output_file}': {e}", err=True)

@click.command()
@click.argument('input_dir', type=click.Path(exists=True, file_okay=False, dir_okay=True))
@click.argument('output_dir', type=click.Path(file_okay=False, dir_okay=True))
@click.option('-f', '--full', is_flag=True, 
              help='Whether to get all information when merging files; default is partial information.')
@click.option('-v', '--verbose', is_flag=True, 
              help='Enable verbose logging output.')
@click.option('--parquet', is_flag=True, 
              help='Save the output file as Parquet instead of CSV.')
def cli_main(input_dir, output_dir, full, verbose, parquet):
    """Process TSV report files from an input directory and combine them into a single output file."""
    main(input_dir, output_dir, full, verbose, parquet)

if __name__ == '__main__':
    cli_main()
