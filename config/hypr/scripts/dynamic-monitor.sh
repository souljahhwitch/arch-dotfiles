#!/usr/bin/env bash

set -euo pipefail

fixed=("$@")
monitors=$(hyprctl monitors -j)

dynamic=$(
    jq -r --argjson fixed "$(printf '%s\n' "${fixed[@]}" | jq -R . | jq -s .)" '
        .[]
        | select(.name as $name | ($fixed | index($name) | not))
        | .name
    ' <<< "$monitors" | head -n 1
)

[[ -z "$dynamic" ]] && exit 0

read -r width height scale x y < <(
    jq -r --arg name "$dynamic" '
        .[]
        | select(.name == $name)
        | "\(.width) \(.height) \(.scale) \(.x) \(.y)"
    ' <<< "$monitors"
)

target_x=0
target_y=$(
    awk -v height="$height" -v scale="$scale" \
        'BEGIN { printf "%.0f", -(height / scale) }'
)

[[ "$x" == "$target_x" && "$y" == "$target_y" ]] && exit 0

mode=$(
    jq -r --arg name "$dynamic" '
        .[]
        | select(.name == $name)
        | "\(.width)x\(.height)@\(.refreshRate)"
    ' <<< "$monitors"
)

hyprctl keyword monitor \
    "$dynamic,$mode,${target_x}x${target_y},$scale"
