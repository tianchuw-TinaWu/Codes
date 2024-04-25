#!/bin/bash
#SBATCH -J Trimmomatic_All
#SBATCH -o Trimmomatic_All.out
#SBATCH -e Trimmomatic_All.err
#SBATCH -n 1
#SBATCH -c 10
#SBATCH --mem-per-cpu=10G
#SBATCH -t 8:00:00

# Load Trimmomatic module
module load trimmomatic

# Directory for the raw RNA-seq files
raw_dir=~/ha22/capeweed-RNAseq-raw/AGRF_CAGRF23110274_22H37WLT3

# Directory for the output files
output_dir=/home/tianchuw/ha22_scratch/CapeWeed_Hap

# Adapter file
adapter_file=/home/tianchuw/ha22_scratch/CapeWeed_Hap/Adaptors/combined_adapters.fa

# Iterate over each pair of files
for r1_file in ${raw_dir}/*_R1.fastq.gz; do
        # Construct the R2 filename by replacing R1 with R2 in the current filename
    r2_file="${r1_file/_R1/_R2}"

        # Remove the .gz extension for output files
    r1_base=${r1_file%.fastq.gz}
    r2_base=${r2_file%.fastq.gz}

    # Output file names
    r1_paired="${output_dir}/$(basename ${r1_base}).paired.trimmed.fastq"
    r1_unpaired="${output_dir}/$(basename ${r1_base}).unpaired.trimmed.fastq"
    r2_paired="${output_dir}/$(basename ${r2_base}).paired.trimmed.fastq"
    r2_unpaired="${output_dir}/$(basename ${r2_base}).unpaired.trimmed.fastq"

    # Run Trimmomatic and append to the same trimlog file
    java -jar /usr/local/trimmomatic/0.38/trimmomatic-0.38.jar \
           PE \
        -phred33 \
        -trimlog /home/tianchuw/ha22_scratch/CapeWeed_Hap/trimlog_all.txt \
        "$r1_file" \
        "$r2_file" \
        "$r1_paired" \
        "$r1_unpaired" \
        "$r2_paired" \
        "$r2_unpaired" \
        ILLUMINACLIP:"$adapter_file":2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done