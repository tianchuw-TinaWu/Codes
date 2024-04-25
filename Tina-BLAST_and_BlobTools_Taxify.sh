module load blast+/2.9.0

# assume nucleotide-nucleotide BLAST
blastn \

# sepcify the query sequence file
-query tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta \

# specify the database file
-db /home/tianchuw/om62/nt \

# specify the output format
-outfmt "6 qseqid sseqid staxids bitscore" \

	# tabular with the query ID, the subject 
	# ID, the TaxID, and the bit score

# formats of the BLAST results:
	# 0: pairwise format
	# 1: query-anchored showing identities
	# 2: query-anchored no identities
	# 3: flat query-anchored, show identities
	# 4: flat query-anchored, no identities
	# 5: XML Blast output
	# 6: tabular
	# 7: tabular with comment lines
	# 8: Text ASN.1
	# 9: Binary ASN.1
	# 10: Comma-separated values
	# 11: BLAST archive format (ASN.1)

# specify the output file
-out blast_output.tsv

# to generate the input TaxID mapping file
blastdbcmd \
-db /home/tianchuw/om62/nt \

# specify the sequence identifiers or accessions to retrieve from the BLAST database
-entry all \

	# all: all sequences will be retrieved; or
	# a single identifier; or
	# a list of identifiers, e.g., -entry 
	# "1042851727,Q6H647.2,LEC_LUFAC"; or
	# a range of identifiers, e.g., -entry 
	# 1042851727-1042851730); or
	# a file e.g., -entry blastdbcmd_input.txt

# specify the output format	
-outfmt "%g %T" \

	# output tab-separated file with two 
	# columns: 1. NCBI sequence ID, also known 	
	# as gi (%g) & 2. TaxID (%T) of the 
	# sequence

	# other options:
		# %f: sequence in FASTA format
		# %s: sequence data
		# %a: accession
		# %i: sequence ID
		# %t: sequence title
		# %l: sequence length
		# %h: sequence hash value
		# %X: leaf-node TaxIDs
		# %L: common taxonomic name
		# %S: scientific name
		# %B: BLAST name
		# %K: taxonomic super kingdom

# specify the output TaxID mapping file
-out taxid_mapping_file_2.tsv > ~/ha22_scratch/CapeWeed_Hap/taxid_mapping_file.tsv

# codes for generating a TaxID mapping file as an input to Taxify
~/om62/temp/ncbi-blast-2.15.0+/bin/blastdbcmd -db nt -entry all -outfmt "%g %T %K %L %l" -out ~/ha22_scratch/CapeWeed_Hap/taxid_mapping_file.tsv



blobtools taxify -f all-OUT -m ~/ha22_scratch/CapeWeed_Hap/taxid_mapping_file.tsv -s 0 -t 1 -o taxified_blast_output_all
 # output the list of hits with species names cat taxified_blast_output_all.all-OUT.taxified.out | awk '{print $4}' | sort | uniq -c | sort -n \
| while read N TAX
do
echo $N $TAX $(cat ../taxid_mapping_file.tsv | awk -v TAX=${TAX} '$2 == TAX {print $3, $4, $5}' | head -n 1)
done