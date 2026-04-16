#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: ytd <video-link> <quality>"
    echo "Example: ytd \"https://youtube.com/watch?v=...\" 720"
    exit 1
fi

URL="$1"
QUALITY="$2"

echo "Downloading video at max ${QUALITY}p in cross-platform H.264 (MP4)..."

# yt-dlp command explanation:
# -f: Filters for the best video less than or equal to the requested quality + best audio
# -S: Sorts the remaining filtered formats to prioritize H.264 video and M4A audio
# --merge-output-format: Ensures the final combined file is wrapped in an MP4 container
yt-dlp -f "bv*[height<=${QUALITY}]+ba/b[height<=${QUALITY}]" \
       -S "vcodec:h264,acodec:m4a" \
       --merge-output-format mp4 \
       "$URL"

echo "Download complete!"
