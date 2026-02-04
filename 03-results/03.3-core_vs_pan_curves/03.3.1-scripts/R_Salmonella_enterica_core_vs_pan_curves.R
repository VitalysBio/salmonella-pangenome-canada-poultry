library(readr)
library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)


setwd("C:/Users/mliva/OneDrive/Desktop/R")

gpa <- read_csv("gene_presence_absence.csv")

genomes <- colnames(gpa)[4:ncol(gpa)]

# reviewing how empty fields are represented in the dataset
length(genomes)

sum(is.na(gpa[, genomes]))

sum(gpa[, genomes] == "", na.rm = TRUE)

colSums(is.na(gpa[, genomes]))

# This function estimates pangenome and core genome accumulation curves
# by repeatedly sampling random subsets of genomes without replacement. For each subset size.
# it computes the mean number of pan and core genes

pangenome_curve <- function(df, genomes, n_iter = 100) {
  
  pan <- numeric(length(genomes))
  core <- numeric(length(genomes))
  
  
  for (i in seq_along(genomes)) {
    
    pan_i <- numeric(n_iter)
    core_i <- numeric(n_iter)
    
    for (j in 1:n_iter) {
      
      subset <- sample(genomes, i)
      sub_df <- df[, subset]
      
      presence <- rowSums(!is.na(sub_df))
      
      pan_i[j]  <- sum(presence >= 1)
      core_i[j] <- sum(presence == i)
    }
    
    pan[i]  <- mean(pan_i)
    core[i] <- mean(core_i)
  }
  
  data.frame(
    Number_of_genomes = seq_along(genomes),
    Pan_genome  = pan,
    Core_genome = core
  )
}


curve_df <- pangenome_curve(gpa, genomes)

curve_long <- curve_df %>%
  pivot_longer(
    cols = c(Pan_genome, Core_genome),
    names_to = "Genome_type",
    values_to = "Gene_count"
  )


p <- ggplot(curve_long,
            aes(x = Number_of_genomes,
                y = Gene_count,
                color = Genome_type)) +
  geom_line(linewidth = 1.2) +
  labs(
    x = "Number of genomes",
    y = "Number of genes",
    color = ""
  ) +
  theme_bw() +
  theme(
    legend.position = "top",
    text = element_text(size = 12)
  )

print(p)

ggsave(
  filename = "pangenome_core_vs_pan_curve.png",
  plot = p,
  width = 8,
  height = 6,
  dpi = 300
)


 
# 95% confidence intervals based on bootstrap resampling.

pangenome_curve_ci <- function(df, genomes, n_iter = 100) {
  
  pan_mean  <- numeric(length(genomes))
  pan_low   <- numeric(length(genomes))
  pan_high  <- numeric(length(genomes))
  
  core_mean <- numeric(length(genomes))
  core_low  <- numeric(length(genomes))
  core_high <- numeric(length(genomes))
  
  for (i in seq_along(genomes)) {
    
    pan_i  <- numeric(n_iter)
    core_i <- numeric(n_iter)
    
    for (j in 1:n_iter) {
      
      subset <- sample(genomes, i)
      sub_df <- df[, subset]
      
      presence <- rowSums(!is.na(sub_df))
      
      pan_i[j]  <- sum(presence >= 1)
      core_i[j] <- sum(presence == i)
    }
    
    pan_mean[i] <- mean(pan_i)
    pan_low[i]  <- quantile(pan_i, 0.025)
    pan_high[i] <- quantile(pan_i, 0.975)
    
    core_mean[i] <- mean(core_i)
    core_low[i]  <- quantile(core_i, 0.025)
    core_high[i] <- quantile(core_i, 0.975)
  }
  
  data.frame(
    Number_of_genomes = seq_along(genomes),
    Pan_mean  = pan_mean,
    Pan_low   = pan_low,
    Pan_high  = pan_high,
    Core_mean = core_mean,
    Core_low  = core_low,
    Core_high = core_high
  )
}

curve_df <- pangenome_curve_ci(gpa, genomes, n_iter = 100)

dev.off()

p2 <- ggplot(curve_df, aes(x = Number_of_genomes)) +
  
  geom_ribbon(aes(ymin = Pan_low, ymax = Pan_high),
              fill = "steelblue", alpha = 0.3) +
  geom_line(aes(y = Pan_mean), color = "steelblue", linewidth = 1) +
  
  geom_ribbon(aes(ymin = Core_low, ymax = Core_high),
              fill = "firebrick", alpha = 0.3) +
  geom_line(aes(y = Core_mean), color = "firebrick", linewidth = 1) +
  
  labs(
    title = "Salmonella enterica core vs pan curves",
    x = "Number of genomes",
    y = "Number of genes"
  ) +
  theme_bw()

print(p2)

ggsave(
  filename = "pangenome_salmonella_enterica_core_vs_pan_curve_intervals.png",
  plot = p2,
  width = 8,
  height = 6,
  dpi = 300
)


