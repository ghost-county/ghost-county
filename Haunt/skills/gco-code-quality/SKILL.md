---
name: gco-code-quality
description: Code quality refinement patterns for iterative improvement. Use when performing code refinement passes or need guidance on quality improvements.
---

# Code Quality: Iterative Refinement Patterns

## Purpose

Guidance for iterative code refinement process: Pass 1 (Initial) → Pass 2 (Refinement) → Pass 3 (Enhancement) → Pass 4 (Production Hardening, optional).

## When to Invoke

- Writing code for any requirement/roadmap item that is larger than an XS size
- Performing Pass 2 (Refinement) or Pass 3 (Enhancement)
- Reviewing code for quality issues before marking complete
- Stuck on how to improve "working but messy" code
- Need specific guidance on what to improve in each pass

## Quick Reference: Refinement Passes

### Pass 1: Initial Implementation
**Goal:** Make it work.
- Functional requirements met
- Happy path implemented
- Basic tests pass

### Pass 2: Refinement
**Goal:** Make it right.
- Error handling for all I/O
- Magic numbers → named constants
- Explicit validation (no silent fallbacks)
- Descriptive names
- Functions <50 lines

### Pass 3: Enhancement (M-sized)
**Goal:** Make it production-ready.
- Edge case + error case tests
- Security review (if applicable)
- Anti-pattern check
- Logging for errors
- Coverage >80%

### Pass 4: Production Hardening (Optional, M/SPLIT)
**Goal:** Make it robust.
- Observability (correlation IDs, metrics)
- Retry logic + circuit breakers
- Performance verification
- Graceful degradation

## Consultation Gates

⛔ **CONSULTATION GATE:** For detailed pass checklists (error handling, validation, testing, security, resilience), READ `references/4-pass-details.md`.

⛔ **CONSULTATION GATE:** For improvement pattern examples (replace magic numbers, add error handling, extract functions, add tests), READ `references/4-pass-details.md`.

⛔ **CONSULTATION GATE:** For language-specific patterns (Python, JS/TS constants, error handling, validation), READ `references/4-pass-details.md`.

⛔ **CONSULTATION GATE:** For anti-pattern examples (silent fallback, catch-all, magic numbers with WRONG/RIGHT code), READ `references/4-pass-details.md`.

## Self-Review Questions

**Pass 1:**
- Does code meet functional requirements?
- Do basic tests pass?

**Pass 2:**
- What if input is empty/null/wrong type?
- What if network/file operations fail?
- Are variable names clear?
- Are functions focused (<50 lines)?

**Pass 3:**
- What edge cases am I not testing?
- Is this vulnerable to security issues?
- Am I repeating anti-patterns?
- Will this be easy to debug in production?

**Pass 4 (M/SPLIT only):**
- How will I debug this with logs?
- What if external service fails?
- How does this perform under load?

## Quick Pattern Reference

### Replace Magic Numbers
**BEFORE:** `if elapsed > 86400:`
**AFTER:** `SECONDS_PER_DAY = 86400; if elapsed > SECONDS_PER_DAY:`

### Add Error Handling
**BEFORE:** `data = json.load(open("config.json"))`
**AFTER:**
```python
try:
    with open("config.json", "r") as f:
        return json.load(f)
except FileNotFoundError:
    logger.error("Config file not found")
    raise ConfigurationError("Missing config.json")
```

### Explicit Validation
**BEFORE:** `user_id = data.get("user_id", "unknown")`
**AFTER:**
```python
if "user_id" not in data:
    raise ValidationError("user_id is required")
user_id = data["user_id"]
```

### Extract Long Functions
**BEFORE:** 80+ line function with validation, DB, API, formatting
**AFTER:**
```python
def handle_request(request):
    validate_request(request)
    user = fetch_user(request.user_id)
    result = process_data(user, request.data)
    return format_response(result)
```

## Success Criteria

**After Pass 2:**
- Error handling comprehensive
- Constants replace magic numbers
- Validation explicit
- Functions focused (<50 lines)

**After Pass 3:**
- Test coverage >80%
- Edge cases + error cases tested
- No anti-patterns
- Ready for production

**After Pass 4 (optional):**
- Observability in place
- Retry logic implemented
- Performance verified
