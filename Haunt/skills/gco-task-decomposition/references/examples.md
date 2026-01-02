# Task Decomposition Examples

Complete worked examples of requirement decomposition.

## Example: REQ-050 User Dashboard

Full decomposition from SPLIT requirement to atomic pieces.

### Original Requirement

```markdown
### SPLIT REQ-050: Add User Dashboard

**Type:** Enhancement
**Effort:** SPLIT (estimated 16 hours)
**Files:** 18 files

**Tasks:**
- [ ] Create dashboard data models
- [ ] Build dashboard API endpoints
- [ ] Implement caching layer
- [ ] Create dashboard UI components
- [ ] Add charts and visualizations
- [ ] Write unit tests
- [ ] Write E2E tests
- [ ] Add documentation
```

---

### After Decomposition

```markdown
## Batch 8: User Dashboard (Decomposed from REQ-050)

### ⚪ REQ-050-A: Dashboard Data Models

**Type:** Enhancement
**Effort:** S (1.5 hours)
**Files:**
- `src/models/dashboard.py` (create)
- `tests/models/test_dashboard.py` (create)

**Tasks:**
- [ ] Create DashboardMetrics model
- [ ] Create DashboardWidget model
- [ ] Write model unit tests

**Agent:** Dev-Backend
**Completion:** Models created with 100% test coverage
**Blocked by:** None

---

### ⚪ REQ-050-B: Dashboard API Endpoints

**Type:** Enhancement
**Effort:** M (3 hours)
**Files:**
- `src/api/dashboard.py` (create)
- `tests/api/test_dashboard.py` (create)
- `src/api/__init__.py` (modify)

**Tasks:**
- [ ] Create GET /api/dashboard endpoint
- [ ] Create GET /api/dashboard/widgets endpoint
- [ ] Add authentication middleware
- [ ] Write API tests

**Agent:** Dev-Backend
**Completion:** API returns correct dashboard data for authenticated users
**Blocked by:** REQ-050-A

---

### ⚪ REQ-050-C: Dashboard Caching Layer

**Type:** Enhancement
**Effort:** S (2 hours)
**Files:**
- `src/cache/dashboard.py` (create)
- `tests/cache/test_dashboard.py` (create)

**Tasks:**
- [ ] Implement Redis caching for dashboard data
- [ ] Add cache invalidation on data updates
- [ ] Write cache tests

**Agent:** Dev-Backend
**Completion:** Dashboard API responses cached with 5-minute TTL
**Blocked by:** REQ-050-A
**Note:** Can run in parallel with REQ-050-B

---

### ⚪ REQ-050-D: Dashboard UI Components

**Type:** Enhancement
**Effort:** M (3.5 hours)
**Files:**
- `src/components/Dashboard/index.tsx` (create)
- `src/components/Dashboard/DashboardCard.tsx` (create)
- `src/components/Dashboard/DashboardGrid.tsx` (create)
- `src/components/Dashboard/Dashboard.test.tsx` (create)

**Tasks:**
- [ ] Create DashboardCard component
- [ ] Create DashboardGrid layout component
- [ ] Create main Dashboard page
- [ ] Write component tests

**Agent:** Dev-Frontend
**Completion:** Dashboard components render correctly with mock data
**Blocked by:** REQ-050-B

---

### ⚪ REQ-050-E: Dashboard Charts and Visualizations

**Type:** Enhancement
**Effort:** M (2.5 hours)
**Files:**
- `src/components/Dashboard/Charts/LineChart.tsx` (create)
- `src/components/Dashboard/Charts/BarChart.tsx` (create)
- `src/components/Dashboard/Charts/Charts.test.tsx` (create)

**Tasks:**
- [ ] Create LineChart component with D3/Chart.js
- [ ] Create BarChart component
- [ ] Add chart animations and interactivity
- [ ] Write chart tests

**Agent:** Dev-Frontend
**Completion:** Charts render with sample data and respond to interactions
**Blocked by:** REQ-050-D
**Note:** Can run in parallel with REQ-050-F

---

### ⚪ REQ-050-F: Dashboard E2E Tests

**Type:** Enhancement
**Effort:** S (2 hours)
**Files:**
- `tests/e2e/dashboard.spec.ts` (create)

**Tasks:**
- [ ] Write E2E test for dashboard loading
- [ ] Write E2E test for widget interactions
- [ ] Write E2E test for chart rendering

**Agent:** Dev-Frontend
**Completion:** E2E tests pass for all dashboard user flows
**Blocked by:** REQ-050-D
**Note:** Can run in parallel with REQ-050-E
```

---

### Decomposition Summary

```markdown
## Decomposition Summary: REQ-050

**Original:** SPLIT (16 hours, 18 files)
**Decomposed into:** 6 requirements

### Dependency DAG

        REQ-050-A (Foundation)
             |
    +--------+--------+
    |                 |
REQ-050-B        REQ-050-C
(API)             (Cache)
    |                 |
    +--------+--------+
             |
        REQ-050-D (UI)
             |
    +--------+--------+
    |                 |
REQ-050-E        REQ-050-F
(Charts)         (E2E Tests)

### Parallelization Opportunities

**Phase 1:** A (Sequential - foundation)
**Phase 2:** B || C (Parallel - no dependencies)
**Phase 3:** D (Sequential - waits for API)
**Phase 4:** E || F (Parallel - no dependencies)

**Parallelization Ratio:** 4/6 tasks parallelizable (67%)
**Estimated Time Savings:** ~4 hours with parallel execution

### Agent Assignments

- Dev-Backend: A, B, C (6.5 hours)
- Dev-Frontend: D, E, F (8 hours)

### Execution Order (Optimal)

1. Spawn Dev-Backend for REQ-050-A
2. When A completes, spawn Dev-Backend for B and C in parallel
3. When B completes, spawn Dev-Frontend for REQ-050-D
4. When D completes, spawn Dev-Frontend for E and F in parallel
```

