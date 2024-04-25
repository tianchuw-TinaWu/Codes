#!/bin/bash
#SBATCH -J Trimmomatic_Trial
#SBATCH -o Trimmomatic_Trial.out
#SBATCH -e Trimmomatic_Trial.err
#SBATCH -n 1
#SBATCH -c 10
#SBATCH --mem-per-cpu=10G
#SBATCH -t 8:00:00

cd ~/ha22/capeweed-RNAseq-raw/AGRF_CAGRF23110274_22H37WLT3

# load trimmomatic module
module load trimmomatic

# run trimmomatic
java -jar /usr/local/trimmomatic/0.38/trimmomatic-0.38.jar \
    PE \
    -phred33 \
    -trimlog /home/tianchuw/ha22_scratch/CapeWeed_Hap/trimlog.txt \
    5262_22H37WLT3_ACGGTCAGGA-CGGCCTCGTT_L001_R1.fastq.gz \
    5262_22H37WLT3_ACGGTCAGGA-CGGCCTCGTT_L001_R2.fastq.gz \
    /home/tianchuw/ha22_scratch/CapeWeed_Hap/5262_22H37WLT3_ACGGTCAGGA-CGGCCTCGTT_L001_R1.paired.trimmed.fastq \
    /home/tianchuw/ha22_scratch/CapeWeed_Hap/5262_22H37WLT3_ACGGTCAGGA-CGGCCTCGTT_L001_R1.unpaired.trimmed.fastq \
    /home/tianchuw/ha22_scratch/CapeWeed_Hap/5262_22H37WLT3_ACGGTCAGGA-CGGCCTCGTT_L001_R2.paired.trimmed.fastq \
    /home/tianchuw/ha22_scratch/CapeWeed_Hap/5262_22H37WLT3_ACGGTCAGGA-CGGCCTCGTT_L001_R2.unpaired.trimmed.fastq \
    ILLUMINACLIP:/home/tianchuw/ha22_scratch/CapeWeed_Hap/Adaptors/combined_adapters.fa:5:10:5