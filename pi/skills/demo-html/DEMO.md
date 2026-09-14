# Demo page

Rules for the page `SKILL.md` builds: the product's look with the feature added, plus one DEMO bar.

## Sources

- **Tokens**: the style probe from step 4 wins for the elements it measured; files fill the rest, first hit wins, and the source is recorded: `tailwind.config.*` theme; CSS custom properties in a global stylesheet (`globals.css`, `app.css`, `variables.css`, `theme.*`); a theme object (`theme.ts`, `createTheme`); the component library's defaults. Colors, font families and sizes, weights, radii, spacing, shadows.
- **Mock data** comes from fixtures, first hit per entity type: seed scripts (`seed*`, `db/seeds`, `prisma/seed*`), e2e fixtures (`e2e/fixtures`, `playwright/fixtures`, `cypress/fixtures`), test factories (`factories`, `__fixtures__`), stories. Each record in the demo is a fixture record verbatim: names, emails, dates, statuses, counts. A live snapshot supplies formatting, ordering, and truncation, with the provenance row saying so; the page is shared, so its records and any documented credentials stay out of it. Users offered by "Viewing as" are fixture users only.
- **Vocabulary**: the product's terms from the live snapshots win over the description's wording. Every replacement is a term mapping in the report.

## Structure

- A complete HTML document: doctype, `html`, `head` with charset, viewport, `<title>`, and `<style>`, then `body`. Set `body` font family, size, color, and background explicitly, since the Artifact host applies its own reset (14px system on off-white) to an unstyled body.
- One look, the product's. `color-scheme` set to match it. A dark variant the product lacks is noise.
- Fonts: a `fonts.googleapis.com` link only when that is the product's own font source. Otherwise the product's family name leads the stack with a system fallback, recorded as a fidelity gap.
- Vanilla HTML, CSS, and JavaScript in one file. No script or stylesheet from any host other than the font link.
- The product frame is one element, `<main id="product">`, holding the shell reproduced from the baseline (nav, header, layout) and the screens. Screen switching is in-page, driven by the shell's own nav.
- A `<script type="text/plain" id="demo-brief">` block holds the description, the mode, the provenance table, the term mappings, and the new bucket. A revision reads it back, so it stays current with the page.
- Reflows down to 400 px wide with a 16 px side gutter, which the Artifact host requires. The primary layout is the baseline viewport.

## DEMO bar

- Fixed at the bottom, outside `#product`, labelled `DEMO`, in one color absent from the product's tokens so it reads as foreign at a glance.
- Always: `Reset`, which restores the initial state.
- `Viewing as`, when the feature involves more than one user: a select of the fixture users. Switching re-renders `#product` as that user, and what one user did is visible to the next (a message A sent is in B's inbox).
- Scenario picker, when the description names states: empty, error, loading, many items. Each scenario is a distinct initial state built from fixtures.
- `Highlight what's new`: a toggle that outlines every element carrying `data-new`. Every element the feature adds carries `data-new`, down to the label level, so the outline shows exactly the proposal.

## State

- In memory only; a reload resets. Initial state is the fixture data.
- Every action the description names works end to end: forms validate with the product's own validation copy, lists update, counts change, the other user sees the effect.

## Label audit

Every visible string inside `#product` is in exactly one bucket:

- **product**: appears in a live snapshot or a fixture file.
- **new**: an ancestor carries `data-new`, and the string traces to the description or to a new screen.

Collect with `browser_evaluate`, once per state: walk the elements under `#product`, skip hidden ones, and emit each trimmed text node plus each `placeholder`, `aria-label`, `title`, and button or input `value`, with whether it sits under `data-new`. A state is each screen, each scenario, and each "Viewing as" user, since a string can be visible in one state only. Match the strings without `data-new` against the live snapshots and fixture files. A string in neither bucket is a defect: replace it with the product term, or mark `data-new` when the feature genuinely introduces it. The DEMO bar is outside the audit.
