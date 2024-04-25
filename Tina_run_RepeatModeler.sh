#!/bin/bash
#SBATCH -J Tina_repeatmodeler
#SBATCH -o Tina_repeatmodeler.out
#SBATCH -e Tina_repeatmodeler.err
#SBATCH -n 4
#SBATCH -c 10
#SBATCH --mem-per-cpu=100G
#SBATCH -t 60:00:00

cd ~/ha22_scratch/CapeWeed_Hap

# load modules
module load repeatmasker/4.1.1

# BuildDatabase for repeatmodeler2
RepeatModeler -database CapeweedRepeatsDB -pa 40 -LTRStruct