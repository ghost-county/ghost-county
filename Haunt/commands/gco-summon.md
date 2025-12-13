# Summon Spirit

Call forth a specific Ghost County agent to handle a task. The summoned spirit will manifest with focused expertise and execute autonomously.

## Task: $ARGUMENTS

Parse the agent type and task from the arguments.

**Expected format:** `<agent-type> <task-description>`

**Example usage:**
- `/summon dev Fix the authentication bug`
- `/summon research Investigate React 19 server components`
- `/summon code-reviewer Review PR #42`
- `/summon release-manager Prepare v1.2.0 release`
- `/summon project-manager Update roadmap priorities`

## Supported Agent Types

Parse the first argument to determine which spirit to summon:

| User Input | Maps To | Agent Character Sheet | Domain |
|------------|---------|----------------------|---------|
| `dev`, `dev-backend`, `backend` | Dev-Backend | `gco-dev-backend` | API, services, database |
| `dev-frontend`, `frontend` | Dev-Frontend | `gco-dev-frontend` | UI, components, client |
| `dev-infra`, `infrastructure`, `infra` | Dev-Infrastructure | `gco-dev-infrastructure` | IaC, CI/CD, deployment |
| `research`, `research-analyst`, `analyst` | Research-Analyst | `gco-research-analyst` | Investigation, analysis |
| `code-reviewer`, `reviewer`, `review` | Code-Reviewer | `gco-code-reviewer` | Code quality, review |
| `release-manager`, `release`, `rm` | Release-Manager | `gco-release-manager` | Release coordination |
| `project-manager`, `pm`, `manager` | Project-Manager | `gco-project-manager` | Planning, coordination |

## Summoning Logic

1. **Parse agent type** from first argument (case-insensitive)
2. **Extract task** from remaining arguments
3. **Map to gco-* agent** using table above
4. **Spawn the spirit** using Task tool with:
   - `subagent_type`: Mapped agent character sheet (e.g., `gco-dev-backend`)
   - `instructions`: Task description with Ghost County context

## Example Invocation

If user types: `/summon dev Fix the authentication redirect loop`

**Parsing:**
- Agent type: `dev` → Maps to `gco-dev-backend`
- Task: `Fix the authentication redirect loop`

**Spawn:**
```
Task tool with:
- subagent_type: "gco-dev-backend"
- instructions: "You are a Dev-Backend agent in Ghost County. Fix the authentication redirect loop."
```

## Error Handling

**Unknown agent type:**
```
🌫️ The mists are unclear... Unknown agent type: <input>

Summon a spirit by name:
- dev, research, code-reviewer, release-manager, project-manager

Example: /summon dev Fix the login bug
```

**No task provided:**
```
🌫️ The summoning requires a task...

Usage: /summon <agent-type> <task-description>
Example: /summon dev Fix the authentication bug
```

## Ghost County Namespace

**IMPORTANT:** GCO agents should only spawn other GCO agents (gco-* prefix) to maintain namespace isolation. Never spawn non-prefixed agents from within Ghost County workflows.

## See Also

- `/seance <feature>` - Guided workflow from idea to implementation
- `/coven <task>` - Multi-agent parallel coordination
- `/haunting` - View current active work
