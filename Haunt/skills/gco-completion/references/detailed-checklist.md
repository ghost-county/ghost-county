# Completion Checklist: Detailed Reference

This reference contains detailed checklists for completion verification.

## Iterative Code Refinement Passes

**Refinement Requirements by Task Size:**
- **XS (<10 lines):** 1-pass acceptable for trivial changes
- **S (10-50 lines):** 2-pass minimum (Initial → Refinement)
- **M (50-300 lines):** 3-pass required (Initial → Refinement → Enhancement)
- **SPLIT (>300 lines):** Decompose first, then 3-4 passes per piece

### Pass 1: Initial Implementation

**Goal:** Make it work.

**Checklist:**
- [ ] Functional requirements met
- [ ] Happy path implemented
- [ ] Basic tests written and passing
- [ ] Core acceptance criteria satisfied

**Common Issues to Accept (fix in Pass 2):**
- Hard-coded values and magic numbers
- Missing error handling
- Poor variable names
- Long functions
- Minimal test coverage

### Pass 2: Refinement (S/M Required)

**Goal:** Make it right.

**Error Handling:**
- [ ] Try/except (or try/catch) around all I/O operations (file, network, database)
- [ ] Specific exception types caught (not `Exception` or `catch(e)` catch-all)
- [ ] Error messages include context (what failed, why it matters)
- [ ] Errors logged with appropriate level (error/warn)
- [ ] Errors propagated or handled gracefully (no silent swallowing)

