#!/bin/bash

module load busco/5.1.3

# Define common variables
MODE="proteins"
THREADS=30
INPUT_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation"
OUTPUT_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/busco_entire_protein"
OUTPUT_NAME="busco_output"  # A simple name for the output, no slashes.

mkdir -p "${OUTPUT_DIR}"

cd "${INPUT_DIR}"

# Run BUSCO with the output name set to a simple identifier
# Note: Ensure your BUSCO config.ini file's out_path is set to ${OUTPUT_DIR} or use the --out_path parameter if supported.
busco -i Combined_Proteins.fasta \
      -o "${OUTPUT_NAME}" \
      -l eukaryota_odb10 \
      -m "${MODE}" \
      --cpu "${THREADS}" \
      --out_path "${OUTPUT_DIR}"  # Use this if your version of BUSCO supports the --out_path parameter directly

echo "BUSCO analysis completed for Combined_Proteins.fasta"
