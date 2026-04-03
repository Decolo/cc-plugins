#!/bin/bash
# PostCompact hook: increments a per-session compaction counter.
# Reads stdin JSON from Claude Code, writes JSON counter to plugin data dir.
# Fails silently on any error — must never block compaction.

set -e
trap 'exit 0' ERR

# Require jq
command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
[ -z "$INPUT" ] && exit 0

TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty') || exit 0
[ -z "$TRANSCRIPT" ] && exit 0

# Prefer plugin data directory; fall back to /tmp
if [ -n "$CLAUDE_PLUGIN_DATA" ]; then
    COUNT_DIR="$CLAUDE_PLUGIN_DATA/counts"
else
    COUNT_DIR="/tmp/claude-compact-counts"
fi

mkdir -p "$COUNT_DIR" 2>/dev/null || exit 0

KEY=$(printf '%s' "$TRANSCRIPT" | shasum | cut -c1-16)
COUNT_FILE="$COUNT_DIR/$KEY"

# Read existing count or start fresh
if [ -f "$COUNT_FILE" ]; then
    TOTAL=$(jq -r '.total // 0' "$COUNT_FILE" 2>/dev/null) || TOTAL=0
else
    TOTAL=0
fi

TOTAL=$((TOTAL + 1))
printf '{"total":%d}\n' "$TOTAL" > "$COUNT_FILE"
