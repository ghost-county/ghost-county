---
name: gco-pattern-defeat
description: TDD framework for defeating recurring agent/code patterns. Use when identifying bad patterns in code, writing defeat tests, or establishing quality gates. Triggers on "pattern", "recurring issue", "keeps happening", "defeat test", "pre-commit", "anti-pattern", or when code review finds repeated problems.
---

# Pattern Defeat Framework

Permanently eliminate recurring problems through test-driven defeat.

## The Cycle

```
Find Pattern → Write Defeat Test → Add to Pre-commit → Update Agent Memory
     ↑                                                         ↓
     └─────────────────── Repeat ──────────────────────────────┘
```

## Error-to-Pattern Flow (SDK Integration)

When errors occur during agent execution, they should flow into pattern detection:

```
Error Occurs → Log Error Context → Analyze for Patterns → Create Defeat Test
```

### Capturing Errors for Pattern Analysis

1. **Tool Errors**: When a tool call fails, note the context
2. **Test Failures**: Recurring test failures indicate patterns
3. **User Corrections**: When user corrects agent behavior, that's a pattern signal
4. **Context Overflow**: Sessions hitting limits suggest context management patterns

### Error Template

```markdown
## Error: [Brief description]

**When:** [Timestamp]
**Agent:** [Which agent/subagent]
**Tool:** [Which tool failed, if applicable]
**Context:** [What was being attempted]

### Error Details
[Full error message or description]

### Pattern Signal?
- Is this recurring? [Yes/No]
- Similar to past errors? [Reference]
- Preventable by test? [Yes/No]

### Action
- [ ] One-off fix (no pattern)
- [ ] Create defeat test
- [ ] Update agent memory
- [ ] Update skill guidance
```

## Step 1: Identify the Pattern

### Where to Look

- **Git history**: Same files fixed repeatedly, similar commit messages ("fix...", "oops...")
- **Review comments**: Recurring feedback
- **Your frustration**: "Not this again"

### Pattern Template

```markdown
## Pattern: [Name]

**First noticed:** [Date]
**Frequency:** [Daily/Weekly/Per feature]
**Agents/Authors affected:** [Who]

### Description
[Specific, observable behavior]

### Examples
1. [File:line - what happened]
2. [File:line - what happened]

### Impact
- Severity: [High/Medium/Low]
- What breaks: [Consequences]
- Time cost: [Hours spent fixing]

### Root Cause
[Why does this happen?]
```

## Step 2: Write the Defeat Test

### Test Structure

```python
# .haunt/tests/patterns/test_[pattern_name].py
"""
Defeat: [Pattern name]
Found: [Date]
Impact: [What went wrong]
"""

import pytest

def test_no_[pattern_name]():
    """[One sentence explaining what this prevents]"""
    # Implementation that fails when pattern is present
    pass
```

### Common Defeat Tests

#### Silent Fallback (`.get(x, default)` hiding errors)

```python
import re
from pathlib import Path

PATTERN = r'\.get\([^,]+,\s*(0|None|\'\'|\"\"|\[\]|\{\})\)'

def test_no_silent_fallbacks():
    """Silent fallbacks hide validation errors."""
    violations = []
    for f in Path("src").rglob("*.py"):
        for i, line in enumerate(f.read_text().split("\n"), 1):
            if re.search(PATTERN, line):
                violations.append(f"{f}:{i}: {line.strip()}")
    assert not violations, f"Found:\n" + "\n".join(violations)
```

#### God Functions (>50 lines)

```python
import ast
from pathlib import Path

MAX_LINES = 50

def test_no_god_functions():
    """Functions over 50 lines are too complex."""
    violations = []
    for f in Path("src").rglob("*.py"):
        try:
            tree = ast.parse(f.read_text())
        except SyntaxError:
            continue
        for node in ast.walk(tree):
            if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
                length = node.end_lineno - node.lineno + 1
                if length > MAX_LINES:
                    violations.append(f"{f}:{node.name} = {length} lines")
    assert not violations, f"God functions:\n" + "\n".join(violations)
```

#### Bare Except

```python
import ast
from pathlib import Path

def test_no_bare_except():
    """Catch specific exceptions, not bare except."""
    violations = []
    for f in Path("src").rglob("*.py"):
        try:
            tree = ast.parse(f.read_text())
        except SyntaxError:
            continue
        for node in ast.walk(tree):
            if isinstance(node, ast.ExceptHandler) and node.type is None:
                violations.append(f"{f}:{node.lineno}")
    assert not violations, f"Bare except:\n" + "\n".join(violations)
```

## Step 3: Add to Pre-commit

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: pattern-detection
        name: Pattern Detection
        entry: pytest .haunt/tests/patterns/ -x -q
        language: system
        types: [python]
        pass_filenames: false
```

Install: `pre-commit install`

## Step 4: Record the Learning

### Agent Memory (Optional Enhancement)

If agent memory MCP server is available, record the defeat for future sessions:

```python
add_recent_learning("Defeated [pattern-name]: [key insight about the fix]")
```

**Example:**
```python
add_recent_learning("Silent fallback pattern defeated - always raise ValueError for missing required fields instead of returning None")
```

**Note:** This step is optional. If the MCP server is not running, the pattern defeat test itself serves as the primary learning mechanism through pre-commit enforcement.

### Documentation

Add pattern defeat to documentation:

```markdown
## [Pattern Name] Incident ([Date])

