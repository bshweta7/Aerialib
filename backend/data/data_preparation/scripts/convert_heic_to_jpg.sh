#!/bin/bash

# Change to the directory where your HEIC files are
INPUT_DIR="${1:-.}"  # Default to current directory if not given
OUTPUT_DIR="${2:-$INPUT_DIR}"  # Default output to same directory

mkdir -p "$OUTPUT_DIR"

shopt -s nullglob nocaseglob  # allow case-insensitive matching for .heic
for file in "$INPUT_DIR"/*.heic; do
  base_name=$(basename "$file" .heic)
  output_file="$OUTPUT_DIR/${base_name}.jpg"
  echo "Converting $file to $output_file"
  heif-convert "$file" "$output_file"
done

