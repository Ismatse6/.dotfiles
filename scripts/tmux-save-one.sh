#!/usr/bin/env bash

PLUGIN_ROOT="${TMUX_PLUGIN_MANAGER_PATH:-$HOME/.config/tmux/plugins}"
SAVE_SH="$PLUGIN_ROOT/tmux-resurrect/scripts/save.sh"
SNAP_DIR="$HOME/.tmux/resurrect" # ← snapshots stay here; no change

if command -v tmux >/dev/null && tmux has-session -t 0 2>/dev/null; then
    bash "$SAVE_SH"
fi

# keep newest, delete the rest
[ -d "$SNAP_DIR" ] || exit 0
cd "$SNAP_DIR"
latest=$(ls -1t tmux_resurrect_* 2>/dev/null | head -n1)
ls -1 tmux_resurrect_* 2>/dev/null | grep -v "$latest" | xargs -r rm -f
