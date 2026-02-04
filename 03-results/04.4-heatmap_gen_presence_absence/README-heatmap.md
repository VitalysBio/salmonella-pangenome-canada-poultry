# Accessory Genome Presence–Absence Heatmap

## Overview

This code generates a binary presence–absence heatmap of accessory genes derived from a Panaroo pangenome analysis.
The heatmap visualizes gene presence (1) and absence (0) across multiple Salmonella enterica genomes, ordered according to a core-genome phylogeny, and annotated with functional gene descriptions and metadata.

The primary objective is to identify lineage-specific accessory gene patterns, with a particular focus on differentiating serovars. 

## Input Data

The pipeline relies on two main Panaroo outputs:

### gene_presence_absence.csv

Defines pangenome gene clusters (e.g. group_1502)

Contains per-genome annotation IDs indicating gene presence

Used to construct the presence–absence matrix

### gene_data.csv

Contains detailed annotations for individual genes

Includes functional descriptions (description)

Used to translate abstract pangenome cluster IDs into biologically labels

An external core-genome phylogenetic tree (e.g. generated with IQ-TREE) is used to define the ordering of genomes in the heatmap.

### Presence–Absence Matrix Construction

The presence–absence matrix is created by converting non-missing values in the Panaroo table into binary values:

1 indicates that a gene cluster is present in a genome

0 indicates absence

###  Functional Mapping

Panaroo assigns abstract cluster identifiers (e.g. group_1234) that are useful computationally but not biologically interpretable.
To enable biological interpretation of the heatmap, each pangenome cluster must be linked to a representative functional description.

This is achieved using three key functions described below.

#### Key Functions and Their Purpose
1. parse_ids(cell)

Purpose
Extracts individual gene annotation IDs from a single Panaroo cell.

A single pangenome cluster may contain:

Multiple genes per genome

Annotation IDs separated by delimiters (;, spaces, commas)

This function ensures all valid IDs are parsed consistently.


2. most_frequent_description_for_gene(row)

Purpose
Determines the most frequent functional description associated with a pangenome gene cluster.

Iterates over all genomes for a given cluster

Extracts all valid annotation IDs

Retrieves their functional descriptions from gene_data.csv

Selects the most common description using frequency counting

3. group_to_description mapping

Purpose
Creates a dictionary mapping Panaroo cluster IDs to functional gene descriptions.

Outcome

Translates pangenome-centric identifiers into interpretable biological labels

Enables readable heatmap row names

Preserves traceability between clusters and gene-level annotations

This mapping does not alter the data itself—only the labels used for visualization.

Filtering Hypothetical Proteins

Accessory genes annotated as hypothetical protein often dominate pangenomes and limit functional interpretation.

To address this, a logical mask is applied to:

Identify gene clusters annotated as hypothetical

Optionally exclude them from visualization

This allows focus on functionally interpretable variation

Transparent reporting of the proportion of hypothetical accessory genes

The heatmap is intended as an exploratory and comparative tool, providing a visual framework that motivates deeper functional annotation and statistical analysis.