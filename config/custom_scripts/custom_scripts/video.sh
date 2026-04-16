#!/bin/bash

# This script is to take an input file and make it compatible video for different platform and the 2nd argument as the output video file name

# Check if both input and output arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: convert-cross <input_video> <output_video.mp4>"
    echo "Example: convert-cross input.mkv output.mp4"
    exit 1
fi

INPUT="$1"
OUTPUT="$2"

echo "Converting $INPUT to highly compatible H.264 MP4..."

ffmpeg -i "$INPUT" \
    -c:v libx264 \
    -profile:v high \
    -level 4.1 \
    -crf 24 \
    -preset fast \
    -pix_fmt yuv420p \
    -vf "scale='min(1280,iw)':min'(720,ih)':force_original_aspect_ratio=decrease,pad=ceil(iw/2)*2:ceil(ih/2)*2" \
    -c:a aac \
    -ac 2 \
    -b:a 128k \
    -movflags +faststart \
    "$OUTPUT"

echo "Conversion complete: $OUTPUT"
