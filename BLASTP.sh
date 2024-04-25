#####
# capeweed vs arabidopsis TAIR10 blast
#####

# blast in interactive node

smux new-session \
--time=24:00:00 \
--ntasks=12

module load blast

# BLAST results with the top TAIR10 hit for each ragweed gene
blastp \
-query /home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/Combined_Proteins.fasta \
-db /home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/TAIR10DB/tair10_protein_db \
-max_target_seqs 1 \
-max_hsps 1 \
-outfmt '7 qseqid sseqid pident length qlen slen qstart qend sstart send evalue' \
-out /home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/Capeweed-TAIR10-blastp.txt \
-num_threads 12