#!/bin/bash
#SBATCH -J EggNogMapper             
#SBATCH -o EggNogMapper.out      
#SBATCH -e EggNogMapper.err
#SBATCH -n 1                  
#SBATCH -c 24                
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user=twuu0033@student.monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

# Directories and file paths
ANNOTATION_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation"
ASSEMBLY_NAME="CW"
LOG_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Log_Dir"
PROTEIN_INPUT="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/Combined_Proteins.fasta"
EGGNOG_DB_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/EggNogMapper/33090"

# Output and log file paths
ANNOTATION_OUTPUT="${ANNOTATION_DIR}/EggNogMapperOutput/${ASSEMBLY_NAME}.emapper.annotations"
LOG_FILE="${LOG_DIR}/eggnog/eggnog_mapper.log"

# Number of threads to use
THREADS=24

# Ensure the log directory exists
mkdir -p "${LOG_DIR}/eggnog"

# Activate the Conda environment
source /scratch/sd26/tianchuw/miniconda/conda/envs/eggnog_env/bin/emapper.py
conda activate eggnog_env

# Run EggNOG-mapper
emapper.py -i "${PROTEIN_INPUT}" \
           --data_dir "${EGGNOG_DB_DIR}" \
           --cpu ${THREADS} \
           --itype proteins \
           -o "${ANNOTATION_OUTPUT}" \
           --override &> "${LOG_FILE}"
