#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')

GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

color_for() {
    local pct_int=$1
    if [ "$pct_int" -ge 90 ]; then echo "$RED"
    elif [ "$pct_int" -ge 70 ]; then echo "$YELLOW"
    else echo "$GREEN"
    fi
}

fmt_reset() {
    local resets_at=$1
    local now secs
    now=$(date +%s)
    secs=$((resets_at - now))
    [ "$secs" -lt 0 ] && secs=0
    local days=$((secs / 86400))
    local hours=$(((secs % 86400) / 3600))
    local mins=$(((secs % 3600) / 60))
    if [ "$days" -gt 0 ]; then
        echo "${days}d${hours}h"
    elif [ "$hours" -gt 0 ]; then
        echo "${hours}h${mins}m"
    else
        echo "${mins}m"
    fi
}

FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
FIVE_H_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
WEEK=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
WEEK_RESET=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

LIMITS=""
if [ -n "$FIVE_H" ]; then
    PCT=$(printf '%.0f' "$FIVE_H")
    C=$(color_for "$PCT")
    SEG="${C}5h: ${PCT}%${RESET}"
    [ -n "$FIVE_H_RESET" ] && SEG="$SEG (resets ${FIVE_H_RESET:+$(fmt_reset "$FIVE_H_RESET")})"
    LIMITS="$SEG"
fi
if [ -n "$WEEK" ]; then
    PCT=$(printf '%.0f' "$WEEK")
    C=$(color_for "$PCT")
    SEG="${C}7d: ${PCT}%${RESET}"
    [ -n "$WEEK_RESET" ] && SEG="$SEG (resets $(fmt_reset "$WEEK_RESET"))"
    LIMITS="${LIMITS:+$LIMITS | }$SEG"
fi

if [ -n "$LIMITS" ]; then
    echo -e "[$MODEL] 📁 ${DIR##*/} | $LIMITS"
else
    echo "[$MODEL] 📁 ${DIR##*/} | rate limits unavailable yet"
fi
