#!/usr/bin/env bash

# 1. Get windows from hyprctl
# 2. Format them for fzf
# 3. Use fzf to pick one
# 4. Extract the Address (most reliable way to jump)
# 5. Tell Hyprland to focus it

selected=$(hyprctl clients -j | jq -r '.[] | "\(.address) \(.workspace.id) \(.class): \(.title)"' | \
    fzf --header="Jump to Window" --layout=reverse --with-nth=2.. --border=none | awk '{print $1}')

if [ -n "$selected" ]; then
    hyprctl dispatch focuswindow address:"$selected"
fi
