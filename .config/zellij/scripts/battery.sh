#!/bin/bash
# Battery status with emoji, progress bar, and color coding
# For zjstatus command widget

BAT_PATH=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)

if [ -z "$BAT_PATH" ]; then
    echo ""
    exit 0
fi

capacity=$(cat "$BAT_PATH/capacity" 2>/dev/null)
status=$(cat "$BAT_PATH/status" 2>/dev/null)

if [ -z "$capacity" ]; then
    echo ""
    exit 0
fi

# Icon based on status and level
if [ "$status" = "Charging" ]; then
    icon="🔌"
elif [ "$capacity" -ge 90 ]; then
    icon="🔋"
elif [ "$capacity" -ge 60 ]; then
    icon="🔋"
elif [ "$capacity" -ge 30 ]; then
    icon="🪫"
elif [ "$capacity" -ge 15 ]; then
    icon="🪫"
else
    icon="💀"
fi

# Progress bar (10 chars wide)
filled=$((capacity / 10))
empty=$((10 - filled))
bar=""
for ((i=0; i<filled; i++)); do bar+="█"; done
for ((i=0; i<empty; i++)); do bar+="░"; done

echo "${icon} ${bar} ${capacity}%"
