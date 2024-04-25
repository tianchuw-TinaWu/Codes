#!/bin/bash
#SBATCH -J STAR_Alignment
#SBATCH -o STAR_Alignment_%a.out
#SBATCH -e STAR_Alignment_%a.err
#SBATCH -n 12
#SBATCH --mem-per-cpu=100G
#SBATCH -t 24:00:00
#SBATCH --array=1-12

N=$SLURM_ARRAY_TASK_ID

r1_file=$(cat r1_file_list.txt | head -n $N | tail -n 1)

# Load STAR module
module load star/2.7.10b

# Directory for the raw RNA-seq files (output from Trimmomatic)
raw_dir=~/ha22_scratch/CapeWeed_Hap

# Directory for the STAR genome index
genome_dir=~/ha22_scratch/CapeWeed_Hap/STAR_genomeDir

# Replace with the path to the reference genome file
genome_fasta=~/ha22_scratch/CapeWeed_Hap/tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta.masked

# Iterate over each pair of trimmed files from Trimmomatic
    r2_file="${r1_file/_R1.paired.trimmed/_R2.paired.trimmed}"
    r1_base="${r1_file%.paired.trimmed.fastq}"
    
    # Run STAR for RNA-Seq mapping
    STAR --runThreadN 12 \
        --genomeDir "$genome_dir" \
        --readFilesIn "$r1_file" "$r2_file" \
        --readFilesCommand cat \
        --twopassMode Basic \
        --alignIntronMax 10000 \
        --outSAMtype BAM SortedByCoordinate \
        --outFileNamePrefix "$r1_base" 		
        # Add other STAR options as needed