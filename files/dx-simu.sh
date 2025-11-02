#!/data/data/com.termux/files/usr/bin/bash

export PATH="/data/data/com.termux/files/usr/bin:$PATH"

CODEX_URL="https://codex-server-pied.vercel.app"
termux_dir="$HOME/.termux"
version_file="$termux_dir/dx.txt"
ads_file="$termux_dir/ads.txt"
timestamp_file="$termux_dir/.last_update_check"

check_interval_seconds=300 

mkdir -p "$termux_dir"

if [[ -f "$timestamp_file" ]]; then
    
    local last_check=$(stat -c %Y "$timestamp_file" 2>/dev/null || stat -f %m "$timestamp_file" 2>/dev/null)
    local now=$(date +%s)
    local time_diff=$((now - last_check))

    if (( time_diff < check_interval_seconds )); then
        exit 0
    fi
fi

touch "$timestamp_file" 

update_message=$(curl -fsS "$CODEX_URL/check_version" | jq -r '.[0].message // empty')

if [[ -n "$update_message" ]]; then
    echo "$update_message" > "$version_file"
else
    echo "" > "$version_file"
fi

ads_output=$(curl -fsS "$CODEX_URL/ads" | jq -r '.[] | .message')

if [[ -n "$ads_output" ]]; then
    echo "$ads_output" > "$ads_file"
else
    echo "" > "$ads_file"
fi

exit 0
