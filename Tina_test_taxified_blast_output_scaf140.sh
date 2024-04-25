#!/bin/bash
#SBATCH --job-name=test_taxified_blast_output_scaf140
#SBATCH --time=0-5:00:00
#SBATCH --partition=comp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=30
#SBATCH --mem-per-cpu=10G
#SBATCH --cpus-per-task=1
#SBATCH --output=test_taxified_blast_output_scaf140.out
#SBATCH --error=test_taxified_blast_output_scaf140.err

cd ~/ha22_scratch/CapeWeed_Hap

module load blobtoolkit/1.1

blobtools taxify \

# specify the input hit file
-f test-blast-scaf140 \

# specify the input TaxID-mapping file
-m taxid_mapping_file.tsv \

# specify the columns of the sequence ID and the TaxID in the TaxID-mapping file, specify which columns of the TaxID-mapping file contain the relevant information for annotating the hit file
# search for the subject sequence ID (sseqid) in the zero-based column 0 of the TaxID-mapping file
-s 0 \
# extract the TaxID from the zero-based column 1 of the same file
-t 1 \

# specify the output file
-o test_taxified_blast_output_scaf140