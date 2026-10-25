# @fish-lsp-disable-next-line 4004
function vid-comp --description 'Compress video to target MB using NVENC'
    if test (count $argv) -ne 3
        echo "Usage: convert-cross <input_video> <output_video.mp4> <target_size_mb>"
        echo "Example: convert-cross input.mkv output.mp4 20"
        return 1
    end

    set -l INPUT $argv[1]
    set -l OUTPUT $argv[2]
    set -l TARGET_MB $argv[3]

    # settings
    set -l AUDIO_KBPS 128

    # get video duration
    set -l DURATION (ffprobe -v error \
        -show_entries format=duration \
        -of default=noprint_wrappers=1:nokey=1 \
        $INPUT)

    if test -z "$DURATION"
        echo "Error: Could not determine video duration."
        return 1
    end

    # calculate bitrate
    # target_size(MB) * 8192 / duration(seconds)
    # gives total bitrate in kbps
    set -l TOTAL_KBPS (awk \
        -v mb=$TARGET_MB \
        -v duration=$DURATION \
        'BEGIN {
            printf "%.0f", (mb * 8192) / duration
        }')

    set -l VIDEO_KBPS (math $TOTAL_KBPS - $AUDIO_KBPS)

    if test $VIDEO_KBPS -le 100
        echo "Error: Target size is too small for this video."
        return 1
    end

    echo
    echo "Input:          $INPUT"
    echo "Output:         $OUTPUT"
    echo "Target size:    $TARGET_MB MB"
    echo "Duration:       $DURATION seconds"
    echo "Video bitrate:  $VIDEO_KBPS kbps"
    echo "Audio bitrate:  $AUDIO_KBPS kbps"
    echo
    echo "Encoding with RTX 3060 Ti NVENC..."
    echo

    # encode
    ffmpeg -i $INPUT \
        -c:v h264_nvenc \
        -preset p5 \
        -profile:v high \
        -level:v 5.2 \
        -b:v "$(math $VIDEO_KBPS)k" \
        -maxrate "$(math $VIDEO_KBPS)k" \
        -bufsize "$(math $VIDEO_KBPS \* 2)k" \
        -pix_fmt yuv420p \
        -vf "scale=w='min(1280,iw)':h='min(720,ih)':force_original_aspect_ratio=decrease,pad=ceil(iw/2)*2:ceil(ih/2)*2" \
        -c:a aac \
        -ac 2 \
        -b:a "$(math $AUDIO_KBPS)k" \
        -movflags +faststart \
        $OUTPUT

    set -l rc $status

    if test $rc -eq 0
        echo
        echo "Conversion complete: $OUTPUT"
        echo

        # show result size
        set -l SIZE (du -m $OUTPUT | cut -f1)
        echo "Output size: $SIZE MB"
    else
        echo
        echo "Conversion failed."
    end

    return $rc
end
