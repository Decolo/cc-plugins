# compaction-counter

Track how many times Claude Code has compacted your session's context — and know when it's time to start fresh.

## Why

Each compaction lossy-compresses your conversation history. After too many compactions, early context becomes increasingly blurry. This plugin gives you visibility into when that degradation is happening.

## Installation

```bash
/plugin install https://github.com/decolo/cc-plugins
```

## Usage

After installation, the PostCompact hook runs automatically. No configuration needed.

### Check your count

```
/compaction-counter:status
```

Output:
```
Compaction #3 — threshold: 10
```

At threshold:
```
Compaction #10! — threshold: 10
Context quality is likely degraded. Consider starting a fresh session.
```

### Status line integration (optional)

The hook tracks compactions passively. To see the count in your status line:

```
/compaction-counter:setup
```

This gives you the Python function to add to your existing status line script.

## Configuration

### Warning threshold

Set `COMPACT_WARN_THRESHOLD` in your environment or `settings.json` env block:

```bash
export COMPACT_WARN_THRESHOLD=15
```

Default: 10

### Status line display

Below threshold: `C:#3` in green
At/above threshold: `C:#10!` in red with `!`

Example: `[Claude] | project | 36% | $24.61 | C:#3`

## How it works

1. Every compaction fires the `PostCompact` hook
2. The hook increments a counter file keyed by your session's transcript path
3. The status line script reads the counter and displays it

Counter files are stored in `~/.claude/plugins/data/compaction-counter/counts/` with a fallback to `/tmp/claude-compact-counts/`.

## Requirements

- macOS or Linux
- `jq` (install via `brew install jq` or your package manager)
- Claude Code with plugin support

## Skills

| Skill | Purpose |
|-------|---------|
| `/compaction-counter:status` | Check current session compaction count |
| `/compaction-counter:setup` | Integrate count into your status line |
