---
name: pattern
description: Capture anti-patterns discovered during code review and generate defeat tests. For Code Reviewer agent use.
---

# /pattern - Pattern Capture Automation

**Purpose:** When Code Reviewer discovers anti-patterns, auto-generate skeleton pattern defeat tests to create systematic feedback loop: Mistake → Test → Prevention.

## Usage

```
/pattern capture "pattern-name" "Pattern Description"
```

**Who:** Code-Reviewer agent only (restricted command)

**When:** During code review when rejecting code due to anti-pattern

**Output:** Skeleton test file in `.haunt/tests/patterns/test_prevent_[pattern-name].py`

## Arguments

- **pattern-name** (required) - Slug identifier (e.g., "silent-fallback", "god-function", "hardcoded-secrets")
- **Pattern Description** (required) - Brief explanation of what went wrong

## Workflow

### Step 1: Code Reviewer Identifies Anti-Pattern

During code review, when rejecting code:

```markdown
CHANGES_REQUESTED

Issues found:
[HIGH] auth.py:47 - Silent fallback: .get('user_id', 0) hides missing required data
```

### Step 2: Code Reviewer Offers Pattern Capture

After identifying anti-pattern, Code Reviewer prompts:

```
This appears to be a recurring anti-pattern: "silent-fallback"

Should I create a pattern defeat test to prevent this in the future? [yes/no]
```

### Step 3: Generate Skeleton Test (If Approved)

Code Reviewer invokes:
```
/pattern capture "silent-fallback" "Using .get(key, default) on required fields hides missing data and causes silent failures"
```

### Step 4: Test File Created

Command generates `.haunt/tests/patterns/test_prevent_silent_fallback.py`:

```python
#!/usr/bin/env python3
"""
Pattern Defeat Test: Silent Fallback Anti-Pattern

Pattern Name: silent-fallback
Description: Using .get(key, default) on required fields hides missing data and causes silent failures
Discovered: 2025-12-18
Requirement: REQ-237 (if applicable)
Agent: Code-Reviewer
Severity: HIGH

Status: SKELETON - Needs implementation details

TODO:
1. Add specific regex pattern or AST detection logic
2. Define file scope (*.py, *.js, specific directories)
3. Add example violations from actual code
4. Test the test to verify it catches the pattern
5. Update status from SKELETON to ACTIVE
"""

import re
from pathlib import Path


def test_prevent_silent_fallback():
    """
    Detect silent fallback pattern in codebase.

    Anti-Pattern: Using .get(key, default) on required fields
    Impact: Hides missing data and causes silent failures

    Example WRONG:
    user_id = data.get('user_id', 0)  # 0 is not a valid user_id

    Example RIGHT:
    if 'user_id' not in data:
        raise ValueError("user_id is required")
    user_id = data['user_id']
    """
    project_root = Path(__file__).parent.parent.parent
    violations = []

    # TODO: Define which files to scan (adjust as needed)
    target_files = project_root.rglob("*.py")

    # TODO: Define the detection pattern (adjust regex or use AST)
    pattern = r'\.get\([^,]+,\s*(0|None|\'\'|""|\\[\\]|\\{\\})\)'

    for file_path in target_files:
        # Skip test files
        if 'test_' in file_path.name or 'tests/' in str(file_path):
            continue

        try:
            content = file_path.read_text()
            lines = content.split('\n')

            for line_num, line in enumerate(lines, 1):
                if re.search(pattern, line):
                    # TODO: Add context analysis (is this actually problematic?)
                    violations.append({
                        'file': str(file_path.relative_to(project_root)),
                        'line': line_num,
                        'content': line.strip()
                    })
        except Exception:
            # Skip unreadable files
            continue

    # TODO: Adjust assertion message for clarity
    if violations:
        error_msg = "Silent fallback anti-pattern detected:\n"
        for v in violations[:10]:  # Limit output
            error_msg += f"  {v['file']}:{v['line']} - {v['content']}\n"
        error_msg += "\nFix: Validate required fields explicitly before use."
        assert False, error_msg


if __name__ == "__main__":
    # Allow running test standalone for verification
    print("Running pattern defeat test: silent-fallback\n")
    try:
        test_prevent_silent_fallback()
        print("✓ No violations detected")
    except AssertionError as e:
        print(f"✗ Pattern detected:\n{e}")
```

