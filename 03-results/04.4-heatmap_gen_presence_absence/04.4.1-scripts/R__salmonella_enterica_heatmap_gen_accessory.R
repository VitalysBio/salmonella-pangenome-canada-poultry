library(tidyverse)
library(pheatmap)
library(ape)


setwd("C:/Users/mliva/OneDrive/Desktop/R")

df <- read.csv("gene_presence_absence.csv", check.names = FALSE)

genome_cols <- colnames(df)[4:ncol(df)]


pa_matrix <- df[, genome_cols]

n_genomes <- length(genome_cols)

table(is.na(pa_matrix))
table(pa_matrix == "")


pa_matrix <- ifelse(pa_matrix == "" | is.na(pa_matrix), 0, 1)
pa_matrix <- as.matrix(pa_matrix)
rownames(pa_matrix) <- df$Gene


acc_genes <- rowSums(pa_matrix) >= 2 & rowSums(pa_matrix) < n_genomes
pa_acc <- pa_matrix[acc_genes, ]


dim(pa_acc)

set.seed(42)
pa_acc <- pa_acc[sample(rownames(pa_acc), 100), ]

tree <- read.tree("salmonella_core.treefile")
genome_order <- tree$tip.label

pa_acc <- pa_acc[, genome_order]


meta <- tribble(
  ~Sample, ~Province, ~ST,
  "Alberta_EC20090641_SRR1183981", "Alberta", "Enteritidis",
  "Alberta_EC20090698_SRR1183982", "Alberta", "Enteritidis",
  "Alberta_EC20111514_GCF_000624295", "Alberta", "Enteritidis",
  "Alberta_EC20111515_GCF_000624315", "Alberta", "Enteritidis",
  "Alberta_EC20120677_GCF_000625755", "Alberta", "Enteritidis",
  "British_Columbia_EC20111510_GCF_000626555", "British_Columbia", "Enteritidis",
  "British_Columbia_EC20111554_GCF_000624335", "British_Columbia", "Enteritidis",
  "British_Columbia_EC20120685_GCF_000625535", "British_Columbia", "Enteritidis",
  "British_Columbia_EC20120686_GCF_000625555", "British_Columbia", "Enteritidis",
  "British_Columbia_EC20120765_GCF_000624995", "British_Columbia", "Enteritidis",
  "Nova_Scotia_EC20120590_GCF_000625495", "Nova_Scotia", "Enteritidis",
  "Ontario_EC20090135_SRR1183989", "Ontario", "Enteritidis",
  "Ontario_EC20090193_SRR1183988", "Ontario", "Enteritidis",
  "Ontario_EC20090332_SRR1183990", "Ontario", "Enteritidis",
  "Ontario_EC20100130_SRR1183993", "Ontario", "Enteritidis",
  "Ontario_EC20120916_GCF_000624155", "Ontario", "Enteritidis",
  "Quebec_N13-01311_SRR5239213", "Quebec", "Heidelberg",
  "Quebec_N13-01312_SRR5239201", "Quebec", "Heidelberg",
  "Quebec_N13-01323_SRR5241839", "Quebec", "Heidelberg",
  "Quebec_N13-01330_SRR5241836", "Quebec", "Heidelberg",
  "Quebec_N13-01348_SRR5241832", "Quebec", "Heidelberg",
  "New_Brunswick_N13-02934_SRR5241846", "New_Brunswick", "Heidelberg",
  "New_Brunswick_N13-02944_SRR5241820", "New_Brunswick", "Heidelberg",
  "New_Brunswick_N13-02946_SRR5241852", "New_Brunswick", "Heidelberg"
)


annotation_col <- meta %>%
  filter(Sample %in% genome_order) %>%
  arrange(match(Sample, genome_order)) %>%
  column_to_rownames("Sample") %>%
  select(Province)

province_colors <- c(
  Quebec = "#1f78b4",
  Ontario = "#33a02c",
  Alberta = "#e31a1c",
  New_Brunswick = "#ff7f00",
  British_Columbia = "#6a3d9a",
  Nova_Scotia = "#b15928"
)

ann_colors <- list(
  province = province_colors
)

p <- pheatmap(
  pa_acc,
  cluster_rows = TRUE,
  cluster_cols = FALSE,
  annotation_col = annotation_col,
  annotation_colors = ann_colors,
  color = c("purple", "yellow"),
  show_rownames = FALSE,
  fontsize_col = 8,
  border_color = NA, 
)

print(p)

ggsave(
  "R_salmonella_enterica_heatmap.png",
  p,
  width = 14,
  height = 10,
  dpi = 300
)
