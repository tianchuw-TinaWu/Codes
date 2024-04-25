module purge
module load minimap2

minimap2 \
-t 12 -P -k19 -w19 -m200 \
tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta.masked \
tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta.masked \
> self_comparison.paf