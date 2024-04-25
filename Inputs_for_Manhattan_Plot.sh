awk '$3 == "similarity" && $2 == "RepeatMasker" {print $1, $4, $5, $9}' tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta.out.gff > repeats_mapped_to_chromosomes_with_motifs.txt

awk '$3 > $2' repeats_mapped_to_chromosomes_with_motifs.txt > repeats_mapped_to_chromosomes.txt

awk '$3 == "gene" {print $1, $4, $5, "gene"}' genes.filtered.gff > genes_mapped_to_chromosomes.txt


awk '/^>/{if (seqlen){print seqname,seqlen}; seqname=$0; seqlen=0; next}{seqlen+=length($0)}
     END{print seqname,seqlen}' tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta.masked | sed 's/>//g' > chromo-length.txt