# cc-plugins

Personal Claude Code plugin marketplace by decolo.

## Plugins

### [code-review-guard](./plugins/code-review-guard)

Auto-reviews code changes on Stop — reads project CLAUDE.md for architecture rules, checks security, quality, and pattern consistency.

**Features:**
- Automatic review when Claude stops responding
- Project-aware (reads CLAUDE.md files)
- Multi-language support
- Manual trigger with `/code-review-guard:review`
- Loop prevention

## Installation

Add this marketplace to Claude Code:

```bash
/plugin marketplace add cc-plugins /Users/decolo/Github/cc-plugins
```

Then install plugins:

```bash
/plugin install code-review-guard@cc-plugins
```

## Structure

```
cc-plugins/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace registry
├── plugins/
│   └── code-review-guard/        # Code review plugin
│       ├── .claude-plugin/
│       │   └── plugin.json       # Plugin manifest
│       ├── agents/
│       │   └── code-reviewer.md  # Review agent
│       ├── commands/
│       │   └── review.md         # Manual review command
│       ├── hooks/
│       │   ├── hooks.json        # Hook registration
│       │   └── review-on-stop.sh # Stop hook script
│       └── README.md
└── README.md
```

## Development

To add a new plugin:

1. Create plugin directory under `plugins/`
2. Add plugin manifest at `.claude-plugin/plugin.json`
3. Implement agents, commands, and/or hooks
4. Register in root `marketplace.json`
5. Document in plugin README

## License

MIT
