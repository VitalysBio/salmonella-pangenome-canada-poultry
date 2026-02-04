#!/usr/bin/env bash
# ============================================================
# Prokka genome annotation pipeline
# ============================================================
# This script documents the Prokka annotation step used in this
# project. It was executed in a dedicated conda environment
# (prokka_env) with Prokka v1.14.6.
#
# NOTE:
# This script is provided for reproducibility and documentation.
# It does not need to be re-executed to reproduce the results
# included in this repository.
# ============================================================

set -euo pipefail

# -------------------------
# Software environment
# -------------------------
# Conda environment creation (executed once)
# conda create -n prokka_env -c conda-forge -c bioconda prokka=1.14.6
# conda activate prokka_env
#
# Database setup (executed once)
# prokka --listdb
# prokka --setupdb

# -------------------------
# Input / Output directories
# -------------------------
GENOMES_DIR="data/genomes/fasta_ready"
OUT_DIR="results/prokka"
THREADS=8

mkdir -p "$OUT_DIR"

# -------------------------
# Prokka annotation loop
# -------------------------
for f in "$GENOMES_DIR"/*.fna; do
  base=$(basename "$f" .fna)

  # Extract accession number as locus tag (last underscore-separated field)
  acc=$(echo "$base" | awk -F_ '{print $NF}')

  prokka \
    --outdir "$OUT_DIR/$base" \
    --prefix "$base" \
    --locustag "$acc" \
    --cpus "$THREADS" \
    --force \
    "$f"
done
