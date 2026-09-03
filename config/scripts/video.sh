#!/usr/bin/env bash

if [ "$#" -ne 3 ]; then
    echo "Usage: convert-cross <input_video> <output_video.mp4> <target_size_mb>"
    echo "Example: convert-cross input.mkv output.mp4 20"
    exit 1
fi

INPUT="$1"
OUTPUT="$2"
TARGET_MB="$3"

# --------------------------------------------------
# Settings
# --------------------------------------------------

AUDIO_KBPS=128

# --------------------------------------------------
# Get video duration
# --------------------------------------------------

DURATION=$(ffprobe -v error \
    -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 \
    "$INPUT")

if [ -z "$DURATION" ]; then
    echo "Error: Could not determine video duration."
    exit 1
fi

# --------------------------------------------------
# Calculate bitrate
#
# target_size(MB) * 8192 / duration(seconds)
# gives total bitrate in kbps
# --------------------------------------------------

TOTAL_KBPS=$(awk \
    -v mb="$TARGET_MB" \
    -v duration="$DURATION" \
    'BEGIN {
        printf "%.0f", (mb * 8192) / duration
    }')

VIDEO_KBPS=$((TOTAL_KBPS - AUDIO_KBPS))

if [ "$VIDEO_KBPS" -le 100 ]; then
    echo "Error: Target size is too small for this video."
    exit 1
fi

echo
echo "Input:          $INPUT"
echo "Output:         $OUTPUT"
echo "Target size:    ${TARGET_MB} MB"
echo "Duration:       ${DURATION} seconds"
echo "Video bitrate:  ${VIDEO_KBPS} kbps"
echo "Audio bitrate:  ${AUDIO_KBPS} kbps"
echo
echo "Encoding with RTX 3060 Ti NVENC..."
echo

# --------------------------------------------------
# Encode
# --------------------------------------------------

ffmpeg -i "$INPUT" \
    -c:v h264_nvenc \
    -preset p5 \
    -profile:v high \
    -level:v 4.1 \
    -b:v "${VIDEO_KBPS}k" \
    -maxrate "${VIDEO_KBPS}k" \
    -bufsize "$((VIDEO_KBPS * 2))k" \
    -pix_fmt yuv420p \
    -vf "scale=w='min(1280,iw)':h='min(720,ih)':force_original_aspect_ratio=decrease,pad=ceil(iw/2)*2:ceil(ih/2)*2" \
    -c:a aac \
    -ac 2 \
    -b:a "${AUDIO_KBPS}k" \
    -movflags +faststart \
    "$OUTPUT"

if [ $? -eq 0 ]; then
    echo
    echo "Conversion complete: $OUTPUT"
    echo

    # Show resulting size
    SIZE=$(du -m "$OUTPUT" | cut -f1)
    echo "Output size: ${SIZE} MB"
else
    echo
    echo "Conversion failed."
    exit 1
fi
