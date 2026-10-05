# Walkthrough page

Shared rules for skills that write a self-contained HTML walkthrough of code. The calling skill decides the subject, the page's sections, and what they say; this file says how verification is graded, how the narrative is built, how the page opens, how statements are cited, how code is shown, how long the page runs, how it looks, and how it is checked and narrated.

## Verification

Check contracts and invariants against their preconditions and failure boundaries, including tenant or organization scope and any role that bypasses a guard, where relevant.

Give every test, every failure mode, and every other check the page reports, such as a CI job, a type check, or a manual run, exactly one status, in these words:

- "Executed: command, result": a run whose output you read, locally or in CI, at the granularity that output reports. For a CI run, the command is the one the job's step ran, followed by the job's locator.
- "Read, not run": the code or test was read at the cited revision.
- "Not checked": neither, including the behavior of code outside the repository and a CI job that was skipped.

Take the strongest status available for every test and check the page cites: run it when the checkout is at the cited revision and can run it, otherwise read the log of each job in each CI run on the cited commit, deploy runs and runs that ended cancelled or failed included. A failure mode takes the status of a cited test that exercises it, otherwise "Read, not run". A test exercises code only when its run reaches that code: one that mocks the code, or calls a sibling of it, leaves it "Read, not run". Split a statement whose parts differ in status, so each part carries its own; a list whose items share a status states it once, and a test carries its status where the page first cites it after the opening. Attribute runs you only have someone's word for, including those a PR body reports, to their source.

An absence is a statement too: "no test covers", "no caller", "nothing schedules", "only X does Y", or a count that claims to be complete, such as "two exceptions". Make it for exactly the set you searched, and name that set where the page states the finding in full.

## Narrative

The page follows one **representative input**: a single request or event, or the shortest sequence of them when the subject spans several, with the starting state needed to determine its outcome, the actor's role and permissions included. Its **causal steps** run in dependency order, each pairing code with its behavioral consequence. The **decisive step** is the one that settles the outcome: without it, the representative input ends differently.

Fold into one line a change's mechanical edits and a topic's paths that only repeat the traced one. Name whatever else the steps leave out as **omitted scope**.

On the page, each causal step sits under a heading that names its purpose ("Reject expired tokens before lookup"), and the representative input is carried through every step to its final outcome and the state it leaves behind. The section that holds the steps closes with the folded line and the omitted scope.

## Opening

Directly under the `<h1>`, before any section and with only the narration player between them, the opening statement gives the answer the calling skill asks for. Follow it with the one invariant the subject must keep ("Must remain true"): the one the decisive step enforces, grounded in a requirement or code and stated no wider than its guards enforce, with a locator for the guard on every code path that reaches the protected effect, found by listing that effect's callers. Qualify it by its preconditions: what must already hold for those guards to apply.

## Locators

Every statement about what code or a test does carries a locator in its own sentence, list item, or table row, citing the code that decides the whole statement; when two declarations decide it, cite both. A clause that refers to a finding stated in full elsewhere on the page, as the opening and a section's lead do, carries one of that finding's locators; a lead that summarizes the table, list, or causal steps under it relies on their locators. Within a causal step, a sentence that explains the step's excerpt shares the excerpt's locator, and a recap of what the step already cited, such as the state it leaves behind or why it is decisive, needs none. A locator inside a `<details>` serves only the text inside it.

A locator is a complete repository-relative `path:symbol`, marked up as `<code class="loc">` and written out in full every time, Scope check Where cells included. Append ` L10-20` for a line range. A locator cites the head of a change, or the commit a topic page describes. Append ` (base)`, after any line range, to cite the base revision instead: every statement about removed code, or about behavior before the change, carries one, while a statement that behavior is unchanged cites the head alone. A removed file is `path (base)`. A symbol is a named declaration in the cited file: a function, class, method, constant, type, or schema model, qualified by its owning scope when needed. For behavior at a call site or expression, cite the enclosing declaration and optionally a line range; for a callee's implementation, cite its own declaration. For tests, write `path:Suite > test title` with exact titles and enough context to distinguish repeats. Where no named declaration applies, as in Markdown, config, or a module-level statement, use the full path and a precise key, section heading, or line range; a CI job is its workflow file and job key.

Check each locator against its cited revision with a language-aware parser where available, otherwise by reading the cited lines at that revision. A string match is only a candidate location.

## Code excerpts

Prefer short final-code excerpts; show a labeled before excerpt when a removal matters. On a page about a change, mark lines with gutter characters: in a final excerpt, `+` for an added line and `~` for a line that replaces a removed one, pairing a hunk's removed and added lines in order so added lines beyond the removed count take `+`; in a before excerpt, `-` for every line the change removes or replaces. Lines that are unchanged, or changed only in whitespace, take a space. Wrap decisive tokens, not entire lines, in `<mark>`. Start each excerpt's label with one of three words, capitalized: "Verbatim" for a source-exact segment, with omissions explicit; "Illustrative" or "Adapted" for rewritten or condensed code, in which every value, such as a status code, a path, or a message, still comes from the cited code. Each label carries the locator of the code its excerpt shows or draws its values from. Keep each annotation beside the lines it explains.

Check each "Verbatim" segment against its cited revision after stripping presentation markup and gutter characters, accounting for explicit omissions.

## Writing style

Skip preambles and use `GLOSSARY.md` terms when the repo has one. Put the conclusion first in every section. Distinguish claimed intent, code-derived inference, and executed verification. Define unfamiliar domain terms, abbreviations, and component roles on first use. For an unfamiliar mechanism, use a concrete example or one brief analogy mapped back to the real components, stating its important limitation when needed.

