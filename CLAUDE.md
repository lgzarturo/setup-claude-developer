# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Interactive setup scripts that scaffold a Claude Code + OpenCode developer environment in any project. Two equivalent scripts — `setup.sh` (Linux/macOS bash) and `setup.ps1` (Windows PowerShell) — must stay in sync.

## Running the Scripts

```bash
# Linux/macOS
bash setup.sh

# Windows PowerShell
.\setup.ps1
```

Both scripts are interactive: prompt user to select stacks (1–6), then generate files under `.claude/` and `.opencode/`.

## Architecture

### What the scripts generate

```
.claude/
  skills/<name>/SKILL.md    # AI skills with YAML frontmatter
  commands/run-all-tests.md # Slash commands
  agents/code-reviewer.md   # Subagent definitions
.opencode/                  # Mirror of .claude/ (identical files)
CLAUDE.md                   # Opinionated base rules for target project
```

### Universal skills (always created)

- `testing-tdd` — TDD cycle, stack-aware test tooling
- `security` — OWASP Top 10, stack-aware auth
- `code-review` — structured review format
- `testing-coverage` — 80% threshold + GitHub Actions CI

### Stack-specific skills (user selects)

| #   | Stack                | Skill name                |
| --- | -------------------- | ------------------------- |
| 1   | Spring Boot + Kotlin | `spring-boot-kotlin-rest` |
| 2   | Python + UV + Django | `python-django-uv`        |
| 3   | Python + FastAPI     | `python-fastapi`          |
| 4   | Next.js + TypeScript | `nextjs-typescript`       |
| 5   | Astro                | `astro`                   |
| 6   | All stacks           | all of the above          |

### Skill file format

```markdown
---
name: skill-name
description: One-line description of what the skill does
license: MIT
---

## Reglas obligatorias
- Rule 1
- Rule 2

## Reglas por stack
**Stack Name** → tool/framework

## Cuándo usarme
- "Example trigger phrase"
```

### Agent file format

```markdown
---
description: What the agent does
mode: subagent
model: anthropic/claude-sonnet-4-20250514
temperature: 0.1
tools:
  write: false
  edit: false
  bash: false
---

Agent instructions here.
```

## Known Bug in setup.sh

`create_skill` uses a heredoc with `'SKILL'` (single-quoted, no expansion), so `$content` is written literally instead of expanded. The PowerShell version works correctly. Any fix must use `printf '%s' "$content"` or `echo "$content"` instead of heredoc.

## Sync Rule

Every skill, agent, and command created under `.claude/` must be mirrored to `.opencode/`. Both scripts copy files identically — keep this behavior when adding new stacks or skills.

## Approach

- Think before acting. Read existing files before writing code.
- Be concise in output but thorough in reasoning.
- Prefer editing over rewriting whole files.
- Do not re-read files you have already read unless the file may have changed.
- Skip files over 100KB unless explicitly required.
- Suggest running /cost when a session is running long to monitor cache ratio.
- Recommend starting a new session when switching to an unrelated task.
- Test your code before declaring done.
- No sycophantic openers or closing fluff.
- Keep solutions simple and direct.
- User instructions always override this file.
