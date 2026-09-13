---
name: explain-diff-html
description: Use when the user asks for a rich explanation of a code change, diff, branch, or PR. Produces HTML output.
---

# Explain Diff

Produce one self-contained HTML page that lets an engineer understand a change and check it, not just feel confident about it. The page is checkable: every important claim points at code, and what was verified is separated from what was inferred.

## 1. Gather evidence

Compare against `main` unless the user names a base. Collect the **claims**: commit messages plus the PR or issue description when one exists. Read the callers and tests of every changed function.

Done when every claim is located in the diff or marked missing, every changed file is classified behavioral or mechanical, and the test status is known: "Read, not run", "Executed: command, result", or "Not checked".

## 2. Choose the narrative

Pick the shortest story that is honest:

- The behavior contract: what changes, why, and what must remain true. Mark intent as inferred when no claim states it.
- One representative input with its old and new outcome.
- Two or three causal steps, each pairing a code change with its behavioral consequence, the most important first.
- The material risks: what else could break, tests added, changed, removed, or skipped, and what stays unverified.

Fold refactors, renames, formatting, and generated files into one line. When the change cannot fit the budget honestly, say what the page leaves out rather than hiding it.

## 3. Write the page

Prose budget 500-800 words, counting table text and questions with answers, excluding code and `path:symbol` references. A simple change is shorter; a complex one may use up to 1,200. Budget for visuals: 1 diagram, 1 example table, 2 code excerpts, 3 callouts. A visual replaces prose.

Sections, in order:

- **What changes** (60-100 words): the behavior contract, minimal background, and a metadata line naming the compared revisions and scope.
- **Scope check**: a table with one row per claim and one per unrequested change. Columns: Claim, Where (`path:symbol` or "not in diff"), Verdict (done, partial, missing, unrequested). With no claims and nothing unrequested, one sentence replaces the table.
- **Before / after** (120-180 words): the representative input with old and new outcome, linked to the responsible code and the test that covers it. A table for data, a small interface sketch for UI. A diagram only when relationships read better drawn than tabulated.
- **Why it works** (180-280 words): the causal steps, each under a heading that names its purpose ("Reject expired tokens before lookup"). Show final code, not a full unified diff: a short excerpt with a gutter marker per line (`+` added, `~` modified, `-` removed) and `<mark>` on the changed tokens. Label verbatim code and illustrative pseudocode as such. Keep each annotation beside the lines it explains.
- **Check before trusting**: a visible list of the material risks, the test delta with its status wording, and what remains unverified.
- **Check your understanding** (100-180 words with answers): one prediction question on a fresh input, plus a boundary or failure question when the change has one. Multiple choice with distractors drawn from real misconceptions. The answer and its `path:symbol` grounding sit in a `<details>` element.

## 4. Save and check

Write to `$HOME/Desktop/<unix_timestamp>_<branch_name>.html`, with `/` in the branch name replaced by `-`. Done when the prose count is within budget, every code block keeps its line breaks, every `path:symbol` exists at the compared revision, and every source-derived string is HTML-escaped.

## Writing style

Plain English, conclusion first in every section. Short, true, non-obvious sentences. Literal language: "the existing code", not "the machine the change slots into". Rewrite any sentence that needs a second read.

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

- `<!DOCTYPE html>`, complete `<head>` with `<meta charset="utf-8">` first, all CSS and JavaScript inline, no external resources.
- Body text 17px, line-height 1.55, one column of 65-75ch. Code 14px in `ui-monospace, "Cascadia Code", Menlo, Consolas, monospace`.
- Reading and answers work without JavaScript: native `<details>` for reveals, visible keyboard focus.
- Reflows at 320px; tables and code scroll inside their own region.
- Print: light palette, decorative surfaces removed, every `<details>` opened on `beforeprint`.
- Honor `prefers-reduced-motion`.
