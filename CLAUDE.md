A collection of Claude Code plugins. Each plugin lives under `plugins/<name>/` and is self-contained.

## Plugin structure

- `.claude-plugin/plugin.json` — plugin manifest (name, version, description)
- `commands/<cmd>.md` — slash command prompts
- `docs/` — user-facing documentation

## Adding a new plugin

Create a directory under `plugins/` following the structure above. Commands are markdown prompt files — no build step required.
