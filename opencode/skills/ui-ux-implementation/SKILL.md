---
name: ui-ux-implementation
description: Implement and refine UI/UX from reference artifacts (Figma, screenshots, specs) with usability best practices, design-system enforcement, and maintainable code. Subsumes design-system-enforcement.
compatibility: opencode
metadata:
  audience: frontend-engineers
  focus: usability-consistency-and-reuse
  additive: true
---

## Scope

UI/UX tasks: implementing or updating interfaces from reference artifacts (Figma, screenshots, product examples, specs), including interaction design, layout, forms, copy, accessibility, and visual polish.

## Principles

- **Usability over novelty.** Clarity and predictability beat visual flair.
- **Reuse first.** Use existing components, variants, tokens, spacing/typography scales, and interaction patterns before creating anything new.
- **No unauthorized expansion.** Do NOT introduce new colors, component families, grid systems, icon sets, animation systems, or utility frameworks unless explicitly requested.
- **Maintainability over perfection.** Prefer readable, testable code over pixel-perfect but complex implementations.
- **Small diffs.** Identify the smallest change set that achieves the goal.

## Best-Practice Baseline

Practical checklist for decisions:
- **Nielsen Norman heuristics**: visibility of system status, match with real world, consistency, error prevention, recognition over recall.
- **WCAG 2.2 AA**: keyboard support, focus visibility, contrast, semantics, labels, error messaging.
- **GOV.UK / USWDS style**: plain language, predictable interactions, robust forms.

> If best-practice guidance conflicts with repository conventions, prefer repository conventions.

## Workflow

1. Audit existing UI patterns before changing anything.
2. Extract structure, spacing intent, interaction states, and behavior from the reference artifact.
3. Map requirements to existing tokens and component variants.
4. Implement with semantic HTML and accessible states using existing primitives and naming conventions.
5. Add new UI primitives only when no acceptable option exists AND the user explicitly approves; document why.
6. Verify desktop and mobile behavior.
7. Verify keyboard navigation, focus states, and screen-reader paths for changed controls.

## Implementation Rules

- Keep naming consistent with nearby files and components.
- Prefer composition over new abstraction layers.
- Avoid one-off styling values when a token or utility already exists.
- Keep conditional rendering straightforward and easy to scan.
- Keep component props and state shape aligned with nearby patterns.
- Ensure empty, loading, success, and error states remain understandable.
- Avoid surprise interactions; use familiar patterns already in the app.

## Quality Bar

Before finishing, confirm:
- Existing design-system components and tokens were reused wherever possible.
- No unauthorized visual-system expansion occurred.
- Accessibility and usability improved or stayed neutral for all modified flows.
- The code is simpler or equally simple compared with the prior state.

## Reporting

Briefly include:
- What usability problem was addressed.
- Which existing patterns/components were reused.
- Any tradeoffs made for maintainability.
- How desktop/mobile and accessibility behavior were validated.
