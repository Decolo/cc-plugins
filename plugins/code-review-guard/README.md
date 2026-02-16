# Code Review Guard

Auto-reviews code changes when Claude stops responding — reads project CLAUDE.md for architecture rules, checks security, quality, and pattern consistency.

## Features

- **Automatic Review on Stop**: Triggers code review when Claude finishes responding if code changes are detected
- **Project-Aware**: Reads `.claude/CLAUDE.md` and root `CLAUDE.md` to apply project-specific rules
- **Multi-Language Support**: Works with Python, JavaScript, TypeScript, Go, Rust, Java, Ruby, C/C++, and more
- **Manual Trigger**: Use `/code-review-guard:review` to review changes on demand
- **Loop Prevention**: Smart sentinel prevents infinite review loops

## Installation

```bash
# Add the marketplace (one-time setup)
/plugin marketplace add cc-plugins /Users/decolo/Github/cc-plugins

# Install the plugin
/plugin install code-review-guard@cc-plugins
```

## Usage

### Automatic Review (Stop Hook)

The plugin automatically triggers when:
1. Claude finishes responding (Stop event)
2. Code files have been modified (staged, unstaged, or untracked)
3. Not already in a review loop

When triggered, Claude will be blocked from stopping and prompted to use the `code-reviewer` agent.

### Manual Review

```bash
# Review all uncommitted changes
/code-review-guard:review

# Review only staged changes
/code-review-guard:review --staged
```

## How It Works

1. **Stop Hook**: Detects code changes using `git diff` and filters for code file extensions
2. **Code Reviewer Agent**: Analyzes changes against:
   - Project-specific rules from CLAUDE.md files
   - Security best practices
   - Code quality standards
   - Pattern consistency
3. **Structured Output**: Provides findings grouped by severity (Critical, Warning, Info)

## Configuration

The plugin reads architecture rules and coding standards from:
- `.claude/CLAUDE.md` (project-specific guidelines)
- `CLAUDE.md` (root-level guidelines)

Add your project's conventions, patterns, and requirements to these files for customized reviews.

## Supported File Types

Python, JavaScript, TypeScript, JSX, TSX, Go, Rust, Java, Ruby, C, C++, C#, PHP, Swift, Kotlin, Scala, Shell, YAML, TOML, JSON, Markdown, SQL, HTML, CSS, SCSS, Vue, Svelte

## Example Review Output

```
## Code Review Summary

**Files reviewed**: src/auth.py, src/config.py
**Severity counts**: 🔴 Critical: 0 | 🟡 Warning: 1 | 🔵 Info: 2

### 🟡 Warning
- [src/auth.py:45] API key loaded from environment but no fallback validation

### 🔵 Info / Suggestions
- [src/config.py:12] Consider using dataclass for config structure
- [src/auth.py:23] Type hint missing on return value

### ✅ Looks Good
- Follows project naming conventions
- Error handling properly implemented
```

## License

MIT
