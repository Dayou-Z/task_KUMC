# Check if packages are installed and install them if not
if (!requireNamespace("optparse", quietly = TRUE)){
  install.packages("optparse")
}

if (!requireNamespace("tidyverse", quietly = TRUE)){
  install.packages("tidyverse")
}


# Import packages
library(optparse)
library(tidyverse)


# Create flag options
option_list <- list(
  make_option(c('--infofile'), type = 'character', help = "Path to gene info file"),
  make_option(c('--gmtfile'), type = 'character', help = "Path to gmt file")
)


# Parse arguments from command line
opt <- parse_args(OptionParser(option_list = option_list))


# Check if all arguments provided, if not, print help
if (is.null(opt$infofile) || is.null(opt$gmtfile)) {
  stop('Provide path to gene info using --infofile and to gmt file using --gmtfile.')
}


# Read input files
gene_info <- read.table(opt$infofile, sep = '\t', fill = TRUE, comment.char = '', header = TRUE)
gmt <- readLines(opt$gmtfile)


# Create mapping from symbol/synonyms to EntrezID
mapping <- gene_info %>% 
  select(GeneID,Symbol,Synonyms) %>%
  unite(names, Symbol, Synonyms, sep = '|') %>%
  separate_rows(names, sep = '\\|')


# Create empty list
new_gmt<- rep(NA, length(gmt))


# Rewrite the gmt file by line
for (i in 1:length(gmt)) {
  splited_list <- strsplit(gmt[i], '\t')
  
  prefix <- paste(splited_list[[1]][1:2],collapse = '\t') # Pathway names and description
  df <- data.frame(matrix(unlist(splited_list)))
  df <- data.frame(names = df[-(1:2),])
  
  # Convert from gene name to ID
  df_merged <- merge(df,mapping , by = 'names', sort = FALSE, all.x = TRUE)
  df_merged$final <- ifelse(!is.na(df_merged$GeneID), df_merged$GeneID, df_merged$names)
  suffix <- paste(df_merged$final,collapse = '\t')
  final <- paste(prefix,suffix,collapse = '\t') 
  new_gmt[i] <- final
}


# Write new gmt file
writeLines(new_gmt, "h.all.v2023.1.Hs.symbols.new.gmt")
