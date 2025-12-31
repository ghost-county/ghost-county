# Python Standards (Slim Reference)

## Core Principle

**Explicit over implicit. Readability over cleverness. One obvious way.**

## Anti-Patterns (Never Do This)

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| `def func(x, lst=[])` | Mutable defaults shared | `lst=None; lst = lst or []` |
| `from module import *` | Namespace pollution | `import module` or specific |
| `if attr == True:` | Verbose | `if attr:` |
| `for i in range(len(items)):` | Index noise | `for i, item in enumerate(items):` |
| Modify list while iterating | Skips/errors | New list via comprehension |

## PEP 8 Essentials

1. **Naming:** `snake_case` functions, `PascalCase` classes, `UPPER_CASE` constants
2. **Indentation:** 4 spaces (never tabs)
3. **Line Length:** 79 chars code, 72 chars comments
4. **Imports:** stdlib → third-party → local (alphabetical within)
5. **Whitespace:** `func(arg)` not `func (arg)`

## Type Hints (Python 3.10+)

**When to type:** Public APIs, complex transformations, framework integration

```python
# Modern syntax
def process(data: str | bytes) -> dict[str, int] | None: ...

# TypedDict for structured data
from typing import TypedDict
class User(TypedDict):
    name: str
    email: str
```

**Run mypy:** `mypy --strict src/` (configure in pyproject.toml)

## Pytest Essentials

**Fixture scopes:**
- `function` (default): Isolated per test
- `module`: Shared across file
- `session`: Shared across run

**Test naming:** `test_<component>_<scenario>_<expected>()`

**Mocking rules:**
- DO mock: External services, time, expensive operations
- DON'T mock: Your own functions, pure logic

**Run tests:** `pytest --cov=src --cov-fail-under=80`

## Code Validation

Before marking Python work complete:
- [ ] No mutable default arguments
- [ ] No wildcard imports
- [ ] Context managers for file operations
- [ ] PEP 8 compliance (`black` or `ruff`)
- [ ] Type hints on public APIs
- [ ] Tests pass with 80%+ coverage

## Non-Negotiable

- NEVER use mutable default arguments
- NEVER use wildcard imports in production
- NEVER skip type hints on public APIs
- ALWAYS use descriptive test function names

## See Also

- `gco-completion-checklist.md` - Full completion requirements
