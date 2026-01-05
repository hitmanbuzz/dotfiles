#!/bin/bash

# Function to get current volume percentage
get_volume() {
    pamixer --get-volume
}

# Function to send notification
send_notification() {
    volume=$(get_volume)
    # Send notification with ID 1000 to replace the previous one instantly
    dunstify -a "Volume" -u low -r 1000 -h int:value:"$volume" "Volume: ${volume}%"
}

case $1 in
    up)
        # Increase volume
        pamixer -i 3
        send_notification
        ;;
    down)
        # Decrease volume
        pamixer -d 3
        send_notification
        ;;
    mute)
        # Toggle mute
        pamixer -t
        if $(pamixer --get-mute); then
            dunstify -a "Volume" -u low -r 1000 "Muted"
        else
            send_notification
        fi
        ;;
esac

