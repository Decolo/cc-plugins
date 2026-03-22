Propose concrete improvements to the CLAUDE.md files and `.claude/rules/` files in the current project and `~/.claude/CLAUDE.md`.

## Step 1: Discover and read all files

Read all of the following that exist:
1. `./CLAUDE.md`
2. `./.claude/CLAUDE.md`
3. `./.claude/rules/*.md`
4. `~/.claude/CLAUDE.md`
5. `~/.claude/rules/*.md`

## Step 2: Run a silent audit

Apply the same 5-criterion scoring from `/claude-md-health:audit` internally to identify all issues. Do not output the full audit table — summarize findings in one sentence per file before proposing changes.

## Step 3: Propose changes in priority order

Always address issues in this order:

### A. Deletions first (highest priority)
Identify content to remove entirely:
- Lines Claude can infer from reading the codebase (directory structure, obvious tech stack, boilerplate advice)
- Vague instructions that cannot be acted on ("write clean code", "handle errors properly")
- Duplicate content that already appears in another loaded file
- Outdated references (files or paths that no longer exist)
- Instructions so rarely applicable they don't belong in a file loaded every session

For each deletion, show:
```
**DELETE** from `<filepath>`:
- Reason: <one-line rationale>

```diff
- <line(s) to remove>
```
```

### B. Restructuring (move to rules files)
Identify content in root CLAUDE.md that is domain-specific and should move to `.claude/rules/<topic>.md`:
- TypeScript/language-specific conventions
- Testing patterns
- API design rules
- Git/commit conventions
- Domain-specific workflows

For each restructure, show:
```
**MOVE** from `<source>` to `.claude/rules/<topic>.md`:
- Reason: keeps root minimal, loaded only when relevant

Content to move:
<content block>

Remove from source entirely. Do not add an @import — `.claude/rules/` files are discovered and loaded automatically by Claude Code without imports. Unscoped rules load at launch; path-scoped rules (with `paths:` frontmatter) load when matching files are opened. Importing them via @import forces eager loading and usually defeats the purpose.
```

### C. Additions (lowest priority, only if genuinely missing)
Only suggest adding content if it is:
- Non-obvious (cannot be inferred from reading code)
- Universally applicable to every session
- Specific and actionable

For each addition, show:
```
**ADD** to `<filepath>`:
- Reason: <why this is non-obvious and universally applicable>

```diff
+ <content to add>
```
```

## Step 4: Approval gate

After presenting all proposed changes, ask:

> Which changes would you like to apply? Reply with the change letters/numbers, "all", or "none".

Wait for the user's response before making any edits.

## Step 5: Apply only approved changes

For each approved change, edit the relevant file. After applying:
- Show a summary of what was changed
- Report the new estimated line count per file
- Note: do NOT re-run the audit automatically; the user can run `/claude-md-health:audit` to verify

## Hard constraints

- Never edit any file without explicit user approval
- Never append session learnings or Claude's observations — that is what Auto Memory is for
- Never suggest adding architecture overviews, directory listings, or tech stack descriptions
- Never suggest content that is only relevant to one specific task
- If all files already score A, say so and stop — do not invent improvements
