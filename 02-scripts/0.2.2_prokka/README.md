### Prokka genome annotation

Genome annotation was performed using Prokka v1.14.6 in a dedicated
conda environment (`prokka_env`).

### Environment setup
```bash
conda create -n prokka_env -c conda-forge -c bioconda prokka=1.14.6
conda activate prokka_env
prokka --listdb
prokka --setupdb´´´

### Input

Genome FASTA files located in:
data/genomes/fasta_ready/

### File naming convention:

<region>_<name>_<accession_no>.fna

### Output

Prokka outputs were written to:

results/prokka/<sample_fasta>/

### Execution

Prokka was executed using the script:

02-scripts/2_prokka/run_prokka.sh


The script is provided for documentation and reproducibility purposes.
The results included in this repository were generated prior to
publication and do not require re-execution.
