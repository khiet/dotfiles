---
name: explain-diff-html
description: Use when the user asks for a rich explanation or HTML walkthrough of a code change, diff, branch, or PR. Produces a checkable HTML page; use code-review for findings-focused reviews.
---

# Explain Diff

Produce one self-contained HTML page that lets an engineer understand a change and check it, not just feel confident about it. The page is checkable: every important claim points at code, and what was verified is separated from what was inferred.

## 1. Gather evidence

Compare against `main` unless the user names a base. Collect **claims** from PR or issue descriptions and commit messages, keeping their provenance separate from diff-only observations. Read the callers and tests of every changed function. Check contracts and invariants against their preconditions and failure boundaries, including tenant or organization scope where relevant; compare material risks with the proposed central guarantee.

Record the test delta as added, changed, removed, or skipped, with status: "Read, not run", "Executed: command, result", or "Not checked". Reserve "Executed" for observed runs, recording the actual commands and results; attribute runs reported by others to their source.

Done when every claim is located in the diff or marked missing, every changed file is classified behavioral or mechanical, and every behavioral change has claim provenance or a diff-only label and an evidence locator. The risks and test delta are accounted for, and the proposed guarantee holds within its stated boundaries.

## 2. Choose the narrative

Infer the reader's familiarity and goal from context: reviewing the change or learning the mechanism. Default to an engineer familiar with the codebase but unfamiliar with this change. Ask only when uncertainty would materially change the explanation.

Pick the shortest story that is honest:

- The behavior contract: what changes, why, and what must remain true. Mark intent as inferred when no claim states it.
- One representative input, with the starting state needed to determine its old and new outcomes, traced through the mechanism.
- Causal steps, each pairing a code change with its behavioral consequence. Lead with the key consequence, then explain dependent steps in execution or dependency order and flag the decisive step. Order independent changes by importance.
- The material risks and test delta gathered above, and what stays unverified.

Fold mechanical changes into one line. Name any omitted scope explicitly.

Done when the outline identifies the audience and goal, accounts for every behavioral change or names it as omitted scope, and the example's outcomes follow from its stated starting state.

## 3. Write the page

Aim for roughly 500-800 words when warranted; simple changes should be shorter. Let necessary reasoning determine length and step count. Default visual ceilings: 1 diagram, 1 example table, 2 code excerpts, 3 callouts. Add only what earns its space. A visual replaces redundant description while retaining the caption or explanation needed to interpret it.

Sections, in order:

- **What changes**: the behavior contract. Omit any metadata line (PR or issue number, branch, SHAs, diff stats); the reader already knows which change they opened. Lead with one central invariant in the "Must remain true" sentence, grounded in a requirement or code and supported by a concrete reference elsewhere on the page; explain secondary guarantees in their relevant causal steps. Mark inferred intent and qualify the contract and invariant with their necessary preconditions. Keep any central caveat or missing requirement beside them; explain its failure mode later in **Check before trusting** rather than repeat the full explanation. Define unfamiliar domain and API terms, abbreviations, and component roles on first use; include only prerequisites this reader needs.
- **Before / after**: the representative input with old and new outcome, linked to the responsible code and a covering test when one exists; identify coverage gaps. A table for data, a small interface sketch for UI. A diagram only when relationships read better drawn than tabulated.
- **Why it works**: the causal steps, each under a heading that names its purpose ("Reject expired tokens before lookup"). Carry the representative input through each relevant transition to its final outcome; explain independent changes separately. Let the example replace generic explanation rather than repeat it. Prefer short final-code excerpts; show a labeled before excerpt when a removal matters. Use gutter markers (`+` added, `~` modified, `-` removed) and `<mark>` on decisive tokens, not entire added lines. Label source-exact segments "Verbatim", with omissions explicit; label rewritten or condensed code "Illustrative" or "Adapted". Keep each annotation beside the lines it explains.
- **Scope check**: a table with one row per independently verifiable claim and one per undescribed change; group related undescribed changes only when the row remains checkable. Give each removed or renamed externally consumed contract, including a public endpoint, its own row. Columns: Claim, Where, Verdict. Every Where cell uses a complete repository-relative `path:symbol` or the test/artifact locator defined here, even if cited earlier; cite the base revision for removals and use `not in diff` for missing implementation. A symbol is a named declaration in the cited file: a function, class, method, constant, type, or schema model. Qualify members with their owning scope when needed. For behavior at a call site or expression, cite the enclosing declaration and optionally a line range; for the callee's implementation, cite its own declaration. For tests, use the full path and an exact test or suite title, with enough context to distinguish repeats. For artifacts without a named declaration, use the full path and a precise key, section, or line range. For stated claims, Verdict is exactly `done` (fully implemented), `partial` (partly implemented), or `missing` (absent), based on implementation evidence. Use `undescribed` for changes claimed by neither the PR/issue nor commits, including removals: a documentation gap, not a code-quality judgment. Place qualifications and claim provenance in the claim or adjacent explanation. With no claims and nothing undescribed, one sentence replaces the table.
- **Check before trusting**: a visible list of the material risks, the test delta with its status wording, and what remains unverified.
- **Check your understanding**: optional; select questions using the rules below.

