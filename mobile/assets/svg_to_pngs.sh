#!/bin/bash

# Usage:
# $ ./svg_to_pngs.sh <input.svg> <width> <output dir>

base_name=$(basename $1)
png_name="${base_name%.svg}".png
svg_abs_name="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
output_abs_name="$(cd $3; pwd)"

#exit 0

inkscape -d 600 -h $2 --export-png "$output_abs_name/$png_name" "$svg_abs_name"

mkdir -p "$3/2x"
inkscape -d 600 -h "$((2 * $2))" --export-png "$output_abs_name/2x/$png_name" "$svg_abs_name"

mkdir -p "$3/4x"
inkscape -d 600 -h "$((4 * $2))" --export-png "$output_abs_name/4x/$png_name" "$svg_abs_name"