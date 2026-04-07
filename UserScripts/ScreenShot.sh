#!/usr/bin/env bash
set -euo pipefail

# Configuration
SAVE_DIR="${HOME}/Pictures/Screenshots"
FILE_NAME="screenshot_$(date +'%Y-%m-%d_%H-%M-%S').png"
TMP_CROP_FILE=$(mktemp /tmp/screenshot_crop_XXXXXX.png)

# Default variables
DO_SAVE=0
ACTION="--area"

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --save) DO_SAVE=1 ;;
        --now)  ACTION="--now" ;;
        --area) ACTION="--area" ;;
    esac
done

# Cleanup function: Ensures the frozen screen and temp files are cleared safely
PICKER_PID=""
cleanup() {
    if [ -n "$PICKER_PID" ] && kill -0 "$PICKER_PID" 2>/dev/null; then
        kill "$PICKER_PID"
    fi
    rm -f "$TMP_CROP_FILE"
}
# The trap command guarantees cleanup runs even if you press Escape to cancel
trap cleanup EXIT

case "$ACTION" in
    --now)
        # Instant capture
        grim "$TMP_CROP_FILE"
        ;;
    --area)
        # 1. Freeze the screen natively using hyprpicker
        if command -v hyprpicker &> /dev/null; then
            hyprpicker -r -z &
            PICKER_PID=$!
            sleep 0.1 # Give it a split-second to lock the visual frame
        else
            notify-send "Missing Dependency" "Install 'hyprpicker' for the freeze effect."
        fi

        # 2. Fetch active workspace for window snapping
        ACTIVE_WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.id')
        
        # 3. Gather visible window coordinates
        WINDOWS=$(hyprctl clients -j | jq -r --arg ws "$ACTIVE_WORKSPACE" '.[] | select(.workspace.id == ($ws | tonumber) and .mapped == true) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        
        # 4. Display slurp over the frozen screen
        REGION=$(echo "$WINDOWS" | slurp -d -b 00000080 -c cba6f7 || true)
        
        # Clean up and exit if canceled (e.g., right-click or escape)
        if [ -z "$REGION" ]; then
            exit 0
        fi
        
        # 5. Capture the chosen region
        grim -g "$REGION" "$TMP_CROP_FILE"
        ;;
esac

# Copy to clipboard
wl-copy < "$TMP_CROP_FILE"

# Handle saving if the flag was passed
if [ "$DO_SAVE" -eq 1 ]; then
    mkdir -p "$SAVE_DIR"
    cp "$TMP_CROP_FILE" "${SAVE_DIR}/${FILE_NAME}"
    notify-send "Screenshot Saved & Copied" "Saved to ${SAVE_DIR}/${FILE_NAME}" -i "$TMP_CROP_FILE"
else
    notify-send "Screenshot Copied" "Copied to clipboard." -i "$TMP_CROP_FILE"
fi

exit 0
