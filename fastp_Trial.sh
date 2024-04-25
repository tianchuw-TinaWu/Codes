#!/bin/bash
#SBATCH --job-name=fastp_Trial
#SBATCH --output=fastp_Trial.out
#SBATCH --error=fastp_Trial.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=20G
#SBATCH --time=08:00:00

# Navigate to the directory containing the raw data
cd ~/ha22/capeweed-RNAseq-raw/AGRF_CAGRF23110274_22H37WLT3

# Define input and output file names
R1_in="5262_22H37WLT3_ACGGTCAGGA-CGGCCTCGTT_L001_R1.fastq.gz"
R2_in="5262_22H37WLT3_ACGGTCAGGA-CGGCCTCGTT_L001_R2.fastq.gz"
R1_out="5262_22H37WLT3_ACGGTCAGGA-CGGCCTCGTT_L001_R1.trimmed_trial_fastp.fastq.gz"
R2_out="5262_22H37WLT3_ACGGTCAGGA-CGGCCTCGTT_L001_R2.trimmed_trial_fastp.fastq.gz"
json_out="fastp_Trial.json"
html_out="fastp_Trial.html"
output_dir="/home/tianchuw/ha22_scratch/CapeWeed_Hap/"

# load module fastp
module load fastp


# Run fastp
fastp \
    -i "$R1_in" \
    -I "$R2_in" \
    -o "${output_dir}/${R1_out}" \
    -O "${output_dir}/${R2_out}" \
    --detect_adapter_for_pe \
    --json "${output_dir}/${json_out}" \
    --html "${output_dir}/${html_out}" \
    --thread 10

echo "Trimming complete."
