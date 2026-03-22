# CLAUDE.md Best Practices

> This page explains the *why* behind `claude-md-health`'s scoring criteria.

## The core problem: instruction budget

Every token in your CLAUDE.md is loaded into every session, regardless of relevance. Frontier thinking models can follow roughly 150–200 instructions with reasonable consistency; smaller or non-thinking models handle fewer. A bloated CLAUDE.md doesn't just waste tokens — it causes Claude to ignore the whole file.

The natural feedback loop that creates bloat:

1. Claude does something you don't like
2. You add a rule to prevent it
3. Repeat hundreds of times
4. File becomes a "ball of mud"

## What belongs in CLAUDE.md

Only content Claude **cannot infer by reading your codebase**:

| Put it in CLAUDE.md | Leave it out |
|---|---|
| Non-standard build/test commands | Directory structure listings |
| Architectural decisions not obvious from code | Tech stack (already in package.json) |
| Domain terminology (e.g. "workspace" ≠ "organization") | "Write clean code" |
| Package manager if not npm | Language conventions Claude already knows |
| One-sentence project description | File paths (they change) |

### The one-liner project description

A single sentence anchors every decision Claude makes. Example:

```
This is a React component library for accessible data visualization.
```

That's a role-based prompt. It's worth keeping. Everything else is optional.

## File locations and scope

Claude Code loads multiple CLAUDE.md files and merges them. More specific locations take precedence.

| Location | Scope | Use for |
|---|---|---|
| `./CLAUDE.md` or `./.claude/CLAUDE.md` | Project (versioned) | Team coding standards, architecture decisions |
| `~/.claude/CLAUDE.md` | User (all projects) | Personal tool preferences, code style |
| `subdir/CLAUDE.md` | Directory (lazy-loaded) | Subdirectory-specific rules |

**Lazy loading**: Subdirectory CLAUDE.md files are only loaded when Claude reads files in that directory. This saves context budget automatically.

## Progressive disclosure with `.claude/rules/`

Instead of cramming everything into the root CLAUDE.md, split domain-specific rules into `.claude/rules/` files:

```
.claude/rules/
├── typescript.md    # loaded only for .ts/.tsx files
├── testing.md       # loaded only for test files
└── api-design.md    # loaded only for src/api/**
```

Each rules file can declare which file patterns trigger it:

```yaml
---
paths:
  - "src/**/*.{ts,tsx}"
  - "tests/**/*.test.ts"
---
```

The root CLAUDE.md then becomes a minimal index:

```markdown
This is a Node.js GraphQL API using Prisma.

Package manager: pnpm

Build: pnpm build
Test: pnpm test

@.claude/rules/typescript.md
@.claude/rules/testing.md
```

## Stale documentation is actively harmful

Human developers can be skeptical of outdated docs. Claude reads documentation on every request and treats it as ground truth. Stale information — especially file paths — causes Claude to look in the wrong place with full confidence.

**Prefer describing capabilities over structure:**

```markdown
# Instead of:
Authentication logic lives in src/auth/handlers.ts

# Write:
Authentication uses JWT. Session handling is separated from route logic.
```

Domain concepts ("workspace" vs "organization") are safer to document than paths, but even these drift in fast-moving codebases. Keep a light touch.

## Auto memory vs CLAUDE.md

Claude Code has two complementary memory systems:

| | CLAUDE.md | Auto Memory |
|---|---|---|
| Who writes it | You | Claude |
| What it contains | Instructions and rules | Learnings and patterns |
| Loaded into | Every session | Every session (first 200 lines) |
| Use for | Coding standards, workflows | Build commands Claude discovers, debugging insights |

Session learnings — things Claude figured out during a conversation — belong in Auto Memory, not CLAUDE.md. Appending them to CLAUDE.md is how the ball-of-mud anti-pattern starts.

## The 200-line limit

Anthropics's official guidance: files over 200 lines consume more context and reduce adherence. If your root CLAUDE.md exceeds this:

1. Move domain-specific content to `.claude/rules/` files
2. Use `@path` imports to reference them
3. Run `/init` to let Claude suggest improvements to an existing file

## Sources

- [Anthropic official docs: Memory](https://code.claude.com/docs/en/memory)
- [HumanLayer: Writing a Good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md) — source of the 150–200 instruction budget concept
- [AI Hero: A Complete Guide to AGENTS.md](https://www.aihero.dev/a-complete-guide-to-agents-md) — practical minimization guide
