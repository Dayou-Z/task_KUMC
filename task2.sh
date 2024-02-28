#!/bin/bash


# Download the FASTA file
fasta_url="https://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.faa"
fasta_file="NC_000913.faa" 

wget "$fasta_url" -O "$fasta_file"

# Count number of sequences and number of amino acids
num_sequence=$(grep -c "^>" "$fasta_file")
num_aa=$(grep -v "^>" "$fasta_file" | tr -d '\n' | wc -c)

# Pirnt number of sequences and amino acids

echo "Total sequences: $num_sequence"
echo "Total amino acids: $num_aa"

# Count average length, keep integer
ave_length=$(echo "$num_aa / $num_sequence" | bc)

# Print final average length
echo "Average length of protein: $ave_length"
