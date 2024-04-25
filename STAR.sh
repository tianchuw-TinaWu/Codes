#!/bin/bash
#SBATCH -J STAR_Alignment
#SBATCH -o STAR_Alignment.out
#SBATCH -e STAR_Alignment.err
#SBATCH -n 12
#SBATCH --mem-per-cpu=100G
#SBATCH -t 7:00:00

# Load STAR module
module load star/2.7.10b

# Directory for the raw RNA-seq files (output from Trimmomatic)
raw_dir=~/ha22_scratch/CapeWeed_Hap

# Directory for the STAR genome index
genome_dir=~/ha22_scratch/CapeWeed_Hap/STAR_genomeDir
mkdir -p "$genome_dir"

# Replace with the path to the reference genome file
genome_fasta=~/ha22_scratch/CapeWeed_Hap/tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta


# Run STAR to generate the genome index
STAR --runMode genomeGenerate \
    --runThreadN 12 \
    --genomeDir "$genome_dir" \
    --genomeFastaFiles "$genome_fasta" \
    --limitGenomeGenerateRAM 100000000000 \
    --genomeSAindexNbases 13

# Iterate over each pair of trimmed files from Trimmomatic
for r1_file in ${raw_dir}/*_R1.paired.trimmed.fastq.gz; do
    r2_file="${r1_file/_R1.paired.trimmed/_R2.paired.trimmed}"
    
    # Run STAR for RNA-Seq mapping
    STAR --runThreadN 24 \
        --genomeDir "$genome_dir" \
        --readFilesIn "$r1_file" "$r2_file" \
        --readFilesCommand zcat
        # Add other STAR options as needed
done
