# claude-md-health

Audits and improves your CLAUDE.md files by rewarding brevity and penalizing bloat.

## Philosophy

Based on [Anthropic's official guidance](https://code.claude.com/docs/en/memory), [HumanLayer](https://www.humanlayer.dev/blog/writing-a-good-claude-md), and [AI Hero](https://www.aihero.dev/a-complete-guide-to-agents-md):

- **Less is more.** Every token in CLAUDE.md is loaded into every session. Frontier models follow ~150–200 instructions reliably; a bloated file causes Claude to ignore the whole thing.
- **Only non-obvious content.** Don't document what Claude can infer by reading the codebase (directory structure, tech stack, boilerplate advice like "write clean code").
- **Progressive disclosure.** Keep the root CLAUDE.md minimal (under 200 lines). Move domain-specific rules to `.claude/rules/` files with `paths:` frontmatter so they load only when relevant.
- **Never auto-append.** Session learnings belong in Auto Memory, not CLAUDE.md. Appending is how the ball-of-mud anti-pattern starts.
- **Describe capabilities, not paths.** File paths go stale and poison context. Document *what* the code does, not *where* it lives.

See [docs/learn/best-practices.md](docs/learn/best-practices.md) for the full rationale and source analysis.

## Commands

### `/claude-md-health:audit`

Reads all CLAUDE.md and `.claude/rules/` files in scope and produces a quality report. **No edits.**

Scoring criteria (100 pts):

| Criterion | Weight | What it measures |
|---|---|---|
| Brevity | 25 pts | Line count, redundancy across files |
| Non-obvious content only | 25 pts | No inferable info, no boilerplate |
| Progressive disclosure | 20 pts | Root is minimal; rules in `.claude/rules/` |
| Actionability | 20 pts | Commands are copy-pasteable; no vague instructions |
| Conflict-free | 10 pts | No contradicting rules across files |

Outputs a score table per file and an overall grade (A–F).

### `/claude-md-health:improve`

Proposes concrete edits based on audit findings. Always in this order:

1. **Deletions first** — redundant, inferable, vague, or outdated content
2. **Restructuring** — move domain-specific content to `.claude/rules/` files
3. **Additions** — only if genuinely missing and universally applicable

Each proposed change shows a diff and a one-line rationale. Nothing is applied without your explicit approval.

## What this plugin does NOT do

- No auto-appending of session learnings (use Auto Memory for that)
- No scoring of architecture comprehensiveness
- No suggestions to add directory listings or tech stack descriptions
