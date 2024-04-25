#!/bin/bash

# Define file paths
GFF_FILE="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/cleanup/genes.filtered.gff"
BLASTP_OUTPUT="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/Capeweed-TAIR10-blastp.txt"
ANN_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/"
FUNCTIONAL_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/TAIR10DB/TAIR10_functional_descriptions"
# Add paths for any additional files needed for functional categories

# Calculate basic statistics
num_genes=$(grep -v "^#" $GFF_FILE | awk '$3 == "gene"' | wc -l)
num_exons=$(grep -v "^#" $GFF_FILE | awk '$3 == "exon"' | wc -l)
num_introns=$(grep -v "^#" $GFF_FILE | awk '$3 == "intron"' | wc -l)
avg_gene_size=$(grep -v "^#" $GFF_FILE | awk '$3 == "gene"' | awk '{sum += $5-$4+1} END {print sum/NR}')
avg_exon_size=$(grep -v "^#" $GFF_FILE | awk '$3 == "exon"' | awk '{sum += $5-$4+1} END {print sum/NR}')
avg_intron_size=$(grep -v "^#" $GFF_FILE | awk '$3 == "intron"' | awk '{sum += $5-$4+1} END {print sum/NR}')

# Assume BLASTP_OUTPUT variable holds the path to your BLASTP output file
cat $BLASTP_OUTPUT | grep ".t1" | awk '$1 !~ /^#/ {print $3}' > percent_identities.txt

highly_conserved=0
moderately_conserved=0
less_conserved=0

while read percent; do
    if (( $(echo "$percent > 80" | bc -l) )); then
        ((highly_conserved++))
    elif (( $(echo "$percent >= 50 && $percent <= 80" | bc -l) )); then
        ((moderately_conserved++))
    else
        ((less_conserved++))
    fi
done < percent_identities.txt

total_hits=$(wc -l < percent_identities.txt)

# Calculate BLASTP-based statistics
percent_highly=$(echo "scale=2; ($highly_conserved/$total_hits)*100" | bc)
percent_moderately=$(echo "scale=2; ($moderately_conserved/$total_hits)*100" | bc)
percent_less=$(echo "scale=2; ($less_conserved/$total_hits)*100" | bc)

# Prepare the summarised table
echo -e "Statistic\tValue" > summarised_table.txt
echo -e "Number of Genes\t$num_genes" >> summarised_table.txt
echo -e "Number of Exons\t$num_exons" >> summarised_table.txt
echo -e "Number of Introns\t$num_introns" >> summarised_table.txt
echo -e "Average Gene Size (bp)\t$avg_gene_size" >> summarised_table.txt
echo -e "Average Exon Size (bp)\t$avg_exon_size" >> summarised_table.txt
echo -e "Average Intron Size (bp)\t$avg_intron_size" >> summarised_table.txt
echo -e "% of Genes Highly Conserved (TAIR10)\t$percent_highly%" >> summarised_table.txt
echo -e "% of Genes Moderately Conserved (TAIR10)\t$percent_moderately%" >> summarised_table.txt
echo -e "% of Genes Less Conserved (TAIR10)\t$percent_less%" >> summarised_table.txt

# Assuming BLASTP output and TAIR10 functional descriptions are properly formatted and available

# Extract TAIR10 IDs from BLASTP output (assuming they're in the second column of the BLASTP output)
awk '{print $2}' $BLASTP_OUTPUT | sed 's/\..*//' | sort | uniq > ${ANN_DIR}/blast_hits_ids.txt

# Map these IDs to short descriptions in the TAIR10 functional descriptions
grep -Ff ${ANN_DIR}/blast_hits_ids.txt ${FUNCTIONAL_DIR} | cut -f3 > ${ANN_DIR}/mapped_functional_descriptions.txt

# Summarize top functional categories (assuming "Short_description" is the column of interest)
awk '{counts[$0]++} END {for (desc in counts) print counts[desc], desc}' ${ANN_DIR}/mapped_functional_descriptions.txt | sort -nr | head -n 5 > ${ANN_DIR}/top_functional_categories.txt

# Assuming the summary extraction and counting were done correctly
# The corrected formatting for appending to the summarised table might look like this:

echo -e "Top Functional Categories\tOccurrences" >> summarised_table.txt

# Filter to exclude lines without a proper functional category description
awk '{if(NF>1) print $2 "\t" $1}' top_functional_categories.txt >> summarised_table.txt

# Display the summarised table
cat summarised_table.txt

