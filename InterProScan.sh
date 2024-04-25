#!/bin/bash
#SBATCH -J InterProScan
#SBATCH -o InterProScan.out
#SBATCH -e InterProScan.err
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
PROTEINS_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/cleanup" # Directory containing your protein files

# Iterate over each protein file in the proteins directory
for PROT_FILE in ${PROTEINS_DIR}/*_proteins.fasta; do
  # Extract the chromosome name from the file name
  CHROMOSOME_NAME=$(basename $PROT_FILE _proteins.fasta)

  # Define output base
  OUT_BASE="${ANNOTATION_DIR}/interproscan/${CHROMOSOME_NAME}"

  mkdir -p "${ANNOTATION_DIR}/interproscan/"

  # Define log file path
  LOG_FILE="${LOG_DIR}/${CHROMOSOME_NAME}_interproscan.log"

  # Run InterProScan
  echo "Analysis starts for ${PROT_FILE}"
  interproscan.sh -i "${PROT_FILE}" \
      -b "${OUT_BASE}" \
      -f xml,gff3 \
      -goterms \
      --pathways \
      --seqtype p \
      --cpu 24 \
      --verbose &> "${LOG_FILE}"
  echo "Analysis completed for ${PROT_FILE}"
Done