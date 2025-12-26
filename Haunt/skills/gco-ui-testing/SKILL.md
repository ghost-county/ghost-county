---
name: gco-ui-testing
description: Playwright E2E test generation protocol for frontend features. Invoke when implementing user-facing UI components, user flows, or interactive features that require browser-based testing. Enforces TDD workflow and test coverage requirements.
---

# UI Testing Protocol

This skill enforces Playwright E2E test generation for frontend features to reduce manual verification overhead.

## When This Skill Applies

**REQUIRED:** Generate Playwright E2E tests when implementing ANY of the following:

### User-Facing Features (Always Test)
- User flows (login, signup, checkout, multi-step forms)
- Interactive UI components (modals, dropdowns, tabs, accordions, carousels)
- Page navigation (routing, redirects, history management)
- Form handling (input validation, submission, error states)
- Visual elements with behavior (responsive layouts, animations, dark mode)
- API integration in UI (data loading states, error handling, pagination)

### Edge Cases That Require Testing
- Authentication/authorization flows (protected routes, session handling)
- Error boundaries and fallback UI
- Loading and skeleton states
- Empty states and zero-data scenarios
- Client-side validation before server submission

## When E2E Tests Are Optional

Skip Playwright tests for:
- Pure backend/API work (use unit tests instead)
- Configuration changes with no UI impact
- Documentation-only changes
- Infrastructure/DevOps work
- Logic that doesn't touch the browser
- Spike code or prototypes (not production features)

## Test Location Requirements

### Standard Project Structure
Place E2E tests in project-appropriate locations:

| Project Type | Test Location | Naming Convention |
|--------------|---------------|-------------------|
| Next.js/React | `tests/e2e/` or `e2e/` | `*.spec.ts` |
| Vue | `tests/e2e/` | `*.spec.ts` |
| Generic Frontend | `tests/e2e/` | `*.spec.ts` |

### Haunt Framework Projects
For Ghost County or framework development:
- **Location:** `.haunt/tests/e2e/`
- **Naming:** `test_*.py` or `*.spec.ts`
- **Purpose:** Tests for framework tooling, setup scripts, agent behavior

### Naming Conventions
- Feature tests: `{feature-name}.spec.ts`
- Page tests: `{page-name}.spec.ts`
- Flow tests: `{flow-name}-flow.spec.ts`
- From requirements: `req-{XXX}.spec.ts`

## Integration with Existing Skills

This skill works with the `gco-playwright-tests` skill:

**Workflow:**
1. **This skill enforces** E2E test requirement for UI work
2. **gco-playwright-tests provides** test generation patterns and templates
3. **Skill has examples**: Test templates, best practices, and common patterns

**Do NOT duplicate content from the skill.** Reference it instead:
- For test templates: See `gco-playwright-tests` skill
- For selector strategies: See `gco-playwright-tests` skill
- For common patterns: See `gco-playwright-tests` skill

## User Journey Mapping for E2E Tests

Before writing E2E tests, map the complete user journey to ensure tests focus on real user behavior and business value.

### 1. Identify User Goal (JTBD Framework)

Ask: **"What is the user trying to accomplish?"**

**Examples:**
- ✅ "Book a hotel room for vacation"
- ✅ "Find and purchase wireless headphones"
- ✅ "Update account email address"
- ❌ "Test the booking API" (technical, not user-focused)
- ❌ "Click the submit button" (action, not goal)

### 2. Map Complete Journey

List every step from the user's perspective (not system perspective):

**Example: Hotel Booking Journey**
1. User searches for hotel in destination
2. User filters by price and amenities
3. User selects hotel
4. User enters booking dates
5. User enters guest information
6. User enters payment details
7. User receives confirmation

### 3. Define Expected Outcomes for Each Step

For EACH step, specify what success looks like from the user's perspective:

**Example Expected Outcomes:**
- Step 1 → Search results appear with relevant hotels
- Step 2 → Results update based on filters applied
- Step 3 → Hotel details page opens
- Step 4 → Calendar shows available dates
- Step 5 → Form accepts guest information without errors
- Step 6 → Payment is processed successfully
- Step 7 → Confirmation number displayed, email sent

### 4. Write Gherkin Scenarios (BDD Format)

Convert journey to structured Given-When-Then format:

```gherkin
Feature: Hotel Booking

  Scenario: User successfully books hotel room
    Given the user searches for "Miami Beach" hotels
    When the user filters by "$100-$200" price range
    And selects "Ocean View Resort"
    And enters check-in "2025-07-01" and check-out "2025-07-05"
    And enters guest name "John Doe"
    And enters payment details
    And clicks "Confirm Booking"
    Then booking confirmation appears
    And confirmation number is displayed
    And confirmation email is sent to user
```

