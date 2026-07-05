---
name: rails-performance-and-query-hygiene
description: Improve Rails performance and query quality by preventing N+1s, reducing allocations, and applying safe, maintainable optimizations.
---

# Rails Performance and Query Hygiene

**Measure first.** The most common performance mistake is optimizing a path that isn't hot, or guessing at a cause the numbers would have ruled out. Profile the **hot path**, fix what the baseline shows, re-measure. Use for controllers, models, serializers, background jobs, and API endpoints where query count, latency, or memory can regress.

## Principles

- Baseline before you touch anything; re-measure after each change.
- Eliminate **N+1** queries and unnecessary eager loading.
- Prefer clear query intent and readable Ruby over clever micro-optimizations.
- Reach for index and query-shape fixes before caching.
- Keep optimizations safe for production and easy to reason about.

## OO Design Alignment

> For full OO design guidance, see the **ruby-changeable-oo-design** skill. Performance-specific points:

- Optimize in ways that reduce future change cost, not just current latency.
- Keep query objects and scopes single-purpose and composable; avoid entangled responsibilities and surprising side effects.

## Tools

- Rails Active Record Query Interface guides for `includes`/`preload`/`eager_load` semantics.
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

- Do NOT hide correctness issues behind caching.
- Paginate and explicitly order large datasets.
- Keep SQL fragments understandable and localized.
- Avoid premature abstraction while tuning.

## Quality Bar

Before finishing, confirm:
- Query count and/or latency improved measurably against the baseline.
- Correctness and existing API contracts maintained.
- Optimizations are readable and maintainable.
- Required index or migration follow-up is clearly called out.
