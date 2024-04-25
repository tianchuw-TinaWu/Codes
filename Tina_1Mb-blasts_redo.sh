#!/bin/bash
#SBATCH --job-name=1Mb-blasts-redo
#SBATCH --time=10:00:00
#SBATCH --partition=comp
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=20gb
#SBATCH --output=1Mb-blasts-%a.out
#SBATCH --error=1Mb-blasts-%a.err
#SBATCH --array=144,149,150,156,165,167,168,176,178,203,206,212,218,229,239,240,242,244,250,262

cd ~/ha22_scratch/CapeWeed_Hap/scaffolds_for_blast/

N=$SLURM_ARRAY_TASK_ID
FASTA=$(cat fastalist.txt | head -n $N | tail -n 1)

module load blast+/2.9.0

time ~/om62/temp/ncbi-blast-2.15.0+/bin/blastn \
-query ${FASTA} \
-db ~/om62/nt/nt \
-task blastn \
-outfmt '6 qseqid staxids bitscore std' \
-max_target_seqs 1 \
-max_hsps 1 \
-evalue 1e-25 \
-out ${FASTA}-OUT \
-num_threads 32