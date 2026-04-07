---
name: testing-best-practices
description: Build fast, resilient test suites by testing interfaces over implementation, using state/behavior verification deliberately, and choosing test doubles with clear intent.
compatibility: opencode
metadata:
  audience: software-engineers
  focus: test-design-and-maintainability
  additive: true
---

## Scope

Unit, service, and integration test work where maintainability, feedback speed, and refactor safety matter.

## Core Principles

- Test public interfaces, not private implementation.
- Minimal tests with high signal over exhaustive low-value assertions.
- Deterministic, isolated, easy to read.
- Behavior verification only when collaboration side effects are the thing being specified.
- Balanced test pyramid: fast unit tests + coarser integration/acceptance coverage.

## Sandi Metz Message Matrix

Classify each message before deciding what to test:

| Direction | Query (returns info) | Command (side effects) |
|-----------|---------------------|----------------------|
| **Incoming** | Assert returned result | Assert direct public side effect |
| **To self** | Do NOT test | Do NOT test |
| **Outgoing** | Do NOT test | Verify message send (mock/spy) |

## State vs Behavior Verification

- **State**: check observable post-conditions. Prefer by default when collaborators are easy and stable.
- **Behavior**: check collaborator interactions happened. Prefer when collaboration is awkward, side-effect-heavy, or external.
- Tradeoff: behavior-heavy tests couple to implementation and hinder refactoring.

## Test Doubles (simplest-first)

| Double | Purpose |
|--------|---------|
| Dummy | Placeholder arg, never called |
| Fake | Lightweight working impl (e.g., in-memory store) |
| Stub | Canned responses |
| Spy | Stub + records calls for later assertion |
| Mock | Pre-programmed interaction expectations |

Use the simplest double that proves the behavior. Don't mock everything by default. Spies improve AAA readability; mocks make interactions explicit but increase brittleness.

## Classical vs Mockist

Either style is fine if the suite stays fast, readable, and refactor-friendly. Always backstop with integration/acceptance tests for cross-object collaboration.

## Workflow

1. Define SUT public behavior (incoming queries and commands).
2. Choose verification mode per interaction (state or behavior) intentionally.
3. Pick the least-powerful test double that satisfies the test.
4. Skip testing private methods and outgoing queries.
5. Add integration coverage for critical boundaries.
6. Refactor tests for clarity after behavior is locked.

## RSpec / Rails Notes

- Favor request, integration, and model/service tests asserting user-visible outcomes.
- Factories/fixtures: create only data needed for the example.
- Prefer spies when they reduce duplicate `allow` + `expect` setup.
- Keep setup local and explicit; avoid magic shared contexts for core behavior.
- Side-effect boundaries (email, jobs, payments, external APIs): verify command messages; end-to-end checks at higher levels.

## Anti-Patterns

- Testing private methods directly.
- Asserting every internal collaborator call.
- Over-mocking cheap-to-execute domain logic.
- Large fixtures that hide causality and slow feedback.
- Brittle tests that break on harmless refactors.

## Quality Bar

Before finishing, confirm:
- Tests describe behavior through public interfaces.
- Each interaction uses a deliberate verification choice.
- Test doubles are minimal and purposeful.
- Refactoring internals does not cause broad test breakage.
- Critical user flows protected by integration/acceptance tests.
