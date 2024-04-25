#!/bin/bash
#SBATCH -J InterProScan_Proteins
#SBATCH -o InterProScan_Proteins.out
#SBATCH -e InterProScan_Proteins.err
#SBATCH -n 1
#SBATCH -c 24
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user=twuu0033@student.monash.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

# Load the module
module load interproscan/5.66-98.0

# Define directories
ANNOTATION_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/"
LOG_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Log_Dir"
PROTEINS_FILE="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/Combined_Proteins.fasta"

# Define log file path
LOG_FILE="${LOG_DIR}/all_proteins_interproscan.log"
OUT_BASE="${ANNOTATION_DIR}/interproscan/"

# Run InterProScan
interproscan.sh -i "${PROTEINS_FILE}" \
    -o "${OUT_BASE}" \
    -f xml,gff3 \
    -goterms \
    --pathways \
    --seqtype p \
    --cpu 24 \
    --verbose &> "${LOG_FILE}"