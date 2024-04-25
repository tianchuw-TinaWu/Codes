awk '{
    # Remove the parts matching the patterns "_Scaffold_" and "_[0-9]+_contigs__combined_"
    gsub("_Scaffold_", "", $1);
    gsub("__[0-9]+_contigs__combined_", "", $1);
	 sub(/\.t[0-9]+/, "", $1)

	# Replace CW10 with CW9 in the first column
    if ($1 ~ /^CW10/) {
        sub(/^CW10/, "CW9", $1);
		}

    # Replace "Lsat_1_v5_gn_" with "LE" in the second column
    sub(/Lsat_1_v5_gn_/, "LE", $2);

    gsub("_", "g", $2);
	 sub(/\.[0-9]+/, "", $2);

	# Extract and increment the number following "LE" in the second column
    if (match($2, /^LE[0-9]+/)) {
        num = substr($2, 3, RLENGTH - 2) + 1;  # Extract the number part and increment
        rest = substr($2, RLENGTH + 1);  # Get the rest of the string
        $2 = "LE" num rest;  # Reconstruct the second column
    }

    # Print the entire line with the modified first column
    print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12;
}' Capeweed_vs_Lettuce.blast > Capeweed_vs_Lettuce_modified.blast




awk '{
    # Remove the parts matching the patterns "_Scaffold_" and "_[0-9]+_contigs__combined_"
    gsub("_Scaffold_", "", $2);
    gsub("__[0-9]+_contigs__combined_", "", $2);
	 sub(/\.t[0-9]+/, "", $2)

	# Replace CW10 with CW9 in the first column
    if ($2 ~ /^CW10/) {
        sub(/^CW10/, "CW9", $2);
		}

    # Replace "Lsat_1_v5_gn_" with "LE" in the second column
    sub(/Lsat_1_v5_gn_/, "LE", $1);

    gsub("_", "g", $1);
	 sub(/\.[0-9]+/, "", $1)

	# Extract and increment the number following "LE" in the second column
    if (match($1, /^LE[0-9]+/)) {
        num = substr($1, 3, RLENGTH - 2) + 1;  # Extract the number part and increment
        rest = substr($1, RLENGTH + 1);  # Get the rest of the string
        $1 = "LE" num rest;  # Reconstruct the second column
    }

    # Print the entire line with the modified first column
    print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12;
}' Lettuce_vs_Capeweed.blast > Lettuce_vs_Capeweed_modified.blast



awk '{
    gsub("Lsat_1_v8_lg_", "LE", $1);
	 sub(/.v5;Name=.*/, "", $2);
	 gsub(/ID=Lsat_1_v5_gn_[0-9]_/, "g", $2);

	# Extract and increment the number following "LE" in the second column
    if (match($1, /^LE[0-9]+/)) {
        num = substr($1, 3, RLENGTH - 2) + 1;  # Extract the number part and increment
        rest = substr($1, RLENGTH + 1);  # Get the rest of the string
        $1 = "LE" num rest;  # Reconstruct the second column
    }

    # Print the entire line with the modified first column
    print $1,$2,$3,$4;
}' Lettuce_Pre.gff > Lettuce_Pre_modified.gff

awk '{
	sub(/^.*g/, "g", $1);
	sub(/^.*g/, "g", $2);

	print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12;
}' combined_for_McScanX.blast > combined_for_McScanX_test.blast


awk '{ $2 = $1 $2; print $1,$2,$3,$4; }' combined_for_McScanX.gff > combined_for_McScanX_test.gff
