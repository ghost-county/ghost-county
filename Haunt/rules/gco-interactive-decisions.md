# Interactive Decision Protocol

This rule enforces proactive use of the AskUserQuestion tool when agents encounter decision points, ambiguity, or architectural choices during work.

## Core Principle

**Ask, don't assume.** When multiple valid paths exist or requirements are unclear, surface the decision to the user rather than making assumptions that may waste implementation time.

## When to Use AskUserQuestion

### REQUIRED: Always Ask When

#### 1. Ambiguous Requirements
User request can be interpreted in multiple ways:

**Examples:**
- "Add authentication" → OAuth? JWT? Session-based? Magic links?
- "Make it faster" → Optimize backend? Frontend? Database? Which specific operations?
- "Add dark mode" → Full theme system? CSS variables? User preference storage where?
- "Fix the bug in login" → Which bug? What's the expected behavior?

**Pattern:**
```
IF (user_request has multiple valid interpretations) THEN
  AskUserQuestion(interpretations_with_tradeoffs)
```

#### 2. Architecture Choices
Technical decisions that affect system design:

**Examples:**
- Framework selection: React vs Vue vs Svelte
- State management: Redux vs Context vs Zustand vs Jotai
- Database choice: PostgreSQL vs MongoDB vs SQLite
- API design: REST vs GraphQL vs tRPC
- Deployment: Vercel vs Railway vs self-hosted
- Authentication: NextAuth vs Clerk vs Supabase Auth vs custom

**Pattern:**
```
IF (architecture_choice affects >3 files OR is hard to reverse) THEN
  AskUserQuestion(options_with_pros_cons)
```

### RECOMMENDED: Ask When Helpful

#### 3. Trade-off Decisions
When options have meaningful pros/cons:

**Examples:**
- Speed vs features: MVP quick vs full-featured?
- Simplicity vs flexibility: Opinionated framework vs maximum customization?
- Cost vs convenience: Self-host vs managed service?

**Pattern:**
```
IF (trade_offs are non-obvious) THEN
  AskUserQuestion(explain_implications)
```

#### 4. Scope Clarification
When work could expand significantly:

**Examples:**
- "Add tests" → Unit only? Integration? E2E? All of the above?
- "Refactor auth" → Just clean up code? Or redesign architecture?
- "Update docs" → README only? Full documentation site? API docs?

**Pattern:**
```
IF (scope_has_wide_range) THEN
  AskUserQuestion(scope_options)
```

### DON'T Ask When

#### Clear Requirements
If the user has already specified the approach:
- "Use React with TypeScript" → Don't ask about Vue
- "Add a login button to the navbar" → Don't ask where to put it  
- "Fix the TypeError on line 42" → Don't ask which error to fix

#### Obvious Best Practice
When there's a clear industry standard:
- "Add error handling" → Use try/catch, don't ask permission
- "Make it responsive" → Use CSS media queries, standard approach
- "Add type safety" → Use TypeScript types, obvious choice

#### Already In Progress
If you're mid-implementation and pattern is established:
- Don't ask about every file in a multi-file refactor if pattern is clear
- Don't ask about every similar function if first one was approved

## Tool Usage Pattern

### Basic Question Format

