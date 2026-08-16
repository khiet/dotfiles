---
name: explain-diff-html
description: Use when the user asks for a rich explanation of a code change, diff, branch, or PR. Produces HTML output.
---

# Explain Diff

Create a clear, interactive explanation of the requested code change.

## Sections

Include these sections:

- **Background:** Explore the surrounding code and explain the existing system. Start with enough context for a beginner, then focus on the parts that matter to this change. Make the beginner material easy for experienced readers to skip.
- **Intuition:** Explain the main idea behind the change without covering every detail. Use small, concrete examples with sample data. Add figures and diagrams where they make the idea easier to understand.
- **Code:** Give a high-level walkthrough of the code changes. Group and order them so the reader can follow the change as a whole.
- **Quiz:** Write five medium-difficulty multiple-choice questions. Test real understanding of the change, not trivia or gotchas. When the reader chooses an answer, show whether it is correct and explain why.

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
- Use one long page with section headings and a table of contents. Do not use tabs for the main page structure.
- Add responsive styles so the page works on a phone.
- Save the file outside the repository in `$HOME/Desktop`.
- Name it `<unix_timestamp>_<branch_name>.html`. Use the current Unix epoch time and replace `/` in the current Git branch name with `-`. Example: `$HOME/Desktop/1720915200_main.html`.

## Writing Style

- Use easy-to-read, plain English with a clear flow.
- Keep the explanation engaging, but choose clarity over elegance.
- Use smooth transitions between sections.
- Prefer literal language over metaphors. Write "the existing code," not "the machine the change slots into."
- Explain with examples, not only abstract descriptions. When a change affects data, show a table of example rows, such as input and output before and after the change, so the reader can see the effect concretely.
- Rewrite any sentence that needs a second read.

## Diagrams and Callouts

- Reuse a small number of diagram styles throughout the page.
- For a UI change, show a simple version of the interface the user sees.
- For a system change, show how data moves between components and include example data.
- Build diagrams with HTML and CSS. Do not use ASCII diagrams.
- Use HTML lists for lists.
- Put code blocks in `<pre>` elements so they keep their line breaks and indentation. If a code block uses a `<div>`, set `white-space: pre-wrap`.
- Check every code block before saving the file.
- Use callouts for key ideas, definitions, and important edge cases.

## Annotations

- Let readers highlight selected text in four colors, add a note to a highlight, and review all highlights and notes in a slide-out drawer.
- Make each drawer entry jump to its highlight when clicked.
- Keep annotations across reloads with `localStorage`.
- Use the module from `annotation-module.md` exactly as written. Do not replace it with a new implementation.
- Place the module's CSS just before `</style>`, after the accent-color rules.
- Place the module's `<script>` last, just before `</body>`.
- Set `data-annot-doc-id` on `<body>` to the filename without `.html`: `<unix_timestamp>_<branch_name>`. This keeps highlights tied to the document even if the file is renamed.
- The module anchors highlights by character position, so text changes after page load can break them. Add `data-no-annotate` to every element whose text changes at runtime. This includes the Quiz wrapper and any collapsible content added at runtime.
- Do not add `data-no-annotate` to static Background, Intuition, or Code text. The module already excludes its own interface, `<script>`, and `<style>`.
