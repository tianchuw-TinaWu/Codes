#!/bin/bash
#SBATCH -J Cleanup             
#SBATCH -o Cleanup.out      
#SBATCH -e Cleanup.err
#SBATCH -n 1                  
#SBATCH -c 30                
#SBATCH --mem-per-cpu=10G
#SBATCH --mail-user=twuu0033@student.monash.edu 
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -t 01:00:00

# Load necessary modules and activate the conda environment
module load singularity
conda init bash
conda activate annotation27

# Define the directory where your chromosome-specific GTF files are located
CHROMOSOME_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/tsebra_renamed"
ANNOTATION_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/cleanup"
LOG_DIR="/home/tianchuw/ha22_scratch/CapeWeed_Hap/Log_Dir/cleanup"

# Make new directories
mkdir -p "${ANNOTATION_DIR}"
mkdir -p "${LOG_DIR}"

# Navigate to the directory containing the GTF files
cd "$CHROMOSOME_DIR"

# Loop through each GTF file representing individual chromosomes
for input_file in ${CHROMOSOME_DIR}/*renamed.gtf; do
    echo "Processing ${input_file}"

    # Step 1: Prepare the file names for intermediate and final outputs
    output_file_noOrgs="${ANNOTATION_DIR}/$(basename "${input_file%.gtf}")_CDSonly_noOrgs.gtf"
    output_file_gff="${ANNOTATION_DIR}/$(basename "${input_file%.gtf}")_CDSonly_noOrgs.gff"
    output_file_sorted="${ANNOTATION_DIR}/$(basename "${input_file%.gtf}")_CDSonly_noOrgs_sorted.gff"
    output_file_fixed="${ANNOTATION_DIR}/$(basename "${input_file%.gtf}")_CDSonly_noOrgs_sorted_fixTranscriptID.gff"
    protein_fasta="${ANNOTATION_DIR}/$(basename "${input_file%.gtf}")_proteins.fasta"
    log_file="${LOG_DIR}/$(basename "${input_file%.gtf}")_log.txt"

    # Define arrays for organellar annotations and features to exclude
    organelles=("Mitochondria" "Plastid")
    features=("exon" "intron" "gene" "transcript")

    # Process input file for Step 1 directly in the loop
    awk -v org="$(IFS='|'; echo "${organelles[*]}")" \
        -v feats="$(IFS='|'; echo "${features[*]}")" \
        'BEGIN {split(org, org_array, "|"); split(feats, feat_array, "|")} 
         {
             if (!($1 in org_array) && !($3 in feat_array)) {
                 print $0 > "'"$output_file_noOrgs"'"
             }
         }' "$input_file"

    # Step 2: Convert BRAKER-generated GTF to GFF3 using AGAT (run separately in the Singularity environment)
    # cd /home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/cleanup 
    # singularity run --bind /home/tianchuw/ha22_scratch/CapeWeed_Hap/Annotation/cleanup:/mnt --pwd /mnt agat_1.0.0--pl5321hdfd78af_0.sif agat_convert_sp_gxf2gxf.pl --gtf "$output_file_noOrgs" -o "$output_file_gff"

    # Step 3: Sort GFF3 using genome tools
    gt gff3 -sort -tidy -retainids "$output_file_gff" > "$output_file_sorted"

    # Step 4: Fix transcript IDs for genes with alternative mRNA isoforms and remove transcript_id from gene features
    # Adjusted to fix the issue with transcript_id for alternative isoforms

	# Step 4: Adjusted to reflect original script's logic for handling transcript IDs
# Process input file
while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ ! $line =~ ^# ]]; then
        sline=($line)
        feature=${sline[2]}
        if [[ $feature == "gene" ]]; then
            # Remove transcript_id attribute from gene features
            echo "${line}" | sed -E 's/;transcript_id[^;]+(;|$)/\1/' 
        elif [[ $feature == "mRNA" ]]; then
            # Correct transcript_id for mRNA features, assuming ID handling is needed
            ID=$(echo "${line}" | grep -oP 'ID=[^;]+')
            transcript_id=$(echo "${line}" | grep -oP 'transcript_id=[^;]+')
            if [[ $ID != $transcript_id ]]; then
                # Replace or adjust the transcript_id as needed
                new_line=$(echo "${line}" | sed -E "s/transcript_id=[^;]+/$ID/")
                echo "$new_line"
            else
                echo "$line"
            fi
        else
            echo "$line"
        fi
    else
        echo "$line"
    fi
done < "$output_file_sorted" > "$output_file_fixed"

    # Get protein FASTA file using gffread
    gffread -E -y "$protein_fasta" -g /home/tianchuw/ha22_scratch/CapeWeed_Hap/tom-mon3828-mb-hirise-yv4r5__06-15-2023__final_assembly_top9.fasta.masked "$output_file_fixed" 2> "$log_file"

    echo "Finished processing ${input_file}"
done

echo "All chromosome GTF files processed."
