#!/bin/bash
#SBATCH -J Tina_repeatmodeler
#SBATCH -o Tina_repeatmodeler.out
#SBATCH -e Tina_repeatmodeler.err
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=10G
#SBATCH -t 7-00:00:00

cd ~/ha22_scratch/CapeWeed_Hap

# load modules
module load repeatmasker/4.1.1

# BuildDatabase for repeatmodeler
RepeatModeler -database CapeweedRepeatsDB -pa 10 -LTRStruct -recoverDir ~/ha22_scratch/CapeWeed_Hap/RM_35592.SunDec310905172023/