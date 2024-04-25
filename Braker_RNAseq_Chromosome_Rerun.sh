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

# Define the names of the chromosomes to rerun
RERUN_CHROMOSOMES=(
"tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta.masked_Scaffold_7__1_contigs__length_72938892.fasta"
"tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta.masked_Scaffold_10__2_contigs__length_75131717.fasta"
)

# Iterate over each chromosome fasta file and submit a Braker job only for specified chromosomes
for CHROMOSOME_FASTA in ${CHROMOSOME_DIR}/*.fasta; do
    CHROMOSOME_NAME=$(basename "${CHROMOSOME_FASTA}")
    
    # Check if the current chromosome is in the list of chromosomes to rerun
    if [[ " ${RERUN_CHROMOSOMES[@]} " =~ " ${CHROMOSOME_NAME} " ]]; then
        sbatch <<- EOF
			#!/bin/bash
			#SBATCH -J Braker_RNAseq_${CHROMOSOME_NAME}
			#SBATCH -o ${LOG_DIR}/braker/Braker_RNAseq_${CHROMOSOME_NAME}.out
			#SBATCH -e ${LOG_DIR}/braker/Braker_RNAseq_${CHROMOSOME_NAME}.err
			#SBATCH -n 30
			#SBATCH --mem-per-cpu=20G  # Increased memory per CPU
			#SBATCH --mem=600G         # Total job memory request
			#SBATCH -t 7-00:00:00        # Increased time limit

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
    fi
done
