# Model Selection Guidelines (Slim Reference)

## Core Principle

**High-leverage activities require high-capability models.** The cost difference is negligible compared to wasted time from poor decisions.

## Model Assignments

| Agent | Model | Rationale |
|-------|-------|-----------|
| **Project Manager** | Opus | Strategic analysis (JTBD, Kano, RICE) determines all downstream work |
| **Research-Analyst** | Opus | Deep investigation and architecture recommendations require highest reasoning |
| **Research-Critic** | Opus | Adversarial review requires thorough analysis and critical reasoning |
| **Dev (all types)** | Sonnet | Implementation is well-scoped, Sonnet sufficient for TDD and patterns |
| **Code-Reviewer** | Sonnet | Pattern detection and quality gates, not strategic decisions |
| **Release-Manager** | Sonnet | Coordination and risk assessment, not deep strategic reasoning |

## Quick Decision Tree

**Use Opus (planning/research):** Requirements analysis, strategic planning, deep research, architecture recommendations, adversarial review

**Use Sonnet (implementation):** Code implementation, code review, release coordination, pattern detection

**Use Haiku (built-in Explore):** Fast codebase reconnaissance ONLY (read-only file searches, git history, pattern discovery)

## Built-in Explore Agent (Haiku)

**When to use built-in Explore instead of spawning agents:**

| Task | Use | Rationale |
|------|-----|-----------|
| Quick file structure scan | Explore (Haiku) | Read-only, fast, 516 tokens |
| Git history review | Explore (Haiku) | No modification needed |
| Pattern discovery | Explore (Haiku) | Read-only codebase search |
| Deep investigation (>10 files) | gco-research (Opus) | Deliverable production needed |
| External docs research | gco-research (Opus) | WebSearch/WebFetch required |
| Implementation | gco-dev (Sonnet) | Write access required |

**Explore Limitations:**
- **Read-only:** No Edit/Write tools
- **No external access:** No WebSearch or WebFetch
- **No deliverables:** Cannot create analysis documents
- **Codebase only:** Limited to local files and git

**Best Use Case:**
Reconnaissance before spawning specialist agents. Explore gathers context (file locations, patterns, integration points), then orchestrator spawns appropriate specialist with findings as context.

## When to Invoke Full Skill

For detailed ROI analysis, task tool usage patterns, anti-patterns, and monitoring guidance:

**Invoke:** `/gco-model-selection` skill

The skill contains:
- When to use each model (Opus/Sonnet/Haiku)
- ROI analysis examples
- Task tool usage with model specifications
- Anti-patterns to avoid
- Guidelines for model override
- Cost monitoring strategies

## Non-Negotiable

- NEVER use Haiku for strategic analysis or research
- NEVER use Haiku for implementation (bugs, technical debt result)
- NEVER override agent model specs without valid reason
- When in doubt → Use Sonnet (cost of being wrong >> model cost difference)
