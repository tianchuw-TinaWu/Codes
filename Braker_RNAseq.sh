#!/bin/bash
#SBATCH -J Braker_RNAseq
#SBATCH -o Braker_RNAseq.out
#SBATCH -e Braker_RNAseq.err
#SBATCH -n 30
#SBATCH --mem-per-cpu=10G
#SBATCH -t 24:00:00

# Load modules
module load braker3/3.0.3
module load genemark/4.30

# Define directories
MASKED_GENOME="/home/tianchuw/ha22_scratch/CapeWeed_Hap/tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta.masked"

ANNOTATION_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/"

GENEMARK="/usr/local/genemark/4.30"

# Log directory for storing log files (already defined above)
LOG_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Log_Dir"

# Ensure the output directory for BRAKER exists
mkdir -p "${ANNOTATION_DIR}/braker/rnaseq"
mkdir -p "${LOG_DIR}/braker"

# Running BRAKER in RNAseq-mode using the merged BAM file
echo "Running BRAKER in RNAseq-mode with RNAseq data..."
braker.pl --genome=${MASKED_GENOME} \
          --bam="${ANNOTATION_DIR}/Merge_BAM/allBams_merged.bam" \
          --softmasking \
          --useexisting \
          --GENEMARK_PATH=${GENEMARK} \
          --threads=30 \
          --workingdir=${ANNOTATION_DIR}/braker/rnaseq \
          --species="Arctotheca_calendula_rna" 2>${LOG_DIR}/braker/rnaseq.log
