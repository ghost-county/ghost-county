# React Standards (Slim Reference)

## Core Principles

1. **Feature-based organization** with unidirectional dependency flow
2. **Colocate code near usage** - components, styles, state together
3. **Separate server state from client state** - React Query/SWR, not Redux
4. **Client-side security is UX only** - ALL authorization validated server-side

## Project Structure

```
src/
├── app/           # Routes, providers, router (entry point)
├── features/      # Self-contained feature modules
│   └── [feature]/
│       ├── api/          # Feature API calls
│       ├── components/   # Feature components
│       ├── hooks/        # Feature hooks
│       └── types/        # Feature types
├── components/    # Shared components
├── hooks/         # Shared hooks
├── lib/           # Preconfigured libraries
└── utils/         # Shared utilities
```

**Dependency flow:** Shared → Features → App (unidirectional)

## State Management

| State Type | Tools | Use Case |
|------------|-------|----------|
| Component | useState, useReducer | Local UI state |
| Application | Context, Zustand | Modals, theme, notifications |
| Server Cache | React Query, SWR | Remote data (NOT Redux) |
| Form | React Hook Form + Zod | Validation |
| URL | React Router | Dynamic params |

## API Layer Pattern

```typescript
// Types → Fetcher → Hook
type LoginRequest = { email: string; password: string };
const login = (data: LoginRequest) => apiClient.post('/auth/login', data);
const useLogin = () => useMutation({ mutationFn: login });
```

## File Naming

- **Files:** kebab-case (`user-profile.tsx`)
- **Components:** PascalCase export (`export const UserProfile`)
- **Imports:** Absolute with `@/*` alias, no barrel files

## Security: Token Storage

| Token | Storage | Why |
|-------|---------|-----|
| Access | React state (memory) | XSS can't steal |
| Refresh | HttpOnly cookie | JS can't access |

**NEVER:** localStorage or sessionStorage for tokens

## Security: Authorization

```typescript
// Check permissions, not roles
if (permissions["delete:projects"]) { ... }  // RIGHT
if (user.role === 'admin') { ... }           // WRONG

// Conditional rendering
<Restricted to="create:projects">
  <CreateButton />
</Restricted>
```

## Security: XSS Prevention

- **NEVER** use `dangerouslySetInnerHTML` with user input
- **IF REQUIRED:** Sanitize with DOMPurify first
- **PREFER:** React's default escaping (`{userInput}`)

## Non-Negotiable

**Architecture:**
- NEVER allow feature-to-feature imports
- NEVER use Redux for server cache
- NEVER use barrel files (breaks tree-shaking)

**Security:**
- NEVER store tokens in localStorage/sessionStorage
- NEVER trust client-side authorization
- NEVER use `dangerouslySetInnerHTML` without DOMPurify
- ALWAYS validate permissions server-side

## See Also

- `gco-ui-design-standards.md` - Accessibility, spacing, states
- `gco-ui-testing.md` - Playwright E2E testing
