#!/bin/bash
#SBATCH --job-name=test-blast-scaf30
#SBATCH --time=7-00:00:00
#SBATCH --partition=comp
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=20gb
#SBATCH --output=test-blast-scaf30.out
#SBATCH --error=test-blast-scaf30.err

cd ~/om62/temp

module load blast+/2.9.0

time ~/om62/temp/ncbi-blast-2.15.0+/bin/blastn \
-query ~/ha22_scratch/CapeWeed_Hap/Scaffold_30.fasta \
-db ~/om62/nt/nt \
-task blastn \
-outfmt '6 qseqid staxids bitscore std' \
-max_target_seqs 1 \
-max_hsps 1 \
-evalue 1e-25 \
-out ~/ha22_scratch/CapeWeed_Hap/test-blast-scaf30 \
-num_threads 32