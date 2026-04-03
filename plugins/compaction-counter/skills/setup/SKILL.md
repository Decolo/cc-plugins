---
name: compaction-counter:setup
description: "Integrate the compaction counter into your Claude Code status line. Use when setting up the compaction-counter plugin for the first time, or when you want to add compaction count display to your existing status line script."
---

# Compaction Counter Setup

Add compaction count display to your Claude Code status line.

## Prerequisite

You need an existing status line script. Claude Code calls your script with JSON on stdin and renders the output. The script is configured in your `~/.claude/settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "python3 /path/to/your/script.py"
}
```

## Integration Steps

### 1. Add the display function

Copy this function into your Python status line script:

```python
import hashlib
import json
import os

def get_compaction_display(transcript_path):
    """Show compaction count from the PostCompact hook counter file."""
    if not transcript_path:
        return ""

    try:
        key = hashlib.sha1(transcript_path.encode()).hexdigest()[:16]
        # Plugin stores counts in CLAUDE_PLUGIN_DATA, fallback to /tmp
        plugin_data = os.environ.get('CLAUDE_PLUGIN_DATA', '')
        if plugin_data:
            count_file = os.path.join(plugin_data, 'counts', key)
        else:
            count_file = f"/tmp/claude-compact-counts/{key}"

        if not os.path.exists(count_file):
            return ""

        with open(count_file, 'r') as f:
            counts = json.load(f)

        total = counts.get('total', 0)
        if total <= 0:
            return ""

        threshold = 10
        env_threshold = os.environ.get('COMPACT_WARN_THRESHOLD', '')
        if env_threshold.isdigit():
            threshold = int(env_threshold)

        reset = "\033[0m"
        if total >= threshold:
            color = "\033[31m"  # Red
            label = f"C:#{total}!"
        else:
            color = "\033[32m"  # Green
            label = f"C:#{total}"

        return f" \033[90m|\033[0m {color}{label}{reset}"

    except (json.JSONDecodeError, OSError, ValueError, KeyError):
        return ""
```

### 2. Read transcript_path from stdin

In your `main()` function, read `transcript_path` from the input JSON:

```python
data = json.load(sys.stdin)
transcript_path = data.get('transcript_path', '')
```

### 3. Call the function and append to status output

```python
compaction_display = get_compaction_display(transcript_path)
status_line = f"{...existing components...}{compaction_display}"
print(status_line)
```

## Configuration

Set the warning threshold:

```bash
export COMPACT_WARN_THRESHOLD=15   # warn after 15 compactions
```

## Result

After integration, your status line will show compaction count alongside your existing metrics:

```
[Claude] | project | 36% | $24.61 | C:#3
```
When at/above threshold, it turns red with a `!`:

```
[Claude] | project | 91% | $1.23 | C:#10!
```
