#!/bin/bash
#SBATCH -J Braker_Protein
#SBATCH -o Braker_Protein.out
#SBATCH -e Braker_Protein.err
#SBATCH -n 30
#SBATCH --mem-per-cpu=10G
#SBATCH -t 7-00:00:00

# Load modules
module load braker3/3.0.3
module load genemark/4.30
module load prothint/2.6.0

# Define paths for input files and tools
PROTEINS="/home/tianchuw/ha22_scratch/CapeWeed_Hap/allProteins.fasta"

MASKED_GENOME="/home/tianchuw/ha22_scratch/CapeWeed_Hap/tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta.masked"

ANNOTATION_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation" 

GENEMARK="/usr/local/genemark/4.30"

PROTHINT="/usr/local/Prothint/2.6.0"

LOG_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Log_Dir/braker"

# Create output and log directories if they don't exist
mkdir -p "${ANNOTATION_DIR}/braker/protein"
mkdir -p "${LOG_DIR}/protein"

# Define species name
SPECIES="Arctotheca calendula, Asteraceae prot"

# Run BRAKER in protein-mode
braker.pl --genome ${MASKED_GENOME} \
   --prot_seq ${PROTEINS} \
   --softmasking \  # Instructs BRAKER to treat lowercase letters in the genome as masked
   --useexisting \  # Tells BRAKER to use existing files in the working directory if available, avoiding re-running parts of the pipeline unnecessarily
   --GENEMARK_PATH ${GENEMARK} \
   --PROTHINT_PATH ${PROTHINT} \
   --threads 30 \
   --workingdir "${ANNOTATION_DIR}/braker/protein" \
   --species "${SPECIES}" 2> "${LOG_DIR}/protein.log"