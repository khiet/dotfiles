---
name: rails-performance-and-query-hygiene
description: Improve Rails performance and query quality by preventing N+1s, reducing allocations, and applying safe, maintainable optimizations.
compatibility: opencode
metadata:
  audience: rails-engineers
  focus: api-and-db-performance
  additive: true
---

## Scope

Rails performance work in controllers, models, serializers, background jobs, and API endpoints where query count, latency, or memory usage can regress.

## Principles

- **Measure first, optimize second.**
- Eliminate N+1 queries and unnecessary eager loading.
- Clear query intent and readable Ruby over clever micro-optimizations.
- Index and query-shape improvements before caching.
- Keep optimizations safe for production and easy to reason about.

## OO Design Alignment

> For full OO design guidance, see the **ruby-changeable-oo-design** skill.

Key performance-specific points:
- Optimize in ways that reduce future change cost, not just current latency.
- Keep query objects and scopes single-purpose; avoid entangled responsibilities.
- Keep dependencies explicit and shallow (DI, narrow interfaces).

## Reference Tools

- Rails Active Record Query Interface guides.
- Bullet gem for N+1 detection.
- rack-mini-profiler and `EXPLAIN` plans for bottleneck analysis.

## Workflow

1. Reproduce the hot path; capture baseline timings and query counts.
2. Identify N+1s, heavy joins, missing indexes, over-fetching, serializer inflation.
3. Apply minimal, targeted fixes (`includes`, `preload`, `select`, batching, pagination, index updates).
4. Re-check query counts and timings after each change.
5. Confirm behavior and response shape remain correct.
6. Document before/after impact and tradeoffs.

## Implementation Rules

- Do NOT hide correctness issues with caching.
- Avoid premature abstraction while tuning.
- Keep scopes composable; no surprising side effects.
- Paginate and explicitly order large datasets.
- Keep SQL fragments understandable and localized.
- Avoid train-wreck calls and cross-layer leakage.
- Tests focus on stable interfaces and user-visible behavior.

## Quality Bar

Before finishing, confirm:
- Query count and/or latency improved measurably.
- Correctness and existing API contracts maintained.
- Optimizations are readable and maintainable.
- Required index or migration follow-up is clearly called out.
