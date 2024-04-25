#!/bin/bash

# Define directories - Update these paths according to your file locations
ANNOT_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/TAIR10DB/"
BLAST_RESULTS_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/"
GFF_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/cleanup/"
GO_ANNOT_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/TAIR10DB/"

# Define input files - Ensure these filenames match your actual files
TAIR_DESC_FILE="${ANNOT_DIR}/TAIR10_functional_descriptions"
BLAST_FILE="${BLAST_RESULTS_DIR}/Capeweed-TAIR10-blastp.txt"
GFF_FILE="${GFF_DIR}/genes.filtered.gff"
GO_ANNOT_FILE="${GO_ANNOT_DIR}/ATH_GO_GOSLIM.txt"

# Step 1: Prepare a table of Arabidopsis IDs and their annotations
echo -e "athalID\tannotation" > temp.athal.annot
awk -F "\t" 'OFS = "\t" {print $1, $3}' "${TAIR_DESC_FILE}" | tail -n +2 >> temp.athal.annot

# Step 2: Prepare a table from BLAST results
echo -e "capeID\tathalID\tpercentID\tblasteval" > temp.blast
grep -v "#" "${BLAST_FILE}" | sed 's/-mRNA-1//' | awk 'OFS = "\t" {print $1, $2, $3, $11}' >> temp.blast

# Step 3: Prepare a table of gene locations from GFF
echo -e "contig\tstart\tend" > temp.capeweed.locs
awk '$3 == "gene" {print $1, $4, $5}' "${GFF_FILE}" >> temp.capeweed.locs

# Step 4: Prepare a list of Capeweed gene IDs
echo "ragID" > temp.capeweed.IDs
awk '$3 == "gene" {print $9}' "${GFF_FILE}" | awk -F ";" '{print $2"-RA"}' | sed 's/Name=//' >> temp.capeweed.IDs

# Step 5: Prepare a table of Arabidopsis IDs and their GO terms
echo -e "athalID\tGO" > temp.GOs
while read line; do
    name=$(echo $line | awk '{print $1}' | awk -F "." '{print $1}')
    egrep -w $name "${GO_ANNOT_FILE%.gz}" | awk -F "\t" '{print $3"\t"$6}' >> temp.GOs
done < temp.athal.annot

# Final step: Adjust GO terms table format
cat temp.GOs | sed -r 's/\.[0-9]+//' > temp.GOs2