\`\`\`
AskUserQuestion({
  "questions": [{
    "question": "How should we implement authentication?",
    "header": "Auth Strategy",
    "multiSelect": false,
    "options": [
      {
        "label": "NextAuth.js (Recommended)",
        "description": "Full-featured auth library with OAuth, email, credentials. Easy setup, well-maintained."
      },
      {
        "label": "Clerk",  
        "description": "Managed auth service. Beautiful UI, faster setup, but adds external dependency and cost ($25/mo after free tier)."
      },
      {
        "label": "Supabase Auth",
        "description": "If already using Supabase for database. Integrated solution, row-level security."
      },
      {
        "label": "Custom JWT implementation",
        "description": "Full control, no dependencies. More work to build and secure properly."
      }
    ]
  }]
})
\`\`\`

**When user answers:** Continue with their selected approach immediately.

### Multi-Question Format

When multiple related decisions need to be made:

\`\`\`
AskUserQuestion({
  "questions": [
    {
      "question": "Which database should we use?",
      "header": "Database",
      "multiSelect": false,
      "options": [...]
    },
    {
      "question": "Where should we deploy?",
      "header": "Deployment",
      "multiSelect": false,
      "options": [...]
    }
  ]
})
\`\`\`

**Limit:** Maximum 4 questions per AskUserQuestion call. If more decisions needed, ask in batches.

### MultiSelect for Feature Choices

When user might want multiple options:

\`\`\`
AskUserQuestion({
  "questions": [{
    "question": "Which ADHD features should we prioritize for MVP?",
    "header": "MVP Features",
    "multiSelect": true,
    "options": [
      {"label": "Quick capture (<2 sec)", "description": "..."},
      {"label": "AI priority suggestions", "description": "..."},
      {"label": "Task breakdown", "description": "..."},
      {"label": "Gamification", "description": "..."}
    ]
  }]
})
\`\`\`

## Agent-Specific Guidance

### Project Manager
**Always ask when:**
- Prioritizing requirements (which REQ-XXX to work on first?)
- Breaking down SPLIT-sized work (where to split?)
- Analyzing with multiple frameworks (which analysis: JTBD, Kano, RICE?)

### Dev Agents (Backend/Frontend/Infrastructure)
**Always ask when:**
- Choosing frameworks or libraries
- Deciding API design patterns
- Selecting state management approach
- Architecture that affects >3 files

### Research Analyst
**Always ask when:**
- Research scope is ambiguous (how deep? which aspects?)
- Multiple research directions possible
- Deliverable format unclear (report? comparison? recommendations?)

### Code Reviewer
**Usually don't ask** - quality gates are objective. Ask only if:
- Review finds architectural concerns requiring user decision
- Multiple refactoring approaches possible

## Examples

### Good: Ambiguous Requirements

**User:** "Add a dashboard to the app"

**Agent response:**
\`\`\`
I need to clarify what type of dashboard you want:

[Uses AskUserQuestion]
- Admin dashboard (user management, analytics, system health)?
- User dashboard (personal stats, recent activity, quick actions)?
- Analytics dashboard (charts, graphs, data visualization)?
- Landing page dashboard (marketing content, features, CTAs)?

Each has different data requirements, design patterns, and complexity.
\`\`\`

### Good: Architecture Choice

**User:** "Add real-time updates to the task list"

**Agent response:**
\`\`\`
For real-time updates, there are several technical approaches:

[Uses AskUserQuestion]
- WebSockets (best for true real-time, but requires WebSocket server infrastructure)
- Server-Sent Events (simpler, one-way from server, good for notifications)
- Polling (simplest, check for updates every N seconds, more server load)
- Supabase Realtime (if using Supabase, built-in real-time subscriptions)

The choice affects infrastructure, cost, and implementation complexity.
\`\`\`

### Bad: Over-Asking

**User:** "Add a button to submit the form"

**Bad agent response:**
\`\`\`
[DON'T DO THIS]
Should I:
- Use <button> or <input type="submit">?
- Place it inside or outside the form?
- Style it with Tailwind or custom CSS?
- Add onClick handler or rely on form onSubmit?
\`\`\`

**Why bad:** These are implementation details with obvious best practices. Just use \`<button type="submit">\` inside the form and style consistently with the rest of the UI.

### Good: Don't Ask, Just Do

**User:** "Add error handling to the API calls"

**Good agent response:**
\`\`\`
I'll add error handling to all API calls using try/catch blocks, with:
- User-friendly error messages
- Error logging for debugging
- Graceful fallbacks where appropriate
- Toast notifications for user feedback

[Proceeds with implementation]
\`\`\`

**Why good:** Error handling has established patterns. No architectural decision needed.

## Workflow Integration

### In Planning Phase (EnterPlanMode)
- Ask about architecture choices BEFORE implementation
- Clarify ambiguous requirements BEFORE creating detailed plan
- Surface trade-offs DURING plan review

### In Implementation Phase
- Ask when encountering unexpected ambiguity
- Don't ask if plan already specifies approach
- Ask if discovered complexity requires scope change

### In Research Phase
- Ask about research depth/breadth upfront
- Clarify deliverable expectations
- Ask about priority when multiple research threads emerge

## Verification

Before marking requirement 🟢 Complete, verify:
- [ ] Did you ask about ambiguous requirements?
- [ ] Did you ask about architecture choices?
- [ ] Did user approve the approach?
- [ ] Did you document the decision rationale?

If you made assumptions without asking, requirement is NOT complete - go back and clarify.

## Summary

**Golden Rule:** When in doubt, ask. The cost of a 30-second question is far less than 2 hours of work in the wrong direction.

**Trigger phrase:** "This could go multiple ways - let me ask the user."

**Remember:** Asking questions is a feature, not a weakness. It shows you're thinking critically about trade-offs and respecting the user's vision.
