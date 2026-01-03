# Session Startup: Advanced Scenarios

This reference contains detailed guidance for complex session startup scenarios beyond the quick resolution guide.

## Sharded Roadmap Loading

**When roadmap is sharded:** Token-efficient mode for large projects (10+ requirements).

### How Sharding Works

- Main `roadmap.md` contains: overview + active batch requirements only
- Other batches stored in: `.haunt/plans/batches/batch-N-[name].md`
- Achieves 60-80% token reduction by loading only relevant batch

### Detection

- Check if `.haunt/plans/batches/` directory exists
- Check for "Sharding Info" section in `roadmap.md`
- Check for "Other Batches" heading in `roadmap.md`

### Workflow for Active Batch (Normal Case)

1. Read `roadmap.md` (contains active batch already)
2. Find assignment in active batch
3. Proceed with work - no additional loading needed

### Workflow for Different Batch (Edge Case)

**Scenario:** Sharded roadmap shows assignment in different batch than active batch.

1. Assignment found in "Other Batches" section
2. Note batch file path from overview
3. Read `.haunt/plans/batches/batch-N-[name].md`
4. Extract full requirement details from batch file
5. Proceed with work using batch file context

**Example:**
```bash
# Scenario: Assigned REQ-105, but active batch is "Setup Improvements"
# REQ-105 is in "Command Improvements" batch

# 1. Check roadmap.md "Other Batches" section
cat .haunt/plans/roadmap.md
# Shows: "Batch: Command Improvements - File: batches/batch-1-command-improvements.md"

# 2. Load specific batch file
cat .haunt/plans/batches/batch-1-command-improvements.md

# 3. Find REQ-105 full details
# 4. Proceed with implementation
```

### Token Savings

- Sharded: Load 500-1000 tokens (overview + active batch)
- Monolithic: Load 3000-5000 tokens (entire roadmap)
- Savings: 60-80% reduction

### Backward Compatibility

- If roadmap not sharded, use normal workflow (load full `roadmap.md`)
- No changes needed to agent behavior

## Story File Loading

**When to check:** After assignment identification, before starting work.

### Workflow

1. Extract REQ-XXX from assignment (e.g., "Implement REQ-224" → REQ-224)
2. Check if `.haunt/plans/stories/REQ-XXX-story.md` exists
3. If story file exists:
   - Read entire story file for implementation context
   - Pay special attention to:
     - **Implementation Approach**: Technical strategy and component breakdown
     - **Code Examples & References**: Similar patterns in codebase
     - **Known Edge Cases**: Scenarios to handle and error conditions
     - **Session Notes**: Progress from previous sessions, gotchas discovered
4. If no story file:
   - Normal for XS-S sized work
   - Proceed with roadmap completion criteria and task list

### Story Files vs Roadmap

**Story files supplement (not replace) roadmap:**
- Roadmap has: title, tasks, completion criteria, file list
- Story file adds: technical context, approach details, code examples, edge cases
- Both are needed for complete understanding

### When Story Files Are Most Helpful

- M-sized requirements spanning multiple sessions
- Complex features with architectural decisions
- Multi-component changes requiring coordination
- Work resumed after context compaction or long gap
- Features with known gotchas from previous attempts

### Example Workflow

```bash
# Assignment: Implement REQ-224
# 1. Check for story file
ls .haunt/plans/stories/REQ-224-story.md

# 2. If exists, read it
cat .haunt/plans/stories/REQ-224-story.md

# 3. Use story context + roadmap to start work
# Story tells you HOW to implement
# Roadmap tells you WHAT to implement
```

## Codebase Reconnaissance with Explore

**When to use built-in Explore agent:** Fast, read-only codebase orientation before starting implementation work.

### Explore Decision Gate

Before starting implementation, ask:

**"Do I need to understand existing code patterns or project structure first?"**

| Situation | Action |
|-----------|--------|
| **Refactoring existing code** | Use Explore to scan current implementation |
| **Integrating with existing features** | Use Explore to find integration points |
| **Unfamiliar codebase area** | Use Explore for quick orientation |
| **New feature, clear requirements** | Skip Explore, proceed with implementation |
| **Simple bug fix with known location** | Skip Explore, proceed with fix |

### Reconnaissance Workflow

**When reconnaissance is needed:**

```bash
# Session startup sequence
1. Assignment identified: REQ-XXX
2. Requirement indicates existing code modification
3. Use Explore for quick recon (read-only)
4. Explore returns: file locations, patterns, integration points
5. Proceed with implementation using Explore findings
```

**Example: Refactoring existing authentication:**

```
Assignment: REQ-042 - Refactor authentication to use JWT

Session startup:
1. Assignment identified from roadmap
2. Requirement involves refactoring existing code
3. Use Explore:
   - "Find all authentication-related code"
   - Returns: 8 files in src/auth/, middleware/, routes/
   - Identifies: Session-based auth currently in use
4. Proceed with JWT implementation informed by Explore findings
```

