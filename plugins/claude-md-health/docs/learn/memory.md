# Claude Code Memory

> How Claude remembers things across sessions, and how to use both memory systems well.

Source: [Anthropic official docs: Memory](https://code.claude.com/docs/en/memory)

---

## The core problem

Every Claude Code session starts with a blank context window. Without a memory mechanism, Claude forgets everything between sessions — your preferences, your build commands, the bugs you fixed together.

Claude Code solves this with two complementary systems:

| | CLAUDE.md files | Auto Memory |
|---|---|---|
| Who writes it | You | Claude |
| What it contains | Instructions and rules | Learnings and patterns |
| Scope | Project, user, or org | Per working tree (git repo) |
| Loaded into | Every session (full file) | Every session (first 200 lines of MEMORY.md) |
| Use for | Coding standards, workflows, architecture | Build commands, debugging insights, preferences Claude discovers |

---

## CLAUDE.md files

You write these. Claude reads them at the start of every session.

See [best-practices.md](best-practices.md) for full guidance on what to put in CLAUDE.md and how to structure it.

---

## Auto Memory

Claude writes this. You benefit from it automatically.

### How it's triggered

**Explicit** — tell Claude directly:

> "always use pnpm, not npm"
> "remember that the API tests require a local Redis instance"

Claude immediately saves it to the Auto Memory files.

**Implicit** — Claude learns from corrections:

You correct Claude's behavior → Claude judges it's a preference worth keeping → writes it automatically. No command needed.

### Where the files live

```
~/.claude/projects/<project>/memory/
├── MEMORY.md          # Index, first 200 lines loaded every session
├── debugging.md       # Detailed notes on debugging patterns
├── api-conventions.md # API design decisions
└── ...                # Other topic files Claude creates
```

`<project>` is derived from the git repository root. All worktrees and subdirectories within the same repo share one Auto Memory directory.

**Important**: Auto Memory is machine-local. It is not committed to Git and does not sync across machines.

### Loading behavior

- `MEMORY.md` first 200 lines: loaded at every session start
- `MEMORY.md` beyond line 200: not loaded automatically
- Topic files (e.g. `debugging.md`): not loaded at startup — Claude reads them on demand during the session

Claude keeps `MEMORY.md` concise by moving detailed notes into topic files, so the 200-line index stays useful.

### Enable / disable

Auto Memory is on by default (requires Claude Code 2.1.59+).

```json
// .claude/settings.json
{ "autoMemoryEnabled": false }
```

Or via environment variable:

```sh
CLAUDE_CODE_DISABLE_AUTO_MEMORY=1
```

To store Auto Memory in a custom location (user or local settings only — not project settings):

```json
{ "autoMemoryDirectory": "~/my-custom-memory-dir" }
```

### The /memory command

Run `/memory` inside a session to:

- See all CLAUDE.md and rules files loaded in this session
- Toggle Auto Memory on/off
- Open any memory file in your editor

---

## Who writes what

The most common mistake is putting Auto Memory's job into CLAUDE.md.

| Scenario | Where it goes |
|---|---|
| Team coding standard | `./CLAUDE.md` (versioned, shared) |
| Personal tool preference | `~/.claude/CLAUDE.md` (user-level) |
| "Remember I prefer const over let" | Say it to Claude → Auto Memory |
| Build command Claude discovered | Auto Memory (Claude writes it) |
| Non-standard run command | `CLAUDE.md` (you write it explicitly) |

Appending session learnings to CLAUDE.md manually is how the ball-of-mud anti-pattern starts. Let Auto Memory handle what Claude discovers; keep CLAUDE.md for what you intentionally prescribe.
