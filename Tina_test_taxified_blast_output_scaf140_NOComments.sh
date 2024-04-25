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

blobtools taxify -f all-OUT -m ~/ha22_scratch/CapeWeed_Hap/taxid_mapping_file.tsv -s 0 -t 1 -o taxified_blast_output_all