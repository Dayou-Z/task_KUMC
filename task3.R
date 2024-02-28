# Check if packages are installed and install them if not
if (!requireNamespace("ggplot2", quietly = TRUE)){
  install.packages("ggplot2")
}

if (!requireNamespace("tidyverse", quietly = TRUE)){
  install.packages("tidyverse")
}


# Import packages
library(ggplot2)
library(tidyverse)

# Read gene_info file
gene_info <- read.table("Homo_sapiens.gene_info.gz", sep = '\t', fill = TRUE, comment.char = '', header = TRUE)

# Specify the order of chromosomes manually
chromosome_order <- c(paste0(1:22),"X","Y","MT","Un")

# Filter out unexpect chromosome
task3 <- gene_info_filtered <- gene_info %>%
  select(Symbol, chromosome) %>%
  #filter(!grepl("\\|", chromosome)) %>% # Filter the values contains a |, this step may be redundant here 
  filter(chromosome %in% chromosome_order)

# Adjust the order
gene_info_filtered$chromosome <- factor(gene_info_filtered$chromosome, levels = chromosome_order)

# Draw plot
task3_plt <- ggplot(gene_info_filtered, aes(x = chromosome)) + 
  geom_bar() +
  labs(title = "Number of genes in each chromosome", x = "Chromosomes", y = "Gene count") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

# Save pdf file for this task
ggsave("task3.pdf", task3_plt, width = 10, height = 5)
