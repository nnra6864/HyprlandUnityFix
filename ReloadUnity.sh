#!/usr/bin/env bash

UNITY_PID=$(hyprctl activewindow | awk '/pid:/ {print $2}')
wev &
WEV_PID=$!

hyprctl dispatch setfloating pid:$WEV_PID
hyprctl dispatch resizewindowpixel exact 1 1, pid:$WEV_PID
hyprctl dispatch centerwindow pid:$WEV_PID

for i in $(seq 1 50); do
    hyprctl dispatch focuswindow pid:$UNITY_PID
    hyprctl dispatch focuswindow pid:$WEV_PID
done

kill $WEV_PID
