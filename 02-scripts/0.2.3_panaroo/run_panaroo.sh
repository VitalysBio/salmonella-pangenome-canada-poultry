#!/usr/bin/env bash
# ============================================================
# Panaroo pangenome analysis pipeline
# ============================================================
# This script documents the pangenome analysis performed using
# Panaroo v1.5.2 and Biopython v1.78.
#
# NOTE:
# This script is provided for documentation and reproducibility
# purposes only. It does not need to be re-executed to reproduce
# the results included in this repository.
# ============================================================

set -euo pipefail

# -------------------------
# Software environment
# -------------------------
# Panaroo was executed in a dedicated environment with:
# - panaroo v1.5.2
# - biopython v1.78

# -------------------------
# Input / Output directories
# -------------------------
PROKKA_OUT_DIR="results/prokka"
PANAROO_GFF_DIR="data/genomes/panaroo_gff"
OUT_DIR="results/panaroo"
THREADS=8

mkdir -p "$PANAROO_GFF_DIR"
mkdir -p "$OUT_DIR"

# -------------------------
# Collect GFF files
# -------------------------
find "$PROKKA_OUT_DIR" -name "*.gff" -exec cp {} "$PANAROO_GFF_DIR"/ \;

# -------------------------
# Run Panaroo
# -------------------------
panaroo \
  -i "$PANAROO_GFF_DIR"/*.gff \
  -o "$OUT_DIR" \
  --clean-mode strict \
  --alignment core \
  --core_threshold 0.99 \
  --threads "$THREADS"