**Gherkin Best Practices:**
- Write from user perspective (not system perspective)
- Use domain language (not technical jargon: "user clicks button" not "POST request sent")
- One scenario per specific behavior
- Keep scenarios focused and concise
- Use concrete examples (not abstract: "John Doe" not "a user")

### 5. Implement with Page Object Model

Create journey-focused methods that make tests read like user journeys:

**Page Object Model Example:**
```typescript
class HotelBookingJourney {
  async searchHotels(destination: string) {
    await this.page.fill('[data-testid="search-input"]', destination);
    await this.page.click('[data-testid="search-button"]');
  }

  async filterByPrice(min: number, max: number) {
    await this.page.selectOption('[data-testid="price-min"]', min.toString());
    await this.page.selectOption('[data-testid="price-max"]', max.toString());
  }

  async selectHotel(name: string) {
    await this.page.click(`[data-testid="hotel-${name}"]`);
  }

  async enterBookingDates(checkIn: string, checkOut: string) {
    await this.page.fill('[data-testid="check-in"]', checkIn);
    await this.page.fill('[data-testid="check-out"]', checkOut);
  }

  async enterGuestInfo(name: string) {
    await this.page.fill('[data-testid="guest-name"]', name);
  }

  async completePayment(cardInfo: PaymentDetails) {
    await this.page.fill('[data-testid="card-number"]', cardInfo.number);
    await this.page.fill('[data-testid="card-expiry"]', cardInfo.expiry);
    await this.page.fill('[data-testid="card-cvv"]', cardInfo.cvv);
    await this.page.click('[data-testid="confirm-booking"]');
  }

  async getConfirmationNumber(): Promise<string> {
    return await this.page.locator('[data-testid="confirmation-number"]').textContent();
  }
}
```

**Test Implementation (Reads Like Journey):**
```typescript
test('User successfully books hotel', async ({ page }) => {
  const journey = new HotelBookingJourney(page);

  await journey.searchHotels('Miami Beach');
  await journey.filterByPrice(100, 200);
  await journey.selectHotel('Ocean View Resort');
  await journey.enterBookingDates('2025-07-01', '2025-07-05');
  await journey.enterGuestInfo('John Doe');
  await journey.completePayment(testCardInfo);

  const confirmationNumber = await journey.getConfirmationNumber();
  expect(confirmationNumber).toMatch(/^HOTEL-\d{8}$/);
});
```

### When to Use Journey Mapping

✅ **Use journey mapping for:**
- Multi-step user flows (signup, checkout, booking, onboarding)
- Critical business paths (payment, authentication, order placement)
- Workflows spanning multiple pages or components
- Complex user interactions with multiple decision points
- Features where error recovery is important

❌ **Don't use journey mapping for:**
- Single-component interactions (use component tests instead)
- Internal API testing (use integration tests)
- Unit-level logic (use unit tests)
- Pure backend work (no user journey)

### Error Recovery Journeys

Don't just test happy paths. Map error recovery journeys where users fix mistakes:

**Example: Payment Error Recovery**
```gherkin
Scenario: User recovers from invalid payment information
  Given the user is on checkout page with items in cart
  When the user enters invalid credit card "1234"
  And clicks "Place Order"
  Then error message appears: "Invalid card number"
  And the card number field is highlighted
  And the order is NOT placed

  When the user corrects card number to "4111 1111 1111 1111"
  And clicks "Place Order" again
  Then the error message disappears
  And order is placed successfully
  And confirmation page appears
```

### Journey Mapping Template

For complex features, use the journey template to plan before implementing:

**Template Location:** `.haunt/templates/user-journey-template.md`

**When to use template:**
- M-sized requirements with complex user flows
- Features spanning multiple pages/components
- Workflows with critical business impact
- Before implementing tests (planning phase)

See template for full structure including User Goal, Journey Steps, Expected Outcomes, Test Scenarios, and Success Criteria.

### Good vs. Bad Journey-Based Tests

**BAD (Technical Focus):**
```typescript
test('checkout API returns 200', async ({ page }) => {
  const response = await page.request.post('/api/checkout', {
    data: { items: [{ id: 1, qty: 1 }], total: 29.99 }
  });
  expect(response.status()).toBe(200);
});
```
*Problem: Tests API, not user journey. No user value.*

