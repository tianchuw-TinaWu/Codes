#!/bin/bash
#SBATCH -J Capeweed_repeatmasker
#SBATCH -o Capeweed_repeatmasker.out
#SBATCH -e Capeweed_repeatmasker.err
#SBATCH -n 1
#SBATCH -c 10
#SBATCH --mem-per-cpu=10G
#SBATCH -t 8:00:00

cd ~/ha22_scratch/CapeWeed_Hap

# load modules
module load repeatmasker/4.1.1

# Path to original genome file
GENOME_FILE=~/ha22_scratch/CapeWeed_Hap/tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta

# Path to repeat library
LIBRARY=~/ha22_scratch/CapeWeed_Hap/RM_35592.SunDec310905172023/consensi.fa.classified 

# Perform soft masking (repeats to lowercase)
RepeatMasker -pa 10 -gff -lib $LIBRARY -xsmall $GENOME_FILE