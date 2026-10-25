#!/usr/bin/env fish

function ytd --description 'Download YouTube video in H.264 MP4'
    if test (count $argv) -ne 2
        echo "Usage: ytd <video-link> <quality>"
        echo "Example: ytd \"https://youtube.com/watch?v=...\" 720"
        return 1
    end

    set -l URL $argv[1]
    set -l QUALITY $argv[2]

    echo "Downloading video at max $QUALITY p in cross-platform H.264 (MP4)..."

    yt-dlp -f "bv*[height<=$QUALITY]+ba/b[height<=$QUALITY]" \
        -S "vcodec:h264,acodec:m4a" \
        --merge-output-format mp4 \
        $URL

    set -l rc $status

    if test $rc -eq 0
        echo "Download complete!"
    else
        echo "Download failed."
    end

    return $rc
end
