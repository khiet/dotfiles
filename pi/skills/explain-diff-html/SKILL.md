---
name: explain-diff-html
description: Use when the user wants a deeper HTML walkthrough of a PR after reading its body. For findings-focused reviews, use code-review.
---

# Explain Diff

Produce one self-contained HTML walkthrough that zooms in on a PR body written with the `pr` skill. The reader has just read that body, so the walkthrough treats each of its statements as a claim, checks it against the code, and explains the mechanism behind it. Every important statement carries a locator, and executed verification stays separate from what was read or inferred.

## 1. Gather evidence

Fetch the PR for the current branch, or the one the user names: `gh pr view [<number>] --json body,headRefName,baseRefOid,headRefOid`. Continue once the body has all three `pr` headings (`## Summary`, `## Evidence`, `## Merge Danger`); otherwise stop and report that no PR exists or which headings are missing.

Collect claims, keeping each one's provenance:

- **Summary**: each structural claim its view makes, such as a new call, a moved file, or a new branch in control flow.
- **Evidence**: each before/after, with the test or output cited for it.
- **Merge Danger**: the stated Door and the stated Blast Radius, as two claims.
- **Commit messages**: secondary claims.

Diff from the merge-base of `baseRefOid` and `headRefOid`, which stays correct after the PR merges. Read the callers and tests of every changed function, and list the consumers of every changed contract. Check contracts and invariants against their preconditions and failure boundaries, including tenant or organization scope where relevant.

Record the test delta as added, changed, removed, or skipped; with no test changes, say so. Give every test and every other verification one status: "Read, not run", "Executed: command, result" for runs you observed, or "Not checked". Attribute runs reported by others, including those in the PR body's Evidence, to their source.

Done when every claim is located in the diff or marked `missing`, every changed file is classified behavioral or mechanical, every behavioral change has a claim or is marked `undescribed`, and every changed contract has its consumers listed.

## 2. Choose the narrative

Pick one representative input that the Summary's view touches, with the starting state needed to determine its old and new outcomes. Arrange the causal steps in dependency order, each pairing a code change with its behavioral consequence, and flag the decisive step. Fold mechanical changes into one line and name any omitted scope.

Done when the example's old and new outcomes follow from its starting state, and every behavioral change sits in a causal step or is named as omitted scope.

## 3. Write the walkthrough

Under the `<h1>`, start with the verdict sentence: does the code do what the PR body claims? Name the largest divergence, if any. Follow it with the one invariant the change must keep ("Must remain true"), grounded in a requirement or code and qualified by its preconditions.

Then three sections that mirror the PR body, followed by the Scope check. For each visual, read the `pr` skill's Summary forms and pick the smallest view that makes the point, rendered as text or inline SVG.

- **Summary: how it works.** Zoom in on the PR's Summary view: trace the representative input through the old and new paths and show what the view leaves out. If the view shows `save -> invalidate cache`, name the cache entry, why invalidation happens there, and what the next read observes. Give each causal step a heading that names its purpose ("Reject expired tokens before lookup"). Excerpts follow **Code excerpts**.
- **Evidence: why the outcomes follow.** For each before/after in the PR body: why the new outcome follows from the code, what the cited test establishes, and its status. Then the rest of the test delta and what remains unverified.
- **Merge Danger: how it could fail.** State whether the Door and Blast Radius hold, citing the code that decides it, for example a two-way door claimed over a migration that drops a column. Then the concrete failure modes, the affected consumers, and what rollback entails.
- **Scope check**, inside a closed `<details>`: a table with columns Claim, Where, Verdict. One row per independently checkable claim and one per undescribed change; a removed or renamed externally consumed contract, including a public endpoint, gets its own row. Where is a locator, or `not in diff` for missing implementation. Verdict is exactly `done`, `partial`, `missing`, or `undescribed` (claimed by neither the PR body nor commits: a documentation gap, not a code-quality judgment). With no claims and nothing undescribed, one sentence replaces the table.

Carry every `partial`, `missing`, or behavioral `undescribed` row into the section above where it matters, so the main reading path shows each contradiction and risk.

