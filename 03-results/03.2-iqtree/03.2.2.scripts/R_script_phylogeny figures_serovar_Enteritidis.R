library(ggtree)
library(ape)
library(tidyverse)
library(tidytree)

setwd("C:/Users/mliva/OneDrive/Desktop/R")

# tree file
tree <- read.tree("salmonella_no_QC_NB.treefile")

# Adjusting the distance of the clades
tree$edge.length <- sqrt(tree$edge.length)

# Reorder for clear reading
tree <- ladderize(tree, right = TRUE)

# Create metadata
metadata <- tribble(
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


# group per province
province_groups <- split(metadata$Sample, metadata$Province)
tree_grouped <- groupOTU(tree, province_groups, group_name = "Province")

# province colors
colores_province <- c("0" = "gray50", "Alberta" = "#AAF10E", "Ontario" = "#550EF1", 
                "British_Columbia" = "#F10E38", "Nova_Scotia" = "#F6E609", 
                "Quebec" = "#F7083E", "New_Brunswick" = "#08F7C1")

# tree 
tree_data <- fortify(tree_grouped)

# Extract only the first value from the bootstrap
tree_data$bootstrap_simple <- sapply(tree_data$label, function(x) {
  if (is.na(x) || x == "") {
    return(NA)
  } else if (grepl("/", x)) {
    val <- as.numeric(strsplit(x, "/")[[1]][1])
    return(round(val, 1))  # Redondear a 1 decimal
  } else {
    val <- as.numeric(x)
    if (!is.na(val)) return(round(val, 1))
    return(NA)
  }
})

# plot
p <- ggtree(tree_grouped, aes(color = Province), layout = "rectangular", linewidth = 0.8) %<+% tree_data +
  geom_tiplab(aes(color = Province), size = 2.8, hjust = -0.02) +
  geom_tippoint(aes(color = Province), size = 1.5) +
  geom_text(
    aes(
      x = branch,
      label = ifelse(!is.na(bootstrap_simple) & bootstrap_simple >= 70,
                     bootstrap_simple, "")
    ),
    size = 3.2,
    vjust = -0.6,
    hjust = 0.5,
    fontface = "bold",
    color = "#16796f",
    na.rm = TRUE
  ) +
  xlim(NA, max(tree_data$x, na.rm = TRUE) * 1.8) +
  theme(
    legend.position = c(0.95, 0.95),
    legend.justification = c(1, 1),
    legend.background = element_rect(fill = "white", color = "gray70", linewidth = 0.5),
    legend.title = element_text(face = "bold", size = 10),
    legend.text = element_text(size = 9),
    plot.margin = margin(10, 120, 10, 10)
  ) +
  labs(
    title = "Phylogenetic tree of Salmonella enterica subsp. enterica serovar enteritidis"
  )


print(p)

setwd("C:/Users/mliva/OneDrive/Desktop/R/Finales/con_sqt_raices")

ggsave("R_salmonella_enterica_enteritidis_tree_figure.pdf", p, width = 14, height = 10)

p <- p +
  theme(
    legend.background = element_rect(fill = "transparent", colour = NA),
    legend.key        = element_rect(fill = "transparent", colour = NA),
    legend.text       = element_text(color = "black"),
    legend.title      = element_text(color = "black")
  )


ggsave(
  "R_salmonella_enterica_enteritidis_tree_figure.png",
  p,
  width = 14,
  height = 10,
  dpi = 300,
  bg = "transparent"
)