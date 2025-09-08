#!/usr/bin/env bash

UNITY_PID=$(hyprctl activewindow | awk '/pid:/ {print $2}')

kitty &
TERM_PID=$!
sleep 0.25
hyprctl dispatch setfloating pid:$TERM_PID
hyprctl dispatch resizewindowpixel exact 1 1, pid:$TERM_PID
hyprctl dispatch centerwindow pid:$TERM_PID

for i in $(seq 1 50); do
    hyprctl dispatch focuswindow pid:$UNITY_PID
    hyprctl dispatch focuswindow pid:$TERM_PID
done

kill $TERM_PID
