---
name: gco-code-quality
description: Iterative refinement protocol for code quality improvement. Invoke when improving working code or performing multi-pass refinement.
---

# Code Quality: Iterative Refinement

## When to Invoke

- S/M-sized requirements requiring multi-pass refinement
- Improving "working but messy" code
- Before marking requirements complete

## 4-Pass Refinement Protocol

| Pass | Goal | Key Activities | Applies To |
|------|------|----------------|------------|
| **1: Initial** | Make it work | Functional requirements met, happy path, basic tests pass | All sizes |
| **2: Refinement** | Make it right | Error handling, constants, validation, naming, functions <50 lines | S+ |
| **3: Enhancement** | Production-ready | Edge/error tests, anti-pattern check, logging, coverage >80% | M+ |
| **4: Hardening** | Make it robust | Observability, retry logic, performance, graceful degradation | M/SPLIT (optional) |

## Pass Requirements by Size

| Size | Passes Required | Completion Standard |
|------|-----------------|---------------------|
| XS | Pass 1 only | Works, tested |
| S | Pass 1-2 | Right + tested |
| M | Pass 1-3 | Production-ready |
| SPLIT | Pass 1-4 | Robust + observable |

## Quick Improvement Patterns

| Problem | Fix |
|---------|-----|
| Magic numbers | `SECONDS_PER_DAY = 86400` |
| Missing error handling | `try/except` with specific types |
| Silent fallbacks | Explicit validation, raise on missing |
| Long functions | Extract helpers, single responsibility |

## Consultation Gates

⛔ For detailed checklists, pattern examples, language-specific fixes, READ `references/4-pass-details.md`

## See Also

- `gco-code-patterns` - Anti-pattern detection and error handling conventions
- `gco-completion-checklist` - Final verification before marking complete
