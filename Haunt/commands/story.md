# Story (Generate Context-Rich Story Files)

Create detailed story files for complex features to eliminate context loss across multi-session work. Story files provide full implementation context: background, approach, examples, edge cases, and testing strategy.

## Usage

```
/story create REQ-123     # Generate story file for specific requirement
```

## Arguments: $ARGUMENTS

### Restrictions

This command is **PM-only**. Dev agents cannot create stories, only consume them during implementation.

**Rationale:** Story files represent strategic implementation guidance. PM translates requirements into developer-ready context, ensuring consistent approach across sessions.

### Story File Generation

#### Process for `/story create REQ-123`

1. **Verify requirement exists**
   - Read `.haunt/plans/roadmap.md`
   - Find REQ-XXX requirement
   - If not found, report error: "REQ-XXX not found in roadmap"

2. **Create stories directory if missing**
   - Check if `.haunt/plans/stories/` exists
   - If not, create directory: `mkdir -p .haunt/plans/stories/`

3. **Extract requirement context**
   - Requirement title and description
   - Tasks list
   - Files to modify/create
   - Completion criteria
   - Agent assignment
   - Effort and complexity

4. **Generate story file**: `.haunt/plans/stories/REQ-XXX-story.md`

Use this template:

```markdown
# Story: REQ-XXX [Title]

> **Status:** [Status from roadmap]
> **Agent:** [Agent type]
> **Effort:** [XS/S/M]
> **Complexity:** [SIMPLE/MODERATE/COMPLEX]

---

## Context & Background

**Why this feature exists:**
[Explain the user need, business context, or problem being solved]

**Where it fits in the system:**
[Describe how this feature relates to existing architecture, what components it touches]

**User journey:**
[Describe the user's path through this feature - what they do, what they see, what they expect]

---

## Implementation Approach

**Technical strategy:**
[High-level implementation approach - frameworks, patterns, architectural decisions]

**Component breakdown:**
- [Component 1]: [Purpose and responsibilities]
- [Component 2]: [Purpose and responsibilities]

**Data flow:**
[Describe how data moves through the system for this feature]

**Integration points:**
[List APIs, services, or modules this feature integrates with]

---

## Code Examples & References

**Similar patterns in codebase:**
[Point to existing code that follows similar patterns or can serve as reference]

**Key code snippets:**
```[language]
// Example showing critical implementation pattern
```

**Libraries/dependencies:**
[List key libraries or dependencies required, with version constraints if relevant]

---

## Known Edge Cases

**Scenario 1: [Edge case description]**
- **What:** [Describe the edge case]
- **Why it matters:** [Impact if not handled]
- **How to handle:** [Implementation approach]

**Scenario 2: [Another edge case]**
- **What:** [Description]
- **Why it matters:** [Impact]
- **How to handle:** [Approach]

**Error conditions:**
- [Error type 1]: [How to handle]
- [Error type 2]: [How to handle]

---

## Testing Strategy

**Unit tests:**
[What to test at unit level, key test cases]

**Integration tests:**
[What to test at integration level, key scenarios]

**E2E tests (if UI feature):**
[User flows to test end-to-end]

**Test data requirements:**
[What test data or fixtures are needed]

**Coverage expectations:**
- Target: [X%] coverage on new code
- Critical paths: [List must-test scenarios]

---

## Research Findings (if applicable)

**Technology choices:**
[If research phase occurred, summarize key decisions and why]

**Alternatives considered:**
[What approaches were evaluated and rejected, and why]

**Open questions:**
[Any remaining unknowns or decisions deferred to implementation]

---

## Completion Criteria (from roadmap)

[Copy the "Completion:" field from roadmap requirement]

**Task checklist:**
[Copy all tasks from roadmap requirement]

---

## Session Notes

**Implementation progress:**
[Space for Dev agent to add session notes as work progresses]

**Gotchas discovered:**
[Space for recording unexpected issues or learnings]

**Next session starting point:**
[Space for leaving notes about where to resume if work spans multiple sessions]
```

5. **Report success**
   - Confirm story file created
   - Show file path
   - Remind PM to fill in context sections

### Story File Workflow

**PM Responsibilities:**
1. Run `/story create REQ-XXX` to generate template
2. Fill in all sections with full context:
   - Background and user needs
   - Technical approach and architecture
   - Code examples from similar patterns
   - Edge cases and error scenarios
   - Testing expectations
   - Research findings if applicable
3. Save story file before Dev agent starts work

**Dev Agent Responsibilities:**
1. Read story file during session startup if it exists
2. Use story context to guide implementation
3. Add session notes as work progresses
4. Update "Session Notes" section with progress and gotchas
5. Story file supplements roadmap (does not replace it)

### When to Create Story Files

Story files are recommended for:

- **M-sized requirements** - Multi-session work benefits from persistent context
- **Complex features** - High complexity (COMPLEX rating) needs detailed guidance
- **Multi-component features** - Features touching 4+ files or subsystems
- **Features with research phase** - Preserve research findings and architectural decisions
- **Handoff scenarios** - Dev picks up work from Research or another Dev

**Skip story files for:**
- **XS-S requirements** - Single-session work with clear roadmap completion criteria
- **Simple bug fixes** - Well-defined issues with obvious fixes
- **Straightforward features** - SIMPLE complexity with minimal edge cases

### Error Handling

- **REQ not found**: Report "REQ-XXX not found in roadmap. Verify requirement number."
- **Story already exists**: Report "Story file exists at .haunt/plans/stories/REQ-XXX-story.md. Overwrite? (yes/no)"
- **Directory creation fails**: Report "Failed to create .haunt/plans/stories/ directory: [error]"
- **File write fails**: Report "Failed to create story file: [error]"

### Ghost County Flavor

When reporting success, use themed language:
- "Story woven for REQ-XXX. The tale awaits its hero."
- "Context preserved. The Dev agent will find the path clearly marked."

## Story File Lifecycle

Story files follow the requirement lifecycle:

### Creation (REQ is ⚪ or 🟡)
- PM creates story via `/story create REQ-XXX`
- Stored in `.haunt/plans/stories/REQ-XXX-story.md`
- Dev agents load automatically during session startup

### Active Use (REQ is 🟡)
- Dev agents reference story for implementation context
- PM can update story as new information emerges
- Story evolves with multi-session work

### Completion (REQ marked 🟢)
- **Manual archival:** `mv .haunt/plans/stories/REQ-XXX-story.md .haunt/completed/stories/`
- **Automatic archival:** When PM archives batch via `/roadmap archive`, story files move automatically
- Archived stories preserve implementation context for reference

### Why Archive (Not Delete)
- Preserves decision rationale for future features
- Helps with similar implementations later
- Useful for post-mortems and team retrospectives
- Documents approach for onboarding new team members

## Cleanup Workflow

**When completing individual requirement:**
```bash
# Mark requirement complete in roadmap
# Then move story file manually
mv .haunt/plans/stories/REQ-XXX-story.md .haunt/completed/stories/
```

**When archiving batch:**
```bash
# Use batch archive command (handles story files automatically)
/roadmap archive "Batch 1: Foundation"
# Moves all story files for requirements in batch
```

**Cleanup directory created:**
```bash
mkdir -p .haunt/completed/stories
```
