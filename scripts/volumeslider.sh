#this goes .local/bin/volumeslider.sh

#!/bin/bash

SINK="@DEFAULT_AUDIO_SINK@"

# Change volume
wpctl set-volume "$SINK" "$1"

# Get volume as an integer percentage
VOLUME=$(wpctl get-volume "$SINK" | awk '{printf "%.0f", $2 * 100}')

# Clamp to 0-100
(( VOLUME > 100 )) && VOLUME=100
(( VOLUME < 0 )) && VOLUME=0

# Show Dunst volume notification
dunstify \
    --replace=9999 \
    --hint="string:x-dunst-stack-tag:volume" \
    --hint="int:value:$VOLUME" \
    "Volume" \
    "${VOLUME}%"
