---
name: gco-code-patterns
description: Anti-pattern detection and error handling conventions for code quality. Invoke when reviewing code, handling errors, validating quality, or checking for common coding mistakes. Triggers on "error handling", "anti-pattern", "code quality", "code smell", "bad practice", or quality validation requests.
---

# Code Patterns: Anti-Patterns and Error Handling

## When to Invoke

Reviewing code, writing error handling, detecting anti-patterns, validating before merge, refactoring problematic code, teaching best practices, reviewing AI-generated code.

## Core Anti-Patterns

| Pattern | Problem | Fix | Severity |
|---------|---------|-----|----------|
| Silent fallback | `.get(x, 0)` hides missing data | Validate required fields explicitly | HIGH |
| God function | 200+ lines, multiple responsibilities | Split into focused functions | MEDIUM |
| Magic numbers | `if x > 86400` unclear intent | `SECONDS_PER_DAY = 86400` | LOW |
| Catch-all | `except Exception` swallows errors | Catch specific types only | HIGH |
| Single-letter vars | `for x in y` unreadable | Descriptive names | LOW |
| Deep nesting | 4+ indent levels | Early returns, guard clauses | MEDIUM |
| Copy-paste code | Duplicated logic | Extract to shared function | MEDIUM |
| Commented-out code | Clutter in production | Delete (git has history) | LOW |
| Hardcoded secrets | API keys in source | Load from env vars | CRITICAL |
| SQL concatenation | `f"WHERE id={id}"` injection risk | Parameterized queries | CRITICAL |
| No error handling | I/O without try/except | Add error handling | HIGH |
| N+1 queries | Loop with DB call | JOINs or eager loading | MEDIUM |

## AI Anti-Patterns (Top 10)

| Pattern | Occurrence | Severity |
|---------|------------|----------|
| Missing Error Handling | 62% | HIGH |
| Missing Edge Case Validation | 60-75% | MEDIUM-HIGH |
| Missing Logging/Observability | 70-80% | MEDIUM |
| Magic Numbers | 50-60% | LOW |
| Silent Fallbacks | 45-60% | HIGH |
| Hardcoded Secrets | 40-45% | CRITICAL |
| Catch-All Exceptions | 40-50% | HIGH |
| SQL Injection | 30-40% | CRITICAL |
| God Functions | 30-40% | MEDIUM |
| N+1 Query Problems | 25-35% | MEDIUM |

## Error Handling Essentials

**Do:** Fail fast, be explicit, provide context, log appropriately, use types
**Don't:** Silent fallbacks, catch-all handlers, generic messages, expose internals, ignore errors

## Quick Rejection Triggers

1. Hardcoded secrets (keys, passwords, tokens)
2. No error handling on I/O
3. Bare except/catch without re-raise
4. SQL string concatenation
5. Unvalidated user input in queries
6. Functions over 100 lines
7. Global mutable state

## Consultation Gates

For detailed examples and language-specific patterns, READ reference files:
- `references/language-patterns.md` - Python, JS/TS, Go error handling
- `references/ai-antipatterns.md` - Detection triggers and fixes
