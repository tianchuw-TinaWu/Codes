#!/bin/bash
#SBATCH -J Tina_repeatmodeler_db
#SBATCH -o Tina_repeatmodeler_db.out
#SBATCH -e Tina_repeatmodeler_db.err
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --partition=genomics
#SBATCH --qos=genomics
#SBATCH --mem-per-cpu=10G
#SBATCH -t 2:00:00

cd ~/ha22_scratch/CapeWeed_Hap

# load the module
module load repeatmasker/4.1.1

# build the database for repeatmodeler
BuildDatabase -name CapeweedRepeatsDB ~/ha22_scratch/CapeWeed_Hap/tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta
