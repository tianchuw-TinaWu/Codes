#!/bin/bash
#SBATCH -J Merge_BAM
#SBATCH -o Merge_BAM.out
#SBATCH -e Merge_BAM.err
#SBATCH -n 3
#SBATCH --mem-per-cpu=10G
#SBATCH -t 7:00:00

# load the module
module load samtools

# Define directories
BAM_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/"
ANNOTATION_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation"
LOG_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Log_Dir"

# Create necessary directories
mkdir -p "${ANNOTATION_DIR}/Merge_BAM"
mkdir -p "${LOG_DIR}/Merge_BAM"

# Merging STAR-aligned RNAseq reads into a single BAM file
echo "Merging STAR-aligned RNAseq reads into a single BAM file..."
samtools merge -@ 3 -r "${ANNOTATION_DIR}/Merge_BAM/allBams_merged.bam" ${BAM_DIR}/*Aligned.sortedByCoord.out.bam 2> "${LOG_DIR}/Merge_BAM/bams_merge.log"

# Indexing the merged BAM file
echo "Indexing the merged BAM file..."
samtools index "${ANNOTATION_DIR}/Merge_BAM/allBams_merged.bam" 2>> "${LOG_DIR}/Merge_BAM/bams_merge.log"