## Implementation Details

### Filename Convention

```
test_prevent_[pattern-name-slug].py
```

Examples:
- `test_prevent_silent_fallback.py`
- `test_prevent_god_function.py`
- `test_prevent_hardcoded_secrets.py`
- `test_prevent_magic_numbers.py`

### Test Metadata (Required Fields)

Every generated test MUST include:

```python
"""
Pattern Name: [slug identifier]
Description: [what the pattern is and why it's problematic]
Discovered: [YYYY-MM-DD]
Requirement: [REQ-XXX where pattern was found, or "General"]
Agent: [Code-Reviewer]
Severity: [HIGH|MEDIUM|LOW]
Status: SKELETON - Needs implementation details
"""
```

### Skeleton Test Structure

Generated tests follow this template:

1. **Metadata docstring** - Pattern info and discovery context
2. **TODO checklist** - Steps to complete the test
3. **Test function** - Basic structure with placeholders
4. **Detection logic** - Regex or AST pattern (needs refinement)
5. **File scanning** - Rglob pattern (needs scoping)
6. **Assertion** - Failure message (needs context)

### Status Progression

- **SKELETON** - Auto-generated, needs human refinement
- **ACTIVE** - Refined and enforced in CI/CD
- **RETIRED** - Pattern no longer applicable

## Code Reviewer Workflow

### When to Offer Pattern Capture

Offer pattern capture when:
1. **Rejecting code** with CHANGES_REQUESTED or BLOCKED verdict
2. **Pattern is recurring** (seen in 2+ reviews or historical commits)
3. **Pattern is preventable** via static analysis
4. **Impact is medium-high** (not minor style issues)

### When NOT to Offer

Skip pattern capture for:
1. **One-off mistakes** (typos, simple logic errors)
2. **Style preferences** (tabs vs spaces, naming conventions)
3. **Complex patterns** that need runtime analysis
4. **Context-dependent issues** that can't be detected statically

### Pattern Capture Prompt Template

After identifying recurring anti-pattern in review:

```
This appears to be a recurring anti-pattern: "[pattern-name]"

[Brief explanation of why it's problematic]

Should I create a pattern defeat test to prevent this in the future? [yes/no]

If yes, I'll generate a skeleton test in .haunt/tests/patterns/ that you can refine.
```

### Example Interaction

**Code Reviewer finds issue:**
```
[HIGH] payment.py:89 - God function: process_payment() is 247 lines, handles validation,
processing, notifications, and logging. Split into focused functions.
```

**Code Reviewer offers capture:**
```
This appears to be a recurring anti-pattern: "god-function"

Functions over 100 lines with multiple responsibilities are hard to test, debug, and maintain.

Should I create a pattern defeat test to prevent this in the future? [yes/no]
```

**User responds: yes**

**Code Reviewer executes:**
```
/pattern capture "god-function" "Functions over 100 lines with multiple responsibilities violate Single Responsibility Principle"
```

**Result:**
```
✓ Pattern defeat test created: .haunt/tests/patterns/test_prevent_god_function.py

Next steps:
1. Review and refine the detection logic in the test
2. Run: pytest .haunt/tests/patterns/test_prevent_god_function.py
3. Adjust thresholds and scope as needed
4. Update status from SKELETON to ACTIVE
5. Add to CI/CD pipeline
```

## Integration with Existing Pattern Detection

This command **complements** the weekly pattern detection ritual:

