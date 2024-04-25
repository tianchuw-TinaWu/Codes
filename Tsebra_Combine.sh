#!/bin/bash
#SBATCH -J Tsebra_Combine             
#SBATCH -o Tsebra_Combine.out      
#SBATCH -e Tsebra_Combine.err
#SBATCH -n 1                  
#SBATCH -c 30                
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user=twuu0033@student.monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -t 01:00:00

RNA_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/braker_rnaseq_chromosomes"
PROTEIN_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/braker_protein_chromosomes"
COMBINED_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/tsebra_combined"
CONFIG_PATH="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/TSEBRA/bin/"
LOG_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Log_Dir/tsebra"

# Ensure the combined output directory exists
mkdir -p "${COMBINED_DIR}"
mkdir -p "${LOG_DIR}"

# Iterate over the protein mode output directories
for PROTEIN_PATH in ${PROTEIN_DIR}/*; do
    CHROMOSOME_NAME=$(basename "${PROTEIN_PATH}")
    
    # Define paths to the RNAseq and protein mode GTF files for the current chromosome
    RNA_GTF="${RNA_DIR}/${CHROMOSOME_NAME}/braker.gtf"
    PROTEIN_GTF="${PROTEIN_DIR}/${CHROMOSOME_NAME}/braker.gtf"
	RNA_GFF="${RNA_DIR}/${CHROMOSOME_NAME}/hintsfile.gff"
	PROTEIN_GFF="${PROTEIN_DIR}/${CHROMOSOME_NAME}/hintsfile.gff"
    
    # Define output path
    COMBINED_GTF="${COMBINED_DIR}/${CHROMOSOME_NAME}_combined.gtf"
    
    # Log file path
    LOG_FILE="${LOG_DIR}/${CHROMOSOME_NAME}.log"

    # Run TSEBRA
    echo "Combining evidence for ${CHROMOSOME_NAME}..."
    ${CONFIG_PATH}/tsebra.py -g "${RNA_GTF},${PROTEIN_GTF}" \
              -e "${RNA_GFF}","${PROTEIN_GFF}" \
              -o "${COMBINED_GTF}" 2> "${LOG_FILE}"
done

echo "TSEBRA combination completed."