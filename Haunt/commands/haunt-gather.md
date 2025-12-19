# Gather the Haunt (Multi-Agent Coordination)

Gather the haunt to coordinate multiple agents working in parallel on the same complex task. Use when a single feature requires diverse expertise or when parallel work streams will speed completion.

## What is a Haunt?

A haunt is Ghost County's pattern for multi-agent parallel coordination. It:

1. **Analyzes the task** - Determines if parallel work is appropriate
2. **Defines contracts** - Establishes shared interfaces before spawning
3. **Spawns coordinated agents** - Multiple spirits working in concert
4. **Manages integration** - Brings parallel streams together

## Task: $ARGUMENTS

Invoke the `gco-haunt-mode` skill with the user's request:

```
$ARGUMENTS
```

The skill will:
- Analyze whether the task suits parallel execution
- Identify which domains are involved (backend, frontend, infrastructure, etc.)
- Define integration contracts (API specs, interfaces, file ownership)
- Spawn appropriate agents with coordinated scopes
- Monitor progress and facilitate integration
- Aggregate results into unified completion

## When to Use Haunt vs Seance

| Use `/seance` when: | Use `/haunt` when: |
|---------------------|-------------------|
| Starting new project | Implementing existing complex task |
| Planning features | Executing across multiple domains |
| Sequential workflow | Parallel work appropriate |
| Need roadmap creation | Already have requirement in roadmap |

**Simple rule:** Seance for planning, Haunt for parallel execution.

## Example Usage

```
/haunt REQ-089: Real-time notifications
/haunt Implement user profile feature across all layers
/haunt Add authentication to backend, frontend, and infrastructure
```

## Coordination Patterns

The haunt supports several coordination patterns:

- **Domain Split:** Backend + Frontend + Infrastructure working independently
- **Layer Split:** Cross-cutting changes across architectural layers
- **Feature Decomposition:** Large feature broken into parallel sub-features
- **Research + Implementation:** Parallel research and development streams

## Example Haunt Session

```
User: /haunt REQ-089: Real-time notifications

Response:
🌙 Gathering the haunt for REQ-089...

Analyzing task:
- Backend: WebSocket server, notification queue
- Frontend: Notification UI, WebSocket client
- Infrastructure: Redis pub/sub, load balancer

✅ Suitable for parallel haunt work (3 independent streams)

Defining contracts:
- WebSocket message format: { type, payload, timestamp }
- API: /api/notifications (REST), ws://api/notifications (WS)
- Redis channel: "notifications:{user_id}"

Contract saved to: .haunt/docs/integration-contracts/REQ-089.md

Ready to summon the haunt?
[User confirms]

🕯️ The spirits gather...

Summoning gco-dev-backend for WebSocket server...
Summoning gco-dev-frontend for notification UI...
Summoning gco-dev-infrastructure for Redis setup...

[Agents work in parallel]
[Integration phase]
[Testing validation]

🎉 The haunt has completed its work!
All changes integrated and tested.
```

## Quality Assurance

Before completing, the haunt ensures:
- All parallel streams completed successfully
- No file or logical conflicts
- Integration contracts honored
- Full test suite passes
- Unified commit created

## See Also

- `/seance <feature>` - Sequential workflow orchestration (planning → implementation)
- `/summon <agent> <task>` - Spawn single agent for focused work
- `/haunting` - View current active work across all agents
