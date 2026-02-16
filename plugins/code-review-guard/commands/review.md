# Code Review Command

Manually trigger a code review of recent changes.

## Usage

```
/code-review-guard:review [--staged]
```

## Options

- `--staged`: Review only staged changes (git diff --cached) instead of all uncommitted changes

## Behavior

This command delegates to the `code-reviewer` agent to perform a comprehensive review of your code changes. The agent will:

1. Read project guidelines from CLAUDE.md files
2. Analyze the git diff to identify changed files
3. Review changes for security, quality, and architectural consistency
4. Provide a structured report with findings grouped by severity

## When to Use

- Before committing changes to verify code quality
- After making significant changes to get feedback
- When you want a second opinion on your implementation
- To ensure changes follow project conventions

## Example

```bash
# Review all uncommitted changes
/code-review-guard:review

# Review only staged changes
/code-review-guard:review --staged
```

---

**Implementation**: Use the `code-reviewer` agent to review changes. Pass the `--staged` flag context if provided.
