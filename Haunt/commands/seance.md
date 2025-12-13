# Conduct Seance (Workflow Orchestration)

Hold a séance to guide ideas through the complete Ghost County workflow: from vision to requirements to roadmap, then optionally summon worker spirits for implementation.

## What is a Seance?

A séance is Ghost County's primary workflow orchestration ritual with three context-aware modes:

**Mode 1: With Prompt** (`/seance Build a task management app`)
- Start idea-to-roadmap workflow immediately with the provided prompt
- Works for both new and existing projects

**Mode 2: No Arguments + Existing Project** (`/seance` in repo with `.haunt/`)
- Prompt user with choice:
  - **[A] Add something new** — "I have an idea, feature, or bug to add"
  - **[B] Summon the spirits** — "The roadmap is ready. Let's work."
- If A: Ask what to add, then run incremental workflow
- If B: Show current ⚪ Not Started items and offer to spawn agents

**Mode 3: No Arguments + New Project** (`/seance` in repo without `.haunt/`)
- Prompt: "What would you like to build?"
- Wait for user input, then run full idea-to-roadmap workflow

## Task: $ARGUMENTS

**Step 1: Detect Mode**

Check for arguments and `.haunt/` directory:

```python
import os

has_args = bool("$ARGUMENTS".strip())
has_haunt = os.path.exists(".haunt/")

if has_args:
    mode = 1  # With prompt - immediate workflow
elif has_haunt:
    mode = 2  # No args + existing - choice prompt
else:
    mode = 3  # No args + new - new project prompt
```

**Step 2: Execute Mode-Specific Flow**

Invoke the `gco-seance` skill with detected mode and arguments:

```
MODE: {mode}
ARGUMENTS: $ARGUMENTS
```

The skill will handle the appropriate flow based on mode.

## Example Usage

**Mode 1 (With Prompt):**
```
/seance Build a task management app
/seance Add OAuth login support
/seance Fix the authentication bug and add tests
```

**Mode 2 (No Args, Existing Project):**
```
/seance
> 🕯️ The spirits stir. What brings you to the veil?
> [A] Add something new — I have an idea, feature, or bug to add
> [B] Summon the spirits — The roadmap is ready. Let's work.
```

**Mode 3 (No Args, New Project):**
```
/seance
> 🕯️ A fresh haunting ground. What would you like to build?
```

## See Also

- `/summon <agent> <task>` - Directly spawn a specific agent
- `/haunting` - View current active work
- `/divine <topic>` - Research a topic