**GOOD (User Journey Focus):**
```gherkin
Scenario: User completes purchase
  Given the user has "Wireless Mouse" in cart
  When the user proceeds to checkout
  And enters shipping address "123 Main St, City, State 12345"
  And enters credit card "4111 1111 1111 1111"
  And clicks "Place Order"
  Then order confirmation page appears
  And order number is displayed
  And confirmation email is sent to user's email
  And cart is now empty
```
*Success: Tests complete user experience and business outcome.*

### Resources

**Full examples and detailed guidance:**
- `.haunt/docs/research/req-254-user-journey-e2e-testing.md` - Complete research report
- `.haunt/templates/user-journey-template.md` - Planning template
- `.haunt/checklists/e2e-test-design-checklist.md` - Design checklist

**Related skills:**
- `gco-playwright-tests` - Test generation patterns and code examples
- `gco-tdd-workflow` - TDD cycle and testing workflow

## Frontend Design Plugin Integration

When working on UI features, the optional `frontend-design` Claude Code plugin provides additional capabilities:

**What the plugin offers:**
- Component scaffolding and templates
- Responsive design utilities
- Accessibility validation
- Browser preview integration
- Visual design helpers

**Installation:**
```bash
claude plugin marketplace add anthropics/claude-code
claude plugin install frontend-design@claude-code-plugins
```

**When to use:**
- Creating new UI components from scratch
- Building responsive layouts
- Implementing accessibility features
- Designing component APIs

**Note:** The plugin is **optional** and installed during Haunt setup if you choose "Yes" at the prompt. If you skipped it and need it later, install manually with the commands above.

## TDD Workflow for UI Features

Follow this sequence for all UI work:

### 1. Write Failing E2E Test FIRST
```typescript
// RED: Test describes expected behavior before implementation exists
test('should display user profile after login', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[data-testid="email"]', 'user@example.com');
  await page.fill('[data-testid="password"]', 'password123');
  await page.click('[data-testid="login-button"]');

  // These assertions will FAIL until feature is implemented
  await expect(page).toHaveURL('/profile');
  await expect(page.locator('[data-testid="user-name"]')).toBeVisible();
});
```

### 2. Implement Feature to Pass Test
```typescript
// GREEN: Implement minimal code to make test pass
// (Your React/Vue/etc. component implementation)
```

### 3. Refactor While Tests Stay Green
```typescript
// REFACTOR: Clean up implementation, tests verify nothing breaks
// (Optimize, extract helpers, improve naming, etc.)
```

## Verification Before Completion

Before marking ANY frontend requirement as 🟢 Complete, verify:

