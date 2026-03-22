Audit the CLAUDE.md files and `.claude/rules/` files in the current project and the user's global `~/.claude/CLAUDE.md`.

## What to audit

Discover and read all of the following:
1. `./CLAUDE.md` (project root, if it exists)
2. `./.claude/CLAUDE.md` (local project, if it exists)
3. `./.claude/rules/` (all `.md` files, if directory exists)
4. `~/.claude/CLAUDE.md` (user global, if it exists)

Use the Read and Glob tools to find and read these files. Do not edit any files.

## Scoring criteria (100 points total)

Score each file independently, then produce an overall score.

### 1. Brevity (25 pts)
- **25**: Root CLAUDE.md under 100 lines; rules files each under 80 lines; no repeated content across files
- **18**: Root under 200 lines (Anthropic's official limit); minor redundancy
- **10**: Root 200–300 lines; noticeable redundancy
- **5**: Root over 300 lines; significant duplication
- **0**: Severely bloated; same info in multiple files

### 2. Non-obvious content only (25 pts)
Content Claude can infer by reading the codebase itself scores zero. This includes:
- Directory/file structure listings
- Tech stack descriptions (already in package.json, pyproject.toml, etc.)
- Boilerplate advice ("write clean code", "handle errors properly")
- Standard conventions for the language/framework already well-known
- **25**: Every line contains information Claude cannot infer from reading files
- **18**: Mostly non-obvious; 1–2 inferable items
- **10**: Several inferable items consuming meaningful space
- **5**: Significant portion is redundant with what code makes obvious
- **0**: Mostly boilerplate or inferable content

### 3. Progressive disclosure (20 pts)
- **20**: Root CLAUDE.md is minimal; detailed topic rules live in `.claude/rules/` files linked via `@path` imports; each rules file is focused on one domain
- **14**: Some rules split out, but root still contains domain-specific detail that could be extracted
- **8**: Everything in root CLAUDE.md with no rules/ files despite complexity
- **0**: Monolithic file with no structure

### 4. Actionability (20 pts)
- **20**: All commands are copy-pasteable (e.g., `npm run test`); all file paths are real and verified; no vague instructions
- **14**: Mostly actionable; 1–2 vague or unverifiable instructions
- **8**: Several instructions are vague ("run the tests", "check formatting")
- **0**: Majority of instructions are vague or unverifiable

### 5. Conflict-free (10 pts)
- **10**: No contradicting rules across any of the files
- **5**: Minor tension between rules that could cause confusion
- **0**: Direct contradictions found (e.g., "always use X" in one file, "never use X" in another)

## Grade scale
- **A** (90–100): Excellent
- **B** (75–89): Good, minor issues
- **C** (60–74): Needs improvement
- **D** (40–59): Significant problems
- **F** (0–39): Requires major overhaul

## Output format

For each file found, produce a table:

```
### `<filepath>`
| Criterion             | Score | Max | Notes |
|-----------------------|-------|-----|-------|
| Brevity               |       | 25  |       |
| Non-obvious only      |       | 25  |       |
| Progressive disclosure|       | 20  |       |
| Actionability         |       | 20  |       |
| Conflict-free         |       | 10  |       |
| **Total**             |       | 100 |       |

**Grade: X**

Top issues:
1. <most impactful issue>
2. <second issue>
3. <third issue>
```

Then end with a summary:

```
## Overall Health Summary
| File | Score | Grade |
|------|-------|-------|
| ...  |       |       |

**Overall grade: X**

Highest-priority fix: <single most impactful change across all files>
```

Do not suggest any edits. This command is read-only. To apply improvements, run `/claude-md-health:improve`.
