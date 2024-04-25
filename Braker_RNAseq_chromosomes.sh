#!/bin/bash

# Define the directory containing chromosome fasta files
CHROMOSOME_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Chromosome_Dir"
ANNOTATION_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation"
GENEMARK="/usr/local/genemark/4.30"
LOG_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Log_Dir"

# New directory for storing BRAKER output per chromosome
BRAKER_CHROMOSOME_DIR="${ANNOTATION_DIR}/braker_rnaseq_chromosomes"

# Load required modules
module load braker3/3.0.3
module load genemark/4.30

# Ensure the new output directory for BRAKER exists
mkdir -p "${BRAKER_CHROMOSOME_DIR}"
mkdir -p "${LOG_DIR}/braker"

# Iterate over each chromosome fasta file and submit a Braker job
for CHROMOSOME_FASTA in ${CHROMOSOME_DIR}/*.fasta; do
    CHROMOSOME_NAME=$(basename "${CHROMOSOME_FASTA}" ".fasta")

    sbatch <<- EOF
		#!/bin/bash
		#SBATCH -J Braker_RNAseq_${CHROMOSOME_NAME}
		#SBATCH -o ${LOG_DIR}/braker/Braker_RNAseq_${CHROMOSOME_NAME}.out
		#SBATCH -e ${LOG_DIR}/braker/Braker_RNAseq_${CHROMOSOME_NAME}.err
		#SBATCH -n 30
		#SBATCH --mem-per-cpu=10G
		#SBATCH -t 24:00:00

		# Load modules
		module load braker3/3.0.3
		module load genemark/4.30

		# Running BRAKER in RNAseq-mode for each chromosome
		echo "Running BRAKER in RNAseq-mode for ${CHROMOSOME_NAME}..."
		braker.pl --genome=${CHROMOSOME_FASTA} \
		          --bam="${ANNOTATION_DIR}/Merge_BAM/allBams_merged.bam" \
		          --softmasking \
		          --useexisting \
		          --GENEMARK_PATH=${GENEMARK} \
		          --threads=30 \
		          --workingdir=${BRAKER_CHROMOSOME_DIR}/${CHROMOSOME_NAME} \
		          --species="Arctotheca_calendula_rna_${CHROMOSOME_NAME}" 2>${LOG_DIR}/braker/rnaseq_${CHROMOSOME_NAME}.log
	EOF
done