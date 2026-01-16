# Visual Verification Rule

## Trigger Conditions

This rule activates when you are modifying:
- CSS files (`*.css`, `*.scss`, `*.sass`)
- Tailwind config (`tailwind.config.*`)
- Theme files (globals.css, theme.ts, colors, design tokens)
- Component styling (className changes, style props)
- Layout/spacing changes

## The Rule

**BEFORE claiming CSS/styling work is "fixed" or "complete":**

1. Take a Playwright screenshot:
   ```bash
   # If using Playwright MCP:
   mcp__playwright__playwright_navigate → url
   mcp__playwright__playwright_screenshot

   # Or CLI:
   npx playwright screenshot <url> /tmp/verify.png
   ```

2. Read the screenshot to visually confirm the change

3. Only then report completion

## Quick Check

Ask yourself: **"Did I see a screenshot confirming the visual change?"**

- **YES, looks correct** → Report completion
- **YES, still broken** → Continue debugging
- **NO screenshot taken** → Take screenshot first

## Why This Matters

CSS variables can be:
- Defined but not applied
- Applied but overridden
- Correct in one view but broken in another
- Working in dev but not production build

**Code review cannot catch visual bugs.** Only visual verification can.

## Examples

### WRONG (Code-Only Verification)
```
I've updated the CSS variables in globals.css to use dark theme colors.
The theme should now work correctly.
Fixed
```

### RIGHT (Visual Verification)
```
I've updated the CSS variables in globals.css. Let me take a screenshot to verify.

[Takes Playwright screenshot]
[Reads screenshot]

Screenshot shows dark background (#18181B) and cream text. Visual verification confirms the fix.
Verified visually
```

## Non-Negotiable

- **NEVER** claim CSS/styling is "fixed" without a screenshot
- **NEVER** assume Tailwind classes work without visual proof
- **NEVER** skip verification "because the code looks correct"

## See Also

- `gco-ui-testing-reminder` - E2E functional testing
- `gco-playwright-tests` skill - Test generation
- `gco-ui-design` skill - UI standards