When the change has a surprising behavior or invites a misconception, add an understanding check following [`questions.md`](questions.md).

Done when each mirrored section zooms in on its PR counterpart, the verdict sentence agrees with the Scope check, and every material Scope row also appears above the `<details>`.

## 4. Save and check

Write to `$HOME/Desktop/<headRefName>_<unix_timestamp>.html`, with `/` replaced by `-`. Then check:

- Every locator resolves, per **Locators**.
- Every "Verbatim" segment matches, per **Code excerpts**.
- Every verdict is one of the four allowed values.
- Source-derived strings are HTML-escaped.
- The page renders at desktop width and 320px: code line spacing, table and code overflow, and print reveals.

In the delivery summary, not the page, report which checks were automated and which manual, and any unavailable check as unverified.

Done when the checks pass, the page meets **Theme** and **Format**, and the Scope check, risks, and test delta match step 1's evidence.

## 5. Narrate

After the page's final edit, run the skill's `narrate.sh` on it; rerun whenever the page changes later:

```sh
<skill-dir>/narrate.sh "$page"
```

It speaks the page's visible text with clipboard-tts, then embeds `player.html` under the `<h1>`.

Done when the delivery summary reports the script's outcome: the audio length, or its error.

## Locators

A locator is a complete repository-relative `path:symbol`, used in every Where cell even when cited earlier. A symbol is a named declaration in the cited file: a function, class, method, constant, type, or schema model, qualified by its owning scope when needed. For behavior at a call site or expression, cite the enclosing declaration and optionally a line range; for a callee's implementation, cite its own declaration. For tests, use the full path and the exact test or suite title, with enough context to distinguish repeats. For files without named declarations, such as Markdown or config, use the full path and a precise key, section heading, or line range. Cite the base revision for removals.

Check each locator against its cited revision with a language-aware parser where available, otherwise by reading the cited lines at that revision. A string match is only a candidate location.

## Code excerpts

Prefer short final-code excerpts; show a labeled before excerpt when a removal matters. Mark lines with gutter characters (`+` added, `~` modified, `-` removed) and wrap decisive tokens, not entire lines, in `<mark>`. Label source-exact segments "Verbatim", with omissions explicit; label rewritten or condensed code "Illustrative" or "Adapted". Keep each annotation beside the lines it explains.

Check each "Verbatim" segment against its cited revision after stripping presentation markup and gutter characters, accounting for explicit omissions.

## Writing style

Follow the `pr` skill's prose rules: skip preambles, keep prose brief, and use `GLOSSARY.md` terms when the repo has one. Put the conclusion first in every section. Distinguish claimed intent, code-derived inference, and executed verification. Define unfamiliar domain terms, abbreviations, and component roles on first use. For an unfamiliar mechanism, use a concrete example or one brief analogy mapped back to the real components, stating its important limitation when needed.

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

- Foreground for prose, Muted for secondary text and code comments, Purple for major headings, Cyan for links. Comment is decorative only: rules, line numbers, borders. It fails text contrast.
- Current Line for code blocks and the few surfaces that earn one: the verdict and callouts. Flat sections with spacing elsewhere. Inside a surface, text is Foreground, Cyan, Green, or Yellow.
- Green added, Orange modified, Red removed, always paired with the gutter character or a "Before"/"After" label so color is never the only channel. Red for warning borders.

## Format

- `<!DOCTYPE html>`, complete `<head>` with `<meta charset="utf-8">` first, all CSS, JavaScript, and audio inline, no external resources.
- Body text 17px, line-height 1.55, one column of 65-75ch. Code 14px in `ui-monospace, "Cascadia Code", Menlo, Consolas, monospace`. Use one code line-break strategy: block-level line spans with no inter-span text newlines, or inline spans separated by literal newlines, so each source line renders once.
- Reading and answers work without JavaScript: native `<details>` for reveals, visible keyboard focus.
- Reflows at 320px; tables and code scroll inside their own region.
- Print: white background, black text, gray borders (the only colors outside the Theme block), decorative surfaces removed, every `<details>` opened on `beforeprint`.
- Honor `prefers-reduced-motion`.
