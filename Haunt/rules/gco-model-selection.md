# Model Selection Guidelines (Slim Reference)

## Core Principle

**High-leverage activities require high-capability models.**

## Model by Agent

| Agent | Model | Why |
|-------|-------|-----|
| Project Manager | Opus | Strategic analysis determines downstream work |
| Research-Analyst | Opus | Deep investigation and architecture |
| Research-Critic | Opus | Adversarial review requires thorough reasoning |
| Dev (all types) | Sonnet | Implementation is well-scoped |
| Code-Reviewer | Sonnet | Pattern detection and quality gates |
| Release-Manager | Sonnet | Coordination and risk assessment |

## Quick Decision

- **Opus:** Requirements analysis, strategic planning, deep research, architecture
- **Sonnet:** Code implementation, code review, release coordination
- **Haiku (Explore):** Fast read-only codebase reconnaissance

## When to Invoke Full Skill

For ROI analysis, task tool usage patterns, anti-patterns, and Explore agent guidance:

**Invoke:** `gco-model-selection` skill

## Non-Negotiable

- NEVER use Haiku for strategic analysis or implementation
- NEVER override agent model specs without valid reason
- When in doubt → Use Sonnet
