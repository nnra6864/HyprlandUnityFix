#!/bin/bash

get_window_ids() {
    hyprctl clients | grep '^Window' | awk '{ print $2 }' | sort
}

prev_ids=$(get_window_ids)

while true; do
    sleep 0.01
    current_ids=$(get_window_ids)

    if [[ "$current_ids" != "$prev_ids" ]]; then
        new_ids=$(comm -13 <(echo "$prev_ids") <(echo "$current_ids"))
        for id in $new_ids; do
            hyprctl clients | awk -v id="$id" '
                /^Window/ && $2 == id { in_block=1 }
                in_block { print }
                in_block && /^$/ { in_block=0; exit }
            '
        done

        prev_ids="$current_ids"
    fi
done