### Required Checks
- [ ] E2E tests exist for all user-facing behavior
- [ ] Tests are in correct location (tests/e2e/ or .haunt/tests/e2e/)
- [ ] Tests follow naming conventions
- [ ] All E2E tests pass: `npx playwright test`
- [ ] Tests cover happy path AND error cases
- [ ] Tests are independent (don't rely on order or shared state)

### Running E2E Tests
```bash
# Run all Playwright tests
npx playwright test

# Run specific test file
npx playwright test tests/e2e/feature-name.spec.ts

# Run in headed mode (visible browser, useful for debugging)
npx playwright test --headed

# Debug failing tests
npx playwright test --debug
```

### CI/CD Integration
If project has CI/CD pipeline, E2E tests MUST pass in CI before merge:
- GitHub Actions: Check workflow includes `npx playwright test`
- GitLab CI: Check `.gitlab-ci.yml` includes Playwright step
- Other CI: Verify E2E tests run automatically on PR/MR

## Completion Checklist Integration

This skill extends `gco-completion-checklist` for frontend work:

**Standard completion checklist items:**
1. All Tasks Checked Off
2. Completion Criteria Met
3. Tests Passing ← **This skill adds E2E test requirement here**
4. Files Updated
5. Documentation Updated

**E2E-specific additions:**
- Tests Passing MUST include: `npx playwright test` (not just unit tests)
- Files Updated MUST include: E2E test file(s) in tests/e2e/
- If E2E tests don't exist, requirement CANNOT be marked 🟢

## Common Mistakes to Avoid

### WRONG: Skipping E2E Tests
```markdown
### REQ-XXX: Add user login form

Tasks:
- [x] Created login component
- [x] Added form validation
- [x] Integrated with auth API
- [ ] ~~Write E2E tests~~ (skipped - will test manually)

Status: 🟢 Complete  ← VIOLATION: Cannot mark complete without E2E tests
```

### RIGHT: E2E Tests Included
```markdown
### REQ-XXX: Add user login form

Tasks:
- [x] Created login component
- [x] Added form validation
- [x] Integrated with auth API
- [x] Created tests/e2e/login.spec.ts with full flow coverage
- [x] Verified all Playwright tests pass

Status: 🟢 Complete  ← CORRECT: E2E tests exist and pass
```

### WRONG: Testing Implementation Details
```typescript
// Bad: Tests internal state instead of user-visible behavior
test('should set isLoading to true', async ({ page }) => {
  // Cannot test React state directly in E2E test
});
```

### RIGHT: Testing User-Visible Behavior
```typescript
// Good: Tests what users see and experience
test('should show loading spinner during login', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[data-testid="email"]', 'user@example.com');
  await page.fill('[data-testid="password"]', 'password123');
  await page.click('[data-testid="login-button"]');

  // Verify loading spinner appears
  await expect(page.locator('[data-testid="loading-spinner"]')).toBeVisible();

  // Verify loading spinner disappears after request completes
  await expect(page.locator('[data-testid="loading-spinner"]')).not.toBeVisible();
});
```

## Agent Workflow

### Dev-Frontend Agent
When assigned UI work:
1. Read requirement and identify user-facing behavior
2. **BEFORE implementation**: Write failing E2E test(s)
3. Run `npx playwright test` to verify test fails (RED)
4. Implement feature to make test pass (GREEN)
5. Run `npx playwright test` to verify test passes
6. Refactor if needed, keeping tests green
7. **BEFORE marking 🟢**: Verify all Playwright tests pass

### Dev-Backend Agent
When work includes UI integration:
1. Coordinate with Dev-Frontend for E2E test coverage
2. Ensure API endpoints support E2E test scenarios
3. If implementing API for frontend feature, wait for E2E tests to exist before marking complete

### Code-Reviewer Agent
When reviewing frontend PRs:
1. Verify E2E tests exist for all UI changes
2. Check tests are in correct location
3. Verify tests pass in CI/CD
4. Reject PR if E2E tests missing for user-facing changes

## Non-Negotiable Rules

1. **NEVER mark frontend requirement 🟢 without E2E tests**
   - If tests don't exist, requirement is incomplete
   - Manual testing is NOT a substitute for automated E2E tests

2. **NEVER skip E2E tests "because it's simple"**
   - Simple features still need tests
   - "Simple" bugs are the most embarrassing in production

3. **NEVER commit failing E2E tests**
   - All Playwright tests must pass before commit
   - Use `npx playwright test` to verify before committing

4. **ALWAYS write tests before implementation (TDD)**
   - Write failing test first (RED)
   - Implement to make it pass (GREEN)
   - Refactor while keeping tests green

5. **ALWAYS test user behavior, not implementation**
   - Test what users see and do
   - Don't test internal state or component props
   - Focus on user flows and interactions

## Chrome Recorder Integration

Chrome DevTools Recorder (built into Chrome) can generate E2E test skeletons quickly. Use it to bootstrap tests, then refine for production.

### How to Access Chrome Recorder
1. Open Chrome DevTools (F12 or Cmd+Opt+I)
2. Press `Cmd/Ctrl + Shift + P`
3. Type "Show Recorder"
4. Or: DevTools → ⋮ (More Tools) → Recorder

### Recording Workflow
1. **Start Recording:** Click red record button
2. **Interact:** Perform user flow (login, navigate, submit form)
3. **Stop Recording:** Click stop button
4. **Export:** Select "Export as Playwright"
5. **Refine:** Replace generated selectors with `data-testid`

### Refinement Checklist
After exporting from Chrome Recorder:
- [ ] Replace CSS selectors with `data-testid` attributes
- [ ] Add assertions for expected outcomes
- [ ] Add error case tests (validation failures, network errors)
- [ ] Extract Page Object Model patterns for reusability
- [ ] Add test data fixtures
- [ ] Verify tests are independent (no shared state)
- [ ] Add descriptive test names and comments
- [ ] Run tests in CI/CD to ensure stability

### When to Use Chrome Recorder
✅ **Use when:**
- Generating test skeleton for complex user flows
- Onboarding new team members to E2E testing
- Demonstrating user flows to stakeholders
- Exploring application behavior before writing tests

❌ **Don't use when:**
- Need production-ready tests immediately (requires refinement)
- Working with dynamic content (generated selectors are brittle)
- Tests need to handle edge cases (Recorder only captures happy path)

## Tool Selection Decision Tree

### When to Use Playwright (DEFAULT)
✅ **Use Playwright for:**
- General UI testing (90% of cases)
- Cross-browser testing (Chrome, Firefox, Safari)
- Enterprise projects requiring maintainability
- Teams using TypeScript/JavaScript
- Projects needing parallelization in CI/CD

### When to Use Puppeteer (EDGE CASES)
✅ **Use Puppeteer for:**
- Chrome-only automation
- Web scraping projects
- Stealth capabilities required (bot detection bypass)
- JavaScript/Node.js exclusive teams

### When to Use Chrome Recorder (SKELETON GENERATION)
✅ **Use Chrome Recorder for:**
- Quick test skeleton generation (export to Playwright)
- Onboarding and demonstrations
- Exploring user flows before writing tests

### Combined Workflow (RECOMMENDED)
1. Chrome Recorder → capture initial flow (1-2 min)
2. Export to Playwright
3. Refine selectors to `data-testid`
4. Add assertions and edge cases
5. Run in CI/CD with Playwright

**Bottom line:** Use Playwright as default, Chrome Recorder for bootstrapping, Puppeteer only if Chrome-only is acceptable.

## Pre-commit Hooks: When NOT to Use E2E Tests

### ❌ DO NOT Run E2E Tests in Pre-commit

E2E tests should **NOT** run in pre-commit hooks because:
- **Too slow:** E2E tests take 2-30+ seconds, blocking commits
- **Flaky in local environments:** Browser automation sensitive to local state
- **Better in CI:** E2E tests belong in controlled CI/CD environment

### ✅ DO Run in Pre-commit
- **Linting** (ESLint)
- **Formatting** (Prettier)
- **Type checking** (tsc --noEmit)
- **Unit tests** (fast, < 1 second)

### ✅ DO Run E2E Tests in CI/CD
Configure E2E tests to run on push/PR in GitHub Actions, GitLab CI, etc.

**Example `.pre-commit-config.yaml`:**
```yaml
repos:
  - repo: local
    hooks:
      - id: eslint
        name: ESLint
        entry: npx eslint
        language: node
        types: [javascript, typescript]
      - id: prettier
        name: Prettier
        entry: npx prettier --check
        language: node
        types: [javascript, typescript, json, yaml]
      - id: type-check
        name: TypeScript Type Check
        entry: npx tsc --noEmit
        language: node
        pass_filenames: false
      # NO E2E TESTS HERE - Too slow for pre-commit!
```

**Instead, run E2E tests in CI/CD** (see "CI/CD Integration Examples" section).

## CI/CD Integration Examples

### GitHub Actions (Recommended)

Create `.github/workflows/playwright.yml`:

```yaml
name: Playwright Tests
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    timeout-minutes: 10
    runs-on: ubuntu-latest
    strategy:
      matrix:
        browser: [chromium, firefox, webkit]
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Install Playwright Browsers
        run: npx playwright install --with-deps ${{ matrix.browser }}

      - name: Run Playwright Tests
        run: npx playwright test --project=${{ matrix.browser }}

      - name: Upload Test Results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: playwright-report-${{ matrix.browser }}
          path: playwright-report/
          retention-days: 7

      - name: Upload Trace Files
        uses: actions/upload-artifact@v3
        if: failure()
        with:
          name: playwright-traces-${{ matrix.browser }}
          path: test-results/
          retention-days: 7
```

### Test Sharding (Parallel Execution)

For faster CI runs, use test sharding:

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        shard: [1, 2, 3, 4]
    steps:
      - uses: actions/checkout@v3
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npx playwright test --shard=${{ matrix.shard }}/4
```

### Merge Blocking

Configure branch protection rules in GitHub:
1. Go to Repository Settings → Branches
2. Add branch protection rule for `main`
3. Enable "Require status checks to pass before merging"
4. Select "Playwright Tests" workflow
5. Now PRs cannot merge unless E2E tests pass

### Artifact Upload

When tests fail, upload:
- **Playwright report** (HTML report for debugging)
- **Trace files** (detailed execution traces)
- **Screenshots** (visual evidence of failures)

This allows debugging failed tests without running them locally.

## See Also

- `Haunt/skills/gco-playwright-tests/SKILL.md` - Detailed test patterns and examples
- `Haunt/skills/gco-tdd-workflow/SKILL.md` - General TDD guidance
- `Haunt/commands/qa.md` - Generate test scenarios from requirements
- `Haunt/skills/gco-completion-checklist/SKILL.md` - General completion requirements
- `Haunt/docs/BROWSER-MCP-SETUP.md` - Browser MCP installation guide
- `Haunt/docs/CHROME-RECORDER-GUIDE.md` - Chrome Recorder integration guide
