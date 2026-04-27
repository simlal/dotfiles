#!/usr/bin/env bash

windows=$(hyprctl clients -j | jq -r '.[] | "\(.address) | [\(.workspace.id)] | \(.class) | \(.title)"' | grep -v "h-switcher")

selected=$(echo "$windows" | fzf \
    --ansi \
    --header="󱂬  ACTIVE WINDOWS" \
    --layout=reverse \
    --border=none \
    --margin=1 \
    --padding=1 \
    --delimiter=" \| " \
    --with-nth=2.. \
    --info="inline-right" \
    --prompt="  " \
    --pointer="󰁔" \
    --color="bg+:-1,fg:7,header:5,pointer:2,prompt:2,hl:6,hl+:6" \
    | awk -F' | ' '{print $1}')

if [ -n "$selected" ]; then
    hyprctl dispatch focuswindow address:"$selected"
fi