Using [bad pattern] caused [consequence]. Now enforced by
`test_[pattern_name]`. Always [correct approach] instead.
```

## Common Patterns Reference

| Pattern | Detection | Fix |
|---------|-----------|-----|
| Silent fallback | Regex `.get(x, default)` | Explicit validation |
| God function | AST line count | Split into focused functions |
| Magic numbers | Regex for literals | Named constants |
| Bare except | AST ExceptHandler | Specific exceptions |
| No assertions | AST test functions | Add meaningful asserts |
| Fabricated citations | URL verification | Verify sources exist |

## Common Agent Error Patterns

These patterns frequently emerge from agent workflows:

| Error Type | Pattern Signal | Defeat Strategy |
|------------|---------------|-----------------|
| Tool permission denied | Agent tried forbidden tool | Verify subagent_type matches task needs |
| File not found | Hardcoded paths, wrong directory | Use relative paths, verify pwd |
| Test failure cascade | One failure causes many | Isolate tests, fix root cause first |
| Context overflow | Session too long | Archive completed work, compact context |
| Missing dependency | Import/require fails | Add to setup prerequisites |
| API rate limit | Too many requests | Add backoff, batch requests |

### Agent-Specific Patterns

**Dev Agents:**
- Writing files without reading first (Edit tool requirement)
- Not running tests after changes
- Forgetting to commit or committing incomplete work

**Research Agents:**
- Can't write deliverables (missing Write tool)
- Citing sources that don't exist
- Not providing confidence levels

**Project Manager:**
- Creating oversized roadmap items (L/XL instead of S/M)
- Not archiving completed work
- Forgetting to update Active Work section

## Pattern Capture Automation (NEW)

Code Reviewer can now auto-generate skeleton defeat tests during code review.

### When Code Review Finds Recurring Anti-Pattern

If Code Reviewer identifies a recurring anti-pattern during review, they can offer to capture it:

**Code Reviewer prompt:**
```
This appears to be a recurring anti-pattern: "silent-fallback"

Using .get() with default values on required fields hides missing data.

Should I create a pattern defeat test to prevent this in the future? [yes/no]
```

**If user approves, Code Reviewer executes:**
```
/pattern capture "silent-fallback" "Using .get(key, default) on required fields hides missing data and causes silent failures"
```

**Result:**
Skeleton test generated in `.haunt/tests/patterns/test_prevent_silent_fallback.py`

### Automation Workflow

```
Code Review → Identifies Pattern → Offers Capture → User Approves → Skeleton Test Created
                                                                            ↓
                                                                    Dev Refines Test
                                                                            ↓
                                                                    Test Added to CI/CD
                                                                            ↓
                                                                    Pattern Defeated
```

### Two Paths to Pattern Detection

**Path 1: Manual Capture (Code Review)**
- **When:** During code review, at point of discovery
- **How:** Code Reviewer offers `/pattern capture` command
- **Output:** Single skeleton test for identified pattern
- **Speed:** Immediate (real-time)
- **Validation:** Human reviewer confirms it's a pattern

**Path 2: Automated Hunt (Weekly Ritual)**
- **When:** Monday morning refactor session
- **How:** `hunt-patterns` script scans git history
- **Output:** Batch of patterns with generated tests
- **Speed:** Scheduled (weekly)
- **Validation:** AI analyzes commit patterns

**Best Practice:** Use both paths
- Manual capture catches patterns during review (reactive)
- Weekly hunt finds emerging patterns across codebase (proactive)

### Skeleton Test Structure

Auto-generated skeleton includes:

```python
#!/usr/bin/env python3
"""
Pattern Defeat Test: [Pattern Name]

Pattern Name: [slug]
Description: [what it is and why it's bad]
Discovered: [YYYY-MM-DD]
Requirement: [REQ-XXX or "General"]
Agent: Code-Reviewer
Severity: [HIGH|MEDIUM|LOW]

Status: SKELETON - Needs implementation details

TODO:
1. Add specific regex pattern or AST detection logic
2. Define file scope (*.py, *.js, specific directories)
3. Add example violations from actual code
4. Test the test to verify it catches the pattern
5. Update status from SKELETON to ACTIVE
"""
# ... test implementation template ...
```

### Refinement Steps

After skeleton is generated, Dev agent should:

1. **Review detection logic** - Is regex/AST pattern accurate?
2. **Define scope** - Which files should be scanned?
3. **Add examples** - Include actual violations from code
4. **Test the test** - Run `pytest .haunt/tests/patterns/test_prevent_*.py`
5. **Adjust thresholds** - Fine-tune false positive rate
6. **Update status** - Change from SKELETON to ACTIVE
7. **Add to CI/CD** - Include in `.pre-commit-config.yaml`

### Integration Example

**Week 1: Pattern Captured**
```
Monday: Code review finds "silent fallback" pattern
        Code Reviewer offers pattern capture
        User approves
        Skeleton test created: test_prevent_silent_fallback.py
Tuesday: Dev refines test, adds to pre-commit
         Test status: SKELETON → ACTIVE
```

**Week 2: Pattern Hunt Validates**
```
Monday: Weekly pattern hunt runs
        Confirms "silent fallback" was recurring (3 occurrences last 7 days)
        No new instances found (pattern defeated)
        Test validated as effective
```

**Week 3: Continuous Prevention**
```
Dev commits code with .get(key, 0)
Pre-commit hook catches pattern
Commit rejected with helpful error
Dev fixes code before committing
Pattern defeated permanently
```

## Verification Checklist

After defeating a pattern:

- [ ] Test passing locally
- [ ] Test added to pre-commit
- [ ] Pattern hasn't recurred (7 days)
- [ ] Learning recorded
- [ ] Agent memory updated (if agent-specific pattern)
- [ ] **NEW:** If captured via Code Review, validate with weekly hunt
