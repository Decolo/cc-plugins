#!/bin/bash
# code-review-guard plugin: review-on-stop.sh
#
# Stop hook that triggers code review when Claude finishes responding
# and code changes were made. Uses stop_hook_active sentinel to prevent
# infinite review loops. Uses file hash cache to skip already-reviewed files.

set -euo pipefail

INPUT=$(cat)

# Prevent infinite loops: if we're already in a continuation from a
# previous Stop hook, let Claude stop this time.
if [ "$(echo "$INPUT" | jq -r '.stop_hook_active')" = "true" ]; then
  exit 0
fi

# Get the working directory from the hook payload
CWD=$(echo "$INPUT" | jq -r '.cwd')

# Cache file: per-project, stored in /tmp
PROJECT_HASH=$(echo -n "$CWD" | md5sum | cut -d' ' -f1)
CACHE_FILE="/tmp/code-review-guard-${PROJECT_HASH}.cache"
touch "$CACHE_FILE"

# Check if any code files were modified (staged or unstaged)
CHANGED_FILES=$(cd "$CWD" && git diff --name-only HEAD 2>/dev/null; cd "$CWD" && git diff --name-only --cached 2>/dev/null)

# Check untracked files for common code extensions
UNTRACKED=$(cd "$CWD" && git ls-files --others --exclude-standard 2>/dev/null)

# Filter for code files (broad language support)
ALL_CHANGES=$(echo -e "${CHANGED_FILES}\n${UNTRACKED}" | grep -E '\.(py|js|ts|tsx|jsx|go|rs|java|rb|c|cpp|h|hpp|cs|php|swift|kt|scala|sh|bash|yaml|yml|toml|json|md|sql|html|css|scss|vue|svelte)$' | sort -u || true)

# If no relevant files changed, no review needed
if [ -z "$ALL_CHANGES" ]; then
  exit 0
fi

# Filter out already-reviewed files (same content hash)
NEEDS_REVIEW=""
while IFS= read -r file; do
  [ -z "$file" ] && continue
  FILEPATH="$CWD/$file"
  [ -f "$FILEPATH" ] || continue
  CURRENT_HASH=$(md5sum "$FILEPATH" | cut -d' ' -f1)
  CACHED_HASH=$(grep "^${file} " "$CACHE_FILE" 2>/dev/null | cut -d' ' -f2 || true)
  if [ "$CURRENT_HASH" != "$CACHED_HASH" ]; then
    NEEDS_REVIEW="${NEEDS_REVIEW}${file}\n"
  fi
done <<< "$ALL_CHANGES"

NEEDS_REVIEW=$(echo -e "$NEEDS_REVIEW" | sed '/^$/d' | sort -u)

# If all files already reviewed with same content, no review needed
if [ -z "$NEEDS_REVIEW" ]; then
  exit 0
fi

# Code changes detected — block Claude from stopping and request review
jq -n --arg files "$NEEDS_REVIEW" '{
  "decision": "block",
  "reason": ("Code changes detected in the following files:\n" + $files + "\n\nPlease use the code-reviewer agent to review these changes before finishing. Run: Use code-reviewer to review my recent changes")
}'
