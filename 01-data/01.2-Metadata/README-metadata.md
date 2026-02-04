## Data overview

This repository includes genomic data and metadata used for the pangenome analysis of *Salmonella enterica* isolates associated with poultry production in Canada.

### Genome selection and provenance

Genomes were initially identified using EnteroBase by applying the following filters:
- Species: *Salmonella enterica*
- Source niche: poultry
- Country: Canada

The corresponding metadata were downloaded from EnteroBase and used as the basis for genome selection and quality assessment.

### Genome quality control and selection

All candidate genomes were evaluated using a quality control procedure based on assembly metrics. For each assembly, a composite quality score (`quality_score`) was calculated by integrating:
- Assembly continuity (N50)
- Sequencing depth (coverage)
- Assembly fragmentation (number of contigs ≥200 bp)

Genomes were then grouped by geographic region. Within each region, the five assemblies with the highest quality scores were selected. This stratified sampling strategy was used to:
- Maximize the overall quality of the final dataset
- Preserve regional representativeness
- Avoid bias caused by over-representation of regions with higher numbers of available isolates

Only the top-ranked genomes per region, together with their associated metadata and quality metrics, were retained for downstream analyses.

### FASTA retrieval and assembly sources

Genome FASTA files were obtained from two sources:

- **NCBI assemblies (GCF accessions)**  
  Genomes with RefSeq assembly accessions (GCF) were downloaded using NCBI Datasets.

  
- **EnteroBase assemblies (SRR accessions)**  
For genomes without RefSeq assemblies, FASTA files were retrieved directly from EnteroBase. These assemblies were generated using the EnteroBase internal pipeline (SPAdes followed by polishing).

### File naming convention

All genome FASTA files were renamed using the following convention to ensure consistency across analyses:
<region>_<name>_<accession_no>.fasta

This naming scheme is used consistently throughout the pangenome, phylogenetic, and functional analyses.




