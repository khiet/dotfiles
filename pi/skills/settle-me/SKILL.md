---
name: settle-me
description: Grill a plan, design, or ticket and settle the open questions yourself, asking the user only at one-way doors. Use when the user says 'settle me'.
---

Call the Skill tool with "grilling" for its design tree, frontier, and question format. This skill owns the decisions and the pacing: you settle every ready two-way door yourself, the user hears only the ready one-way doors, and you keep working until that gate or the report.

## Settling a round

Work the frontier as grilling describes, and settle each question in the same turn: your recommended answer is the decision. Settled questions push the frontier outward; recompute it and keep going. Settled rounds stay in your head; show the user only the report.

Find facts before classifying a question: look them up or dispatch a sub-agent, as grilling says. A question is a decision only once its facts are in.

A **one-way door** is a decision the user must own because walking it back is costly or because only they hold the answer:

- Walking it back needs a data migration, a change visible outside the codebase (a public API, a security boundary), or money.
- The options are equally good and the choice materially changes the scope.
- It is product intent: what users expect, which of two outcomes matters more.

Everything else is a two-way door: settle it. A one-way door stays open, and so does everything downstream of it. When every open question is a one-way door or depends on one, ask the frontier's one-way doors in one round in grilling's format, wait for the answers, then settle whatever they unblock.

## Report

Report when the frontier is empty and every sub-agent has reported. Open with one line naming the input and what it left open or got wrong, then one table of the decisions you settled, in the order you settled them:

| # | Question | Decision |

Follow it with a second table, same columns, of the one-way doors the user answered. Each decision appears in exactly one table. Then stop: as in grilling, nothing is acted on until the user confirms.
