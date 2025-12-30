# File Location Conventions (Slim Reference)

## Core Principle

**Ghost County artifacts go in `.haunt/`, project files stay in project directories.**

## Top 5 Artifact Locations

| Artifact | Location |
|----------|----------|
| Roadmap | `.haunt/plans/roadmap.md` |
| Completed work | `.haunt/completed/` |
| Progress notes | `.haunt/progress/` |
| Research docs | `.haunt/docs/research/` |
| Pattern tests | `.haunt/tests/patterns/` |

## When to Invoke Full Skill

For complete directory structure, file size limits, special cases, and all artifact types:

**Invoke:** `/gco-file-conventions` skill

The skill contains:
- Full artifact location table (10+ types)
- Prohibitions (what NOT to do)
- Project file vs Ghost County artifact distinction
- Haunt framework documentation structure
- File size limits and when to archive
- Directory tree reference

## Non-Negotiable

- NEVER create Ghost County artifacts outside `.haunt/`
- NEVER mix Ghost County artifacts with source code
- NEVER exceed 500 lines in `roadmap.md` (archive immediately)
