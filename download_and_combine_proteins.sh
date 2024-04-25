#!/bin/bash

# Define directories for resources and logs
PROGRAM_RESOURCE_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap"
LOG_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Log_Dir"

# Create the necessary directories
mkdir -p "${PROGRAM_RESOURCE_DIR}/orthodb"
mkdir -p "${PROGRAM_RESOURCE_DIR}/uniprot"
mkdir -p "${LOG_DIR}/orthodb"
mkdir -p "${LOG_DIR}/uniprot"

# Notify the start of Viridiplantae OrthoDB proteins download
echo "Downloading Viridiplantae OrthoDB proteins..."

# Download the Viridiplantae OrthoDB protein file and decompress it
(wget --no-check-certificate https://bioinf.uni-greifswald.de/bioinf/partitioned_odb11/Viridiplantae.fa.gz -P "${PROGRAM_RESOURCE_DIR}" &&
gunzip -c "${PROGRAM_RESOURCE_DIR}/Viridiplantae.fa.gz" > "${PROGRAM_RESOURCE_DIR}/orthodb/Viridiplantae_protein.fasta") 2> "${LOG_DIR}/orthodb/ortho.log"


# Notify the start of Asteraceae proteins download from UniProtKB
echo "Downloading Asteraceae proteins from UniProtKB..."

# Use curl to download Asteraceae proteins from UniProtKB
# --output specifies the output file
# Errors during the download are logged
curl --output "${PROGRAM_RESOURCE_DIR}/uniprot/asteraceae_proteins.fasta" 'https://rest.uniprot.org/uniprotkb/stream?compressed=false&format=fasta&query=(taxonomy_name:asteraceae)' 2> "${LOG_DIR}/uniprot/asteraceae_proteins_dl.log"

# Notify that databases are being combined
echo "Combining databases..."

# Concatenate Asteraceae and Viridiplantae protein databases into one
# The final combined database is stored for further analysis
cat "${PROGRAM_RESOURCE_DIR}/uniprot/asteraceae_proteins.fasta" "${PROGRAM_RESOURCE_DIR}/orthodb/Viridiplantae_protein.fasta" > "${PROGRAM_RESOURCE_DIR}/allProteins.fasta"