---

## Parallelization Patterns

### Pattern 1: Domain Parallel

```
          Foundation
         /    |    \
   Backend  Frontend  Infra
         \    |    /
         Integration
```

**Use case:** Each domain works independently after foundation.

**Example:**
- Foundation: Define API contract and data models
- Backend: Implement API endpoints
- Frontend: Build UI components
- Infra: Set up deployment pipeline
- Integration: End-to-end testing and deployment

**Parallelization:** Backend, Frontend, Infra run simultaneously after Foundation

---

### Pattern 2: Layer Parallel

```
     API Design (Contract)
      /              \
   Backend          Frontend
   (implements)     (implements)
      \              /
       Integration Test
```

**Use case:** API contract enables parallel implementation.

**Example:**
- API Design: Define OpenAPI spec and types
- Backend: Implement endpoints matching spec
- Frontend: Build UI consuming spec
- Integration Test: Verify frontend + backend work together

**Parallelization:** Backend and Frontend implement contract simultaneously

---

### Pattern 3: Feature Parallel

```
         Core Model
        /     |    \
   Create   Read   Update
        \     |    /
         E2E Tests
```

**Use case:** CRUD operations can be parallelized.

**Example:**
- Core Model: Define User entity and database schema
- Create: POST /api/users endpoint
- Read: GET /api/users/:id endpoint
- Update: PUT /api/users/:id endpoint
- E2E Tests: Test all CRUD operations together

**Parallelization:** Create, Read, Update implement independently after Core Model

---

## Decomposition Strategy Examples

### Layer Split Example

**Original:** Full-stack authentication system (SPLIT)

**Decomposed:**
1. Database schema and migrations (S)
2. Backend authentication service (M)
3. API endpoints (login, logout, refresh) (S)
4. Frontend login/signup UI (M)
5. E2E authentication tests (S)

**Dependencies:**
```
1 (Schema)
    |
2 (Service)
    |
3 (API)
    |
4 (UI)
    |
5 (E2E Tests)
```

**Parallelization:** None (sequential layers)

---

### Domain Split Example

**Original:** Multi-module admin dashboard (SPLIT)

**Decomposed:**
1. Shared UI components and layout (S)
2. User management module (M)
3. Settings module (S)
4. Analytics module (M)
5. Integration and E2E tests (S)

**Dependencies:**
```
    1 (Shared)
   / | \
  2  3  4
   \ | /
    5 (Integration)
```

**Parallelization:** Modules 2, 3, 4 run in parallel after Shared components complete

---

### Feature Slice Example

**Original:** Product catalog with full CRUD (SPLIT)

**Decomposed:**
1. Product data model and validation (S)
2. Create product feature (S)
3. Read/list products feature (S)
4. Update product feature (S)
5. Delete product feature (XS)
6. Product catalog E2E tests (M)

**Dependencies:**
```
        1 (Model)
    / | | \
   2  3  4  5
    \ | | /
      6 (E2E)
```

**Parallelization:** CRUD operations (2-5) run in parallel after Model

---

### Risk Isolation Example

**Original:** Integrate new payment gateway (SPLIT, uncertain)

**Decomposed:**
1. Spike: Evaluate payment gateway APIs (XS)
2. Foundation: Payment service abstraction layer (S)
3. Feature: Implement Stripe integration (M)
4. Feature: Implement PayPal integration (M)
5. Testing: Payment integration tests (S)

**Dependencies:**
```
1 (Spike)
    |
2 (Foundation)
   / \
  3   4
   \ /
    5 (Tests)
```

**Parallelization:** Stripe and PayPal integrations (3, 4) run in parallel

---

## Common Decomposition Scenarios

### Scenario: Large Full-Stack Feature

**Original:** User profile management (16 hours, SPLIT)

**Decomposition approach:** Layer Split
1. Profile data model (S)
2. Profile API endpoints (M)
3. Profile UI components (M)
4. Profile image upload (S)
5. Profile E2E tests (S)

**Total:** 5 requirements, 12.5 hours with parallelization

---

### Scenario: Multiple Related Features

**Original:** Dashboard widgets (20 hours, SPLIT)

**Decomposition approach:** Feature Parallel
1. Widget framework/layout (S)
2. Activity widget (S)
3. Analytics widget (S)
4. Notifications widget (S)
5. Settings widget (S)
6. Widget E2E tests (M)

**Total:** 6 requirements, 10 hours with parallelization

---

### Scenario: Complex Migration

**Original:** Database migration to new schema (24 hours, SPLIT)

**Decomposition approach:** Risk Isolation + Dependency Chain
1. Spike: Design migration strategy (XS)
2. Foundation: Dual-write compatibility layer (M)
3. Phase 1: Migrate user tables (S)
4. Phase 2: Migrate transaction tables (S)
5. Phase 3: Migrate reporting tables (S)
6. Cutover: Remove compatibility layer (S)

**Total:** 6 requirements, sequential execution required (no parallelization)

---

## Quality Checklist for Examples

When using these examples as templates, verify:

- [ ] Each decomposed piece is XS/S/M (not SPLIT)
- [ ] Dependencies form valid DAG (no cycles)
- [ ] Parallel opportunities identified and marked
- [ ] Agent assignments match domain expertise
- [ ] File paths are specific (no overlap for parallel tasks)
- [ ] Completion criteria are testable
- [ ] Integration point clearly defined