### Weekly Pattern Hunt (Automated)
- Scans git history for recurring issues
- Uses AI to identify patterns from commits
- Generates tests in batch
- **Proactive** - finds patterns before they spread

### Manual Pattern Capture (This Command)
- Code Reviewer identifies pattern during review
- Captures pattern immediately at point of discovery
- Generates skeleton test on-demand
- **Reactive** - prevents recurrence of known issues

### Combined Workflow

```
Week 1:
  - Code Review finds "silent fallback" pattern
  - /pattern capture creates skeleton test
  - Dev refines test, adds to CI/CD

Week 2:
  - Weekly pattern hunt confirms pattern is defeated
  - No new instances in git history
  - Pattern marked ACTIVE (working as intended)

Week 3:
  - Pattern hunt identifies 2 new patterns
  - Auto-generates batch tests
  - Review and activate
```

## Implementation Notes

### Ghost County Theming

Pattern capture uses Ghost County thematic language:

```
The Code Reviewer has captured a wandering spirit (anti-pattern).
A binding ward (defeat test) has been prepared.

Pattern: silent-fallback
Location: .haunt/tests/patterns/test_prevent_silent_fallback.py
Status: SKELETON - Awaiting refinement

The ward must be strengthened before it can protect the realm.
```

### File Organization

All pattern defeat tests go in:
```
.haunt/tests/patterns/
├── README.md                          # Pattern detection methodology
├── test_prevent_silent_fallback.py    # Captured patterns
├── test_prevent_god_function.py
├── test_prevent_hardcoded_secrets.py  # Weekly hunt patterns
└── test_pattern_*.py                  # Framework self-tests
```

### Command Permissions

**Restricted to Code-Reviewer agent:**
- Only Code Reviewer can invoke `/pattern capture`
- PM, Dev, Research agents cannot use this command
- Prevents over-capture of non-patterns

### Metadata Tracking

Each captured pattern includes:
- **Discovery date** - When pattern was first identified
- **Source requirement** - Which REQ-XXX triggered the capture
- **Severity** - Impact assessment (HIGH/MEDIUM/LOW)
- **Agent** - Always "Code-Reviewer" for manual captures

## Testing the Command

### Verify Pattern Capture

```bash
# 1. Manually invoke command (as Code Reviewer)
/pattern capture "test-pattern" "This is a test pattern for verification"

# 2. Check file was created
ls -la .haunt/tests/patterns/test_prevent_test_pattern.py

# 3. Verify test structure
cat .haunt/tests/patterns/test_prevent_test_pattern.py

# 4. Run the skeleton test (should pass or fail based on detection)
pytest .haunt/tests/patterns/test_prevent_test_pattern.py -v
```

### End-to-End Workflow Test

1. **Code Reviewer identifies anti-pattern in review**
2. **Code Reviewer offers pattern capture to user**
3. **User approves capture**
4. **Code Reviewer invokes /pattern capture**
5. **Skeleton test file created in .haunt/tests/patterns/**
6. **Code Reviewer reports success to user**
7. **Dev agent refines test in follow-up session**
8. **Test added to CI/CD pipeline**

## Success Criteria

Pattern capture automation is working when:

✓ Code Reviewer offers capture when rejecting code with anti-patterns
✓ `/pattern capture` command generates valid skeleton test
✓ Test file includes all required metadata fields
✓ Test follows established pattern defeat structure
✓ Test is runnable (passes or fails based on detection logic)
✓ Skeleton includes TODO checklist for refinement
✓ Integration with weekly pattern hunt is clear

## See Also

- **Haunt/docs/PATTERN-DETECTION.md** - Pattern detection methodology and weekly ritual
- **Haunt/skills/gco-code-patterns/SKILL.md** - Anti-pattern reference guide
- **Haunt/agents/gco-code-reviewer.md** - Code review workflow
- **.haunt/tests/patterns/README.md** - Pattern test documentation
