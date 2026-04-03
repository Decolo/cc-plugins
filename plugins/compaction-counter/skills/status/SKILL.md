---
name: compaction-counter:status
description: "Check the compaction count for the current session. Use when you want to know how many times context has been compacted and whether the session is approaching the degradation threshold."
---

# Compaction Counter Status

Check the current session's compaction count.

## How It Works

The `PostCompact` hook (registered by this plugin) increments a counter file every time the context is compacted. This skill reads that counter.

The counter tracks total compactions per session.

## Threshold

The warning threshold defaults to **10 compactions**. Set a custom threshold:

```bash
export COMPACT_WARN_THRESHOLD=5   # warn after 5 compactions
```

## What to Do

Below threshold: session is healthy — no action needed.

At or above threshold: context quality is likely degraded. Consider starting a fresh session.

## Output Format

```
Compaction #N — threshold: T
```

If at/above threshold, a warning message is included recommending a session reset.
