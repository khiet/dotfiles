---
name: explain-diff-html
description: Use when the user asks for a rich explanation of a code change, diff, branch, or PR. Produces HTML output.
---

# Explain Diff

Create a clear, interactive explanation of the requested code change.

## Scope and Length

Optimize for a concise explanation, not exhaustive documentation. Do not try to achieve exhaustive coverage; the goal is understanding.

- Target 800-1,200 words of prose, excluding code snippets. Never exceed 1,200 words unless the user explicitly asks for more detail.
- Aim for roughly 1-2 printed pages of substantive content.
- Prefer omission over completeness. Explain only what is necessary to understand the change.
- Explain only the surrounding code needed to understand this change.
- Assume the reader understands general software engineering concepts.
- Do not walk through every changed file, function, or line.
- Include at most: 1 background example, 1 diagram, 1 example-data table, 2 short code snippets, and 3 callouts.
- Visuals must replace explanation, not repeat it.
- If the change is straightforward, make the page shorter rather than filling the available budget.

## Content Priority

When deciding what to include, prioritize:

1. Why the change exists.
2. The core before/after behavior.
3. The most important implementation decision.
4. One non-obvious edge case, if there is one.

Omit incidental refactors, boilerplate, mechanical changes, and unchanged surrounding architecture unless they are necessary to understand the above.

## Sections

Include these sections:

- **Background:** Give only the minimum surrounding context needed to understand the change. Assume the reader is a software engineer but may be unfamiliar with this part of the codebase. Do not explain general programming concepts unless they are essential to this change.
- **Intuition:** Explain the central idea in a few paragraphs. Use one concrete example with sample data if useful. Add a diagram only when it communicates something more clearly than prose.
- **Code:** Explain the change as 2-4 logical steps. Focus on behavior and design decisions rather than walking through every edited file or line. Mention individual files only when knowing their role improves understanding.
- **Quiz:** Write three medium-difficulty multiple-choice questions covering the most important concepts in the change. Test real understanding, not trivia or gotchas. When the reader chooses an answer, show whether it is correct and explain why in 1-2 sentences.

## Theme

- Use the Dracula Classic dark palette. Copy this `:root` block into the page's `<style>`.

  ```css
  :root {
    --background: #282A36;
    --current-line: #44475A;
    --selection: #44475A;
    --foreground: #F8F8F2;
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
- Use these variables for every color so the page can be rethemed by editing only this block.
- Use Background for the page, Foreground for body text, and Comment for secondary text.
- Use Current Line and Selection for cards, callouts, code blocks, and borders.
- Use Cyan, Green, Purple, Pink, Orange, and Yellow for headings, links, diagrams, and syntax highlighting. Use Red for warnings and errors.
- Keep all text easy to read against the dark background.

## Format

- Output one self-contained HTML file with all CSS and JavaScript included.
- Start with `<!DOCTYPE html>` and a complete `<html><head>`.
- Make `<meta charset="utf-8">` the first element in `<head>`. The page may contain emoji, arrows, and box-drawing characters that display incorrectly without it when opened from `file://`.
- Use one long page with section headings. Do not use tabs for the main page structure.
- Include a compact table of contents only if the explanation has enough content to benefit from one.
- Add responsive styles so the page works on a phone.
- Save the file outside the repository in `$HOME/Desktop`.
- Name it `<unix_timestamp>_<branch_name>.html`. Use the current Unix epoch time and replace `/` in the current Git branch name with `-`. Example: `$HOME/Desktop/1720915200_main.html`.

## Writing Style

- Use easy-to-read, plain English with a clear flow.
- Keep the explanation engaging, but choose clarity over elegance.
- Use smooth transitions between sections.
- Prefer literal language over metaphors. Write "the existing code," not "the machine the change slots into."
- Explain with examples, not only abstract descriptions. When a change affects data, show one table of example rows, such as input and output before and after the change, so the reader can see the effect concretely.
- Rewrite any sentence that needs a second read.

## Diagrams and Callouts

- Use visual elements sparingly. Every diagram, table, or callout must replace prose rather than duplicate it.
- Reuse a small number of diagram styles throughout the page.
- For a UI change, show a simple version of the interface the user sees.
- For a system change, show how data moves between components and include example data.
- Build diagrams with HTML and CSS. Do not use ASCII diagrams.
- Use HTML lists for lists.
- Put code blocks in `<pre>` elements so they keep their line breaks and indentation. If a code block uses a `<div>`, set `white-space: pre-wrap`.
- Check every code block before saving the file.
- Use callouts only for key ideas, definitions, and important edge cases.
