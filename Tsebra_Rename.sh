#!/bin/bash

# Define directories
ANNOTATION_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/"
LOG_DIR="home/tianchuw/ha22_scratch/Log_Dir/tsebra_renamed/"
RENAME_GTF_PY_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/TSEBRA/bin/"
INPUT_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/tsebra_combined/"
OUTPUT_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/tsebra_renamed/"

# Make new directory
mkdir -p "${LOG_DIR}"
mkdir -p "${OUTPUT_DIR}"

# Loop through each GTF file
for gtf_file in ${INPUT_DIR}/*.gtf; do
    echo "Processing $gtf_file"

    # Define output names based on input file
    gtf_output="${OUTPUT_DIR}/$(basename "${gtf_file%.gtf}")_renamed.gtf"
    tab_output="${OUTPUT_DIR}/$(basename "${gtf_file%.gtf}")_rename_translationTab.txt"
    log_file="${LOG_DIR}/$(basename "${gtf_file%.gtf}")_rename_gtf.log"

    # Define the prefix to use for renaming
    BASENAME="$(basename "${gtf_file%.gtf}")"
    PREFIX="CW_"${BASENAME}""

    # Run the rename_gtf.py script
    ${RENAME_GTF_PY_DIR}/rename_gtf.py --gtf "$gtf_file" \
                  --prefix "$PREFIX" \
                  --translation_tab "$tab_output" \
                  --out "$gtf_output" 2> "$log_file"
    
    echo "Finished processing $gtf_file"
done

echo "All files processed."
