#!/bin/bash

# Function to get sorted list of window IDs
get_window_ids() {
    hyprctl clients | grep '^Window' | awk '{ print $2 }' | sort
}

# Initial snapshot
prev_ids=$(get_window_ids)

while true; do
    sleep 0.01
    current_ids=$(get_window_ids)

    # Compare current and previous IDs
    if [[ "$current_ids" != "$prev_ids" ]]; then
        # Print only the new windows
        new_ids=$(comm -13 <(echo "$prev_ids") <(echo "$current_ids"))
        for id in $new_ids; do
            echo -e "\nNew window detected: $id"
            # Extract and print full block for that window
            hyprctl clients | awk -v id="$id" '
                $2 == id && $1 == "Window" { in_block=1 }
                in_block {
                    print
                    if ($0 ~ /^$/) in_block=0
                }
            '
        done

        prev_ids="$current_ids"
    fi
done