**Constants & Validation:**
- [ ] All magic numbers replaced with named constants
- [ ] Constants grouped logically (e.g., `MIN_`, `MAX_`, `DEFAULT_` prefixes)
- [ ] Input validation explicit (check required fields, don't use `.get(key, default)`)
- [ ] Type checking added (isinstance, typeof, type hints)
- [ ] Range validation for numeric inputs (min/max bounds)

**Naming & Structure:**
- [ ] Variable names descriptive (no single letters except i, j, k in loops)
- [ ] Function names are verbs describing what they do
- [ ] Boolean variables named as questions (is_valid, has_permission, should_retry)
- [ ] Functions <50 lines (extract helpers if over)
- [ ] Functions do one thing (single responsibility)

**Cleanup:**
- [ ] No console.log, print, or debug statements
- [ ] No commented-out code (delete it, git preserves history)
- [ ] No TODO/FIXME without tracking (create REQ or remove)
- [ ] No unused imports or variables
- [ ] Consistent formatting (run formatter if available)

### Pass 3: Enhancement (M Required)

**Goal:** Make it production-ready.

**Test Coverage:**
- [ ] Happy path tests exist (already from Pass 1)
- [ ] Edge case tests added:
  - Empty input (empty string, empty array, null)
  - Boundary values (0, max int, very large numbers)
  - Special characters in strings
  - Unexpected types
- [ ] Error case tests added:
  - Network failures
  - File not found
  - Permission denied
  - Invalid input formats
- [ ] Test independence verified (don't rely on order or shared state)
- [ ] Test coverage >80% for new code

**Security (if applicable):**
- [ ] User input sanitized (no SQL injection, XSS, command injection)
- [ ] Authentication/authorization checked
- [ ] Secrets not hardcoded (use env vars or config)
- [ ] Sensitive data not logged (passwords, tokens, PII)
- [ ] HTTPS used for external API calls
- [ ] Rate limiting considered for public endpoints

**Anti-Pattern Check:**
- [ ] No silent fallbacks on required data (`.get(key, default)` for required fields)
- [ ] No catch-all exception handlers (`except Exception`, `catch(e)`)
- [ ] No magic numbers without named constants
- [ ] No god functions (>100 lines, multiple responsibilities)
- [ ] No deep nesting (>3 levels of indent)
- [ ] No copy-paste code (extract to shared function)

**Logging:**
- [ ] Error conditions logged with context
- [ ] Important state transitions logged (not every line)
- [ ] Log levels appropriate (debug/info/warn/error)
- [ ] Sensitive data not logged
- [ ] Logs include correlation IDs (if applicable)

### Pass 4: Production Hardening (M/SPLIT Optional)

**Goal:** Make it robust.

**Observability:**
- [ ] Correlation IDs added for request tracing
- [ ] Metrics emitted for key operations (latency, error rate, throughput)
- [ ] Structured logging used (JSON format, searchable fields)
- [ ] Debugging context included in logs

**Resilience:**
- [ ] Retry logic with exponential backoff for transient failures
- [ ] Circuit breaker pattern for failing external dependencies
- [ ] Timeouts configured for all external calls
- [ ] Graceful degradation when dependencies unavailable
- [ ] Bulkhead pattern to isolate failures

**Performance:**
- [ ] Performance acceptable under expected load
- [ ] Database queries optimized (indexes, no N+1 queries)
- [ ] Caching added where beneficial
- [ ] Resource cleanup (close connections, file handles)
- [ ] Memory leaks prevented (no unbounded growth)

## Self-Validation Checklist

**After completing refinement passes**, perform final self-validation:

### Code Review
- [ ] **Re-read the original requirement** and verify all completion criteria met
- [ ] **Review your own code changes** for obvious issues:
  - No debugging code left (console.log, print statements, commented-out code)
  - No TODO/FIXME comments without tracking (create REQ instead)
  - Variable names are descriptive
  - Functions are focused and under 50 lines
  - No magic numbers (use named constants)

### Test Validation
- [ ] **Confirm tests actually test the feature** (not just exist):
  - Tests fail when feature is broken (not false positives)
  - Edge cases are covered (empty input, boundary values, error conditions)
  - Tests are independent (don't rely on order or shared state)
  - **For UI work:** E2E tests use proper selectors (data-testid preferred, NOT CSS nth-child)

### Manual Verification
- [ ] **Run the code yourself** (if applicable):
  - Execute feature manually to verify behavior
  - Check error messages are user-friendly
  - Verify performance is acceptable

### Anti-Pattern Check
- [ ] **Double-check against anti-patterns** from `.haunt/docs/lessons-learned.md`:
  - No silent fallbacks on required data
  - Explicit error handling (no catch-all exceptions)
  - No hardcoded secrets or credentials

**Why this matters:** Catching your own mistakes before Code Reviewer saves time and reduces rework. Self-validation is the difference between "I'm done" and "This is ready for review."

## Code Review Handoff (M/SPLIT Requirements)

**For M/SPLIT requirements, automatic code review is REQUIRED.**

### Handoff Format

Use `/summon code-reviewer` with this format:

```
/summon code-reviewer "Review REQ-XXX: [Requirement Title]

**Context:**
- Effort: M/SPLIT (automatic review required)
- Files changed: [count] files ([list file paths])
- Tests: [passing count] passing

**Changes Summary:**
[2-3 sentence summary of what was implemented]

**Self-Validation:**
- [x] All tasks checked off
- [x] Tests passing ([test command output summary])
- [x] Security review complete (or N/A)
- [x] Code review for obvious issues
- [x] Anti-patterns checked

**Request:**
Please review and update REQ-XXX status based on verdict (APPROVED → 🟢, CHANGES_REQUESTED → 🟡, BLOCKED → 🔴)"
```

### After Code Review

- Code Reviewer updates requirement status based on verdict
- APPROVED → Requirement marked 🟢, work complete
- CHANGES_REQUESTED → Status remains 🟡, fix issues and re-submit
- BLOCKED → Status changed to 🔴, resolve blocking issues

**Rationale:** XS/S changes (1-2 files, 1-2 hours) have low risk and benefit from faster iteration with self-validation. M/SPLIT changes (4+ files, 2+ hours) have higher complexity and risk, warranting mandatory code review for quality assurance.

## UI/UX Validation (Frontend Work)

**Applies to:** All UI generation, component creation, or visual design changes.

**See `.claude/rules/gco-ui-design-standards.md` for full details.**

### Quick Checklist

- [ ] **8px Grid Spacing** - All spacing uses 8px increments (16px, 24px, 32px, etc.)
  - Verify: Inspect CSS/styles - all margin/padding/gap values divisible by 8
  - Fine-tuning: 4px allowed ONLY for optical alignment
- [ ] **4.5:1 Contrast Minimum** - All text meets WCAG AA contrast standards
  - Verify: Use WebAIM Contrast Checker or browser DevTools
  - Test: Light mode AND dark mode (if applicable)
- [ ] **5 Interactive States** - All buttons/links define: default, hover, active, focus, disabled
  - Verify: Manually test each state or inspect CSS for all 5 state definitions
- [ ] **44×44px Touch Targets** - All clickable elements meet minimum size
  - Verify: Measure button/link dimensions (48×48px preferred)
- [ ] **Keyboard Navigation** - All interactive elements accessible via keyboard
  - Test: Tab through page, verify focus order and Enter/Space activation
- [ ] **Skip Links** - Page includes skip-to-content link
  - Test: Tab on page load, first focusable element should be skip link
- [ ] **Semantic HTML** - Proper element usage (button, nav, main, etc.)
  - Verify: No `<div onclick>`, use `<button>` instead
- [ ] **Focus Indicators** - Visible 3px minimum outline on focus
  - Test: Tab through page, verify all focusable elements show outline
- [ ] **Color Blindness** - UI works in grayscale/protanopia/deuteranopia
  - Test: Use browser DevTools vision deficiency emulation
- [ ] **Mobile Responsive** - Layout tested at 320px width minimum
  - Test: Browser DevTools responsive mode, verify no horizontal scroll

### Validation Commands

```bash
# Check contrast (manual - use online tool)
# https://webaim.org/resources/contrastchecker/

# Test responsive (Chrome DevTools)
# Cmd+Opt+I → Toggle device toolbar → Test 320px, 768px, 1024px widths

# Test color blindness (Chrome DevTools)
# Cmd+Opt+I → Rendering → Emulate vision deficiencies
```

### Common Failure Modes

- Light gray text on white background (fails contrast)
- Buttons without hover states (incomplete state management)
- Arbitrary spacing (15px, 20px, 25px instead of 8px grid)
- Touch targets <44px (mobile usability failure)
- Missing focus indicators (keyboard accessibility failure)

**Why this matters:** UI/UX validation prevents common AI-generated UI failures: poor contrast, inconsistent spacing, missing interactive states, and accessibility gaps. These issues are expensive to fix later and frustrate users.

## Professional Standards (Final Gate)

### The CTO Question

**"Would I demonstrate this code to my CTO/boss with confidence?"**

If the answer is **NO** or **"maybe with caveats"**, the work is **NOT complete**. Go back and fix it.

### Reflection Questions

Ask yourself:

**Is this professional quality work?**
- Would I be proud to show this in a code review?
- Does this represent my best work, or "good enough to pass"?
- Would I trust this code in production under load?

**Have I actually tested this, or just assumed it works?**
- Did I run the tests myself, or just write them?
- Did I manually verify the feature works as intended?
- Did I test edge cases and error scenarios, not just happy path?

**Am I cutting corners to mark this complete faster?**
- Am I skipping tests because "it's a simple change"?
- Am I leaving TODO comments instead of finishing the work?
- Am I marking incomplete work as complete to move on?

### Professional Accountability

**Testing is not a bureaucratic checkbox. It's professional accountability.**

- Untested code ships bugs to users
- Skipped edge cases cause production incidents
- "It worked on my machine" is not professional
- Your reputation is on the line with every commit

### The Standard

**If you wouldn't demo it to your boss, don't mark it 🟢**

This is the final gate. If you cannot honestly answer "YES, I would confidently demonstrate this work to my CTO," then:

1. Go back and fix what's missing
2. Write the tests you skipped
3. Handle the edge cases you ignored
4. Make it professional quality

**Only then** mark it complete.

## Test Verification Details

### Verification Script

**Command:**
```bash
bash Haunt/scripts/verify-tests.sh REQ-XXX <frontend|backend|infrastructure>
```

### Requirements by Type

**Frontend:**
- Both `npm test` AND `npx playwright test` MUST show 0 failures
- E2E tests MUST exist in correct location (tests/e2e/ or .haunt/tests/e2e/)
- E2E tests MUST cover user-facing behavior (not implementation details)

**Backend:**
- `npm test` (or `pytest tests/`) MUST show 0 failures
- Unit tests for all new functions/classes
- Integration tests for API endpoints

**Infrastructure:**
- Manual verification documented in completion notes
- Deployment scripts tested in staging
- Rollback procedures verified

### Evidence Required

- Paste verification script output in completion notes
- Output must show "✅ VERIFICATION PASSED" (or manual verification documented)
- **If verification fails:** STOP, FIX tests, re-run verification

### Workflow

1. Run verification script: `bash Haunt/scripts/verify-tests.sh REQ-XXX <type>`
2. If PASS: Paste output in completion notes, continue to next step
3. If FAIL: STOP, debug and fix failing tests, re-run verification
4. Repeat until verification passes

### Why This Matters

See Dev agent "Core Values" section:
- "If tests don't pass, code doesn't work - by definition"
- "'Tests written' ≠ 'Tests passing'"
- "Environment issues are problems to SOLVE, not excuses to SKIP"

**NO EXCEPTIONS. If verification script fails, work is NOT complete.**

### For UI Work (Additional Requirements)

- E2E tests MUST exist in correct location (tests/e2e/ or .haunt/tests/e2e/)
- E2E tests MUST cover user-facing behavior (not implementation details)
- **If E2E tests don't exist:** Requirement CANNOT be marked 🟢
- **If E2E tests failing:** Requirement CANNOT be marked 🟢
- Manual testing is NOT a substitute for automated E2E tests