### When NOT to Use Explore

**Skip Explore for:**
- New features with no existing code dependencies
- Bug fixes in known file locations
- Documentation-only changes
- Configuration updates
- Tests for new functionality

### Explore vs gco-research

| Situation | Use |
|-----------|-----|
| Quick codebase scan (<1 min) | Explore (built-in) |
| File structure discovery | Explore (built-in) |
| Git history review | Explore (built-in) |
| Deep API/library research | gco-research (Haunt) |
| External documentation lookup | gco-research (Haunt) |
| Architecture recommendations | gco-research (Haunt) |

**Key Distinction:**
- **Explore:** Read-only codebase reconnaissance (Haiku, fast, ~516 tokens)
- **gco-research:** Deep investigation with deliverables (Opus, thorough, can write reports)

**See:** `Haunt/docs/INTEGRATION-PATTERNS.md` - Built-in Subagents Reference section for detailed Explore usage patterns.

## Agent Memory Best Practices

### When to Recall Context

Use `recall_context("[agent-type]")` when:

**Multi-session work:**
- Resuming M-sized requirements that span multiple sessions
- Continuing features started in previous sessions (>24 hour gap)
- Work with complex implementation history requiring prior context

**Complex debugging:**
- Debugging issues that span multiple investigation sessions
- Troubleshooting problems requiring knowledge of previous failed attempts
- Root cause analysis that builds on prior research findings

**Cross-agent handoffs:**
- Receiving work from another agent type (e.g., Dev receives from Research)
- Coordinating features requiring multiple agent specializations
- Understanding context from previous agent's decisions or discoveries

**Example workflow:**
```bash
# At session startup, after verifying assignment
recall_context("dev-backend")

# Review recalled context for:
# - Previous implementation decisions
# - Known blockers or gotchas
# - Partial work from last session
# - Cross-references to related requirements

# Proceed with work using historical context
```

### When to Skip Memory

Do NOT use `recall_context()` when:

**Simple, self-contained work:**
- S-sized tasks completable in single session
- Straightforward bug fixes with clear root cause
- New features with no dependency on prior sessions

**Clear requirements:**
- All context needed is documented in roadmap
- Acceptance criteria and tasks are self-explanatory
- No ambiguity about implementation approach

**Fresh starts:**
- Starting new feature with no prior attempts
- Clean-slate work with no historical context
- Requirements explicitly state "ignore previous approaches"

### Storage Pattern

After significant progress or insights:
```bash
store_memory(
  content="[Key decisions, gotchas, next steps]",
  category="dev-[backend|frontend|infra]",
  tags=["session", "REQ-XXX", "feature-name"]
)
```

## Lessons-Learned Integration

For complex (M-sized) work, check the lessons-learned database for relevant project knowledge before implementation.

### When to Check Lessons-Learned

Use `.haunt/docs/lessons-learned.md` when:

**M-sized requirements:**
- Features spanning multiple sessions (2-4 hours)
- Complex features with architectural decisions
- Multi-component changes requiring coordination
- Features touching previously problematic areas

**After encountering blockers:**
- Debugging issues that seem familiar
- Architectural questions about existing patterns
- Uncertainty about project conventions or gotchas

**Before code review:**
- Verify work against documented anti-patterns
- Ensure architectural decisions align with project rationale
- Check best practices for similar work

### What to Look For

**Common Mistakes:** Has this error been made before? What's the solution?

**Anti-Patterns:** Are there code patterns to avoid? (Silent fallbacks, magic numbers, etc.)

**Architecture Decisions:** Why did the project choose approach X over Y?

**Project Gotchas:** Are there Ghost County-specific quirks to be aware of?

**Best Practices:** What patterns work consistently well for this project?

### Workflow

```bash
# During session startup (after assignment identification):
# 1. Read assignment from roadmap
# 2. If M-sized or complex feature:
#    - Read .haunt/docs/lessons-learned.md
#    - Skim relevant sections (check table of contents)
#    - Note applicable lessons for current work
# 3. Proceed with implementation, applying documented guidance
```

**Example:**
```
Assignment: REQ-XXX - Implement roadmap sharding feature (M-sized)

Session startup:
1. Assignment identified: REQ-XXX (M-sized, 4-6 hours)
2. Check lessons-learned.md:
   - "Framework Changes: Always Update Source First" → Reminder to edit Haunt/ first
   - "Roadmap Sharding" architecture decision → Understand existing rationale
   - "Session Startup Optimization" → Related work for context
3. Implement with lessons in mind (avoid documented mistakes)
```

### Integration with Story Files

**Story files** (`.haunt/plans/stories/REQ-XXX-story.md`) provide implementation-specific context for individual requirements.

**Lessons-learned** provides project-wide knowledge across all requirements.

**Use both when:**
- Story file exists for current REQ-XXX → Load for feature-specific context
- Lessons-learned → Skim for general project patterns/gotchas
- Combined context reduces mistakes and improves implementation quality
