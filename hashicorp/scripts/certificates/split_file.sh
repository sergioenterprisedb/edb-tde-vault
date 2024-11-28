#!/bin/bash

# Input file
input_file="kmip-cert.pem"

# Output files prefix
output_prefix="cert_part"

# Counter for file numbering
counter=1

# Use awk to split the file based on "-----BEGIN" lines
awk -v prefix="$output_prefix" -v count="$counter" '
/^-----BEGIN/ {
  if (file) close(file)
  file = sprintf("%s%d.pem", prefix, count++)
}
{
  print > file
}
' "$input_file"

echo "Files created: $(ls ${output_prefix}*.pem)"