## Length

The **reading path** is the text a browser renders at desktop width outside `<pre>` blocks, locators, `<details>` with their `<summary>`, and the narration player; inline code, captions, labels, and table cells count. Count whitespace-separated words in the browser's `innerText` once those elements are removed, skipping tokens with no letter or digit. It scales with the subject and stays under 1,500 words. To fit it:

- Give each causal step one excerpt, or one before/after pair when a removal matters.
- State each finding in full once, where it matters most, and refer to it in a clause elsewhere.
- When a list the calling skill requires in full outgrows the path, move rows into a closed `<details data-narrate="skip">` directly under the list, lowest priority first across every such list on the page, stopping once the path fits: a row that reports a divergence, a gap, or a needed change outranks one that simply holds, and among equals a row about code a causal step cites outranks one that is not. Title the fold for the rows it holds.

Spend the words on mechanism.

## Theme

Dracula Classic plus one accessibility token. Copy this block into `<style>` and take every color from it:

```css
:root {
  --background: #282A36;
  --current-line: #44475A;
  --selection: #44475A;
  --foreground: #F8F8F2;
  --muted: #B0B8D1;
  --comment: #6272A4;
  --red: #FF5555;
  --orange: #FFB86C;
  --yellow: #F1FA8C;
  --green: #50FA7B;
  --cyan: #8BE9FD;
  --purple: #BD93F9;
  --pink: #FF79C6;
}
```

- Foreground for prose, Muted for secondary text and for code comments on any line, added and removed included, Purple for major headings, Cyan for links. Comment is decorative only: rules, line numbers, borders. It fails text contrast.
- Current Line for code blocks and the few surfaces that earn one: the page's opening statement and callouts. Flat sections with spacing elsewhere. Inside the opening statement and callouts, text is Foreground, Cyan, Green, or Yellow.
- Green added, Orange modified, Red removed, always paired with the gutter character or a "Before"/"After" label so color is never the only channel. Red for warning borders.

## Format

- `<!DOCTYPE html>`, complete `<head>` with `<meta charset="utf-8">` first, all CSS and JavaScript inline, no external resources.
- Body text 17px, line-height 1.55, one column with a text measure of 65-75ch. Code 14px in `ui-monospace, "Cascadia Code", Menlo, Consolas, monospace`. Use one code line-break strategy: block-level line spans with no inter-span text newlines, or inline spans separated by literal newlines, so each source line renders once.
- Visuals are text or inline SVG, each the smallest view that makes its point: a table for data, a diagram only when relationships read better drawn than tabulated.
- Reading and answers work without JavaScript: native `<details>` for reveals, visible keyboard focus.
- On screen, reflows at 320px with no page-level horizontal scroll: code scrolls inside its own region, and a table keeps every column in view, stacking each row's cells under their column labels where the columns do not fit. Scope narrow-width rules to `@media screen` so print keeps the desktop layout.
- Print: white background, black text, generated content included, gray borders (the only colors outside the Theme block), code wrapped inside the page, decorative surfaces removed, every `<details>` opened on `beforeprint`.
- Honor `prefers-reduced-motion`.

## Checks

- Every statement about behavior carries a locator, per **Locators**.
- Every locator resolves, per **Locators**.
- Each sentence agrees with the code its locator cites: reread the two side by side, table rows and Illustrative or Adapted excerpts included.
- Every "Verbatim" segment matches, per **Code excerpts**.
- Every verdict in a Scope check, when the page has one, is one of the four in `change.md`.
- The reading path is under 1,500 words, counted per **Length**.
- What the page says about failure modes, test statuses, absences, and any Scope check matches the evidence gathered in the calling skill's step 1.
- Source-derived strings are HTML-escaped.
- The page meets **Theme** and **Format**.
- The page renders at desktop width and 320px in a headless browser: code line spacing, table and code overflow, print reveals, and print colors. Serve it over localhost where `file:` URLs are blocked, frame it in a 320px iframe because headless windows stay wider, dispatch `beforeprint` to test the reveals, and emulate print media to read the computed colors, pseudo-elements included, and to see that no code is cut off. Look at a screenshot of each width as well: a table column pushed out of view passes the overflow measurements. Keep screenshots and scratch files in a temporary directory outside every repository, the working directory's included.
- An independent audit, where the harness can dispatch a subagent. Once the checks above pass, hand a fresh subagent the page, the repository with its revisions, and the skill files, and keep your notes and conclusions out of the brief. Ask it for four kinds of finding, each with its evidence: a sentence whose locator's code does not decide the whole sentence, a statement about behavior with no locator, a status or an absence its own search contradicts, and an item missing from a list the calling skill requires in full. Check each finding against the code, fix the ones that hold, then rerun the checks above on the fixed page, the render check and its screenshots included.

In the delivery summary, not the page, report each check above as automated, manual, unverified with its reason, or not applicable.

Done when every check passes or is reported unverified with its reason.

## Narration

After the page's final edit, run `narrate.sh` from this file's directory on it; rerun whenever the page changes later:

```sh
<this-directory>/narrate.sh "$page"
```

It speaks the page's prose with clipboard-tts, which skips code blocks; the script also leaves out every `<details data-narrate="skip">` and shortens each `<code class="loc">` to its symbol. It then embeds `player.html` between the `<h1>` and the page's opening statement and changes nothing else, so the checks still stand. It can run past ten minutes, so run it in the background.

Done when the delivery summary reports the script's outcome: the audio length, or its error.