### Questions

Choose a question only when it serves the reader's goal:

- **Learning or transfer**: use a final prediction on a fresh input or boundary case. Keep the question visible outside the answer's `<details>`; reveal only the answer, causal explanation, and `path:symbol` grounding inside it so the reader can attempt it first.
- **A surprising behavior or meaningful misconception**: optionally place one short prediction before **Why it works** and resolve it explicitly within that section. Choose early prediction, final application, or both only when each serves a distinct purpose.
- **Review-focused output**: omit the understanding check or collapse the entire section, with any answer separately revealed. Omit questions for trivial changes.

Use free response unless multiple-choice alternatives expose meaningful misconceptions.

Done when the applicable sections follow the order above and every included example or question has an explained outcome.

## 4. Save and check

Write to `$HOME/Desktop/<branch_name>_<unix_timestamp>.html`, with `/` in the branch name replaced by `-`. Automate checks of scope verdicts and locator shape, and question/answer structure against section 3. Verify every locator's declaration, test title, or artifact anchor against its cited revision using **Scope check**'s definition. A string match is only a candidate location. Use a language-aware parser where available; otherwise inspect the enclosing source. Report which validation was automated versus manual. Automate comparison of each "Verbatim" segment with its cited revision after stripping presentation markup and gutter markers, accounting for explicit omissions. Source checks aid review rather than prove behavioral correctness. Reconcile scope verdicts, material risks, and the test delta and execution status with section 1's evidence.

Count whitespace-separated words in reader-facing text, preserving block and table-cell boundaries. Include headings, table text, captions, and disclosed questions/answers, even inside initially closed `<details>`. Exclude code blocks and source-locator text; retain inline explanatory code and execution commands. Near 1,200 words, review for trimming rather than cut necessary reasoning over minor tokenization differences. Above 1,200 words, remove repetition before cutting necessary reasoning; if the page still exceeds 1,200 words, explain in the delivery summary which reasoning or scope requires the length. Render at desktop and 320px and inspect code line spacing, table/code overflow, and print reveals.

Done when the evidence checks pass, rendered behavior meets the Theme and Format requirements below, and source-derived strings are HTML-escaped. Report any unavailable checks as unverified.

## 5. Narrate

After the page's final edit, run the skill's `narrate.sh` on it; rerun whenever the page changes later:

```sh
<skill-dir>/narrate.sh "$page"
```

It speaks the page's visible text with clipboard-tts, then embeds `player.html` under the `<h1>`.

Done when the delivery summary reports the script's outcome: the audio length, or its error.

## Writing style

Plain English, conclusion first in every section. Short, true, non-obvious sentences. Prefer literal language. Distinguish intended behavior, code-derived inference, and executed verification. For an unfamiliar mechanism, use a concrete example or one brief analogy mapped back to the real components, stating its important limitation when needed. Rewrite any sentence that needs a second read.

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
- Current Line for code blocks and the few surfaces that earn one: the before/after example and callouts. Flat sections with spacing elsewhere. Inside a surface, text is Foreground, Cyan, Green, or Yellow.
- Green added, Orange modified, Red removed, always paired with the gutter character or a "Before"/"After" label so color is never the only channel. Red for warning borders.

## Format

- `<!DOCTYPE html>`, complete `<head>` with `<meta charset="utf-8">` first, all CSS, JavaScript, and audio inline, no external resources.
- Body text 17px, line-height 1.55, one column of 65-75ch. Code 14px in `ui-monospace, "Cascadia Code", Menlo, Consolas, monospace`. Use one code line-break strategy: block-level line spans with no inter-span text newlines, or inline spans separated by literal newlines, so each source line renders once.
- Reading and answers work without JavaScript: native `<details>` for reveals, visible keyboard focus.
- Reflows at 320px; tables and code scroll inside their own region.
- Print: light palette, decorative surfaces removed, every `<details>` opened on `beforeprint`.
- Honor `prefers-reduced-motion`.
