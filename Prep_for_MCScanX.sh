#!/bin/bash

module load blast

cd /home/tianchuw/ha22_scratch/CapeWeed_Hap/Sunflower_Comparison

blastp -query Lsativa_467_v5.protein_primaryTranscriptOnly.fa \
-db Combined_Proteins.fasta \
-evalue 1e-10 \
-outfmt 6 \
-max_target_seqs 5 \
-out Lettuce_vs_Capeweed.blast

blastp -query Combined_Proteins.fasta \
-db Lsativa_467_v5.protein_primaryTranscriptOnly.fa \
-evalue 1e-10 \
-outfmt 6 \
-max_target_seqs 5 \
-out Capeweed_vs_Lettuce.blast
