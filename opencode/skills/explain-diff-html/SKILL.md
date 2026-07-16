---
name: explain-diff-html
description: Use when the user asks for a rich explanation of a code change, diff, branch, or PR. Produces HTML output.
---

# Explain Diff

Please make me a rich, interactive explanation of the specified code change.

It should have these sections:

- Background: Explain the existing system relevant to this change. (You should broadly explore surrounding code for this.) We don't know how much the reader already knows, so include a deep background for beginners (note that it can be skipped if the reader is already familiar), and then a more narrow background directly relevant to the change.
- Intuition: Explain the core intuition for the code change. The focus here is to explain the essence, not the full details. Use concrete examples with toy data. Use figures and diagrams liberally.
- Code: Do a high-level walkthrough of the changes to the code. Group/order the changes in an understandable way.
- Quiz: Come up with five questions that test the reader's knowledge of this PR. This should be medium difficulty, difficult enough that you actually need to understand the substance of the PR to answer them, but not gotchas. The goal is to help the reader make sure that they've actually understood. These should be presented as interactive multiple-choice questions, and when the user clicks, it tells them whether they were correct and gives feedback.

Theme:

- Style the page with the Dracula Classic (dark) palette. Copy this `:root` block into the page's `<style>` and use the variables throughout. Do not hardcode ad hoc colors elsewhere, and to retheme edit only this block.

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
- Use Background for the page, Foreground for body text, and Comment for muted/secondary text. Reserve Current Line/Selection for surfaces like cards, callouts, code-block backgrounds, and borders. Draw on the accent hues (Cyan, Green, Purple, Pink, Orange, Yellow) for headings, links, diagram elements, and syntax highlighting, using Red for warnings or errors. Keep contrast readable against the dark background.

Format:

- Output a single self-contained HTML file which includes CSS and JavaScript. Start it with `<!DOCTYPE html>` and a proper `<html><head>` that includes `<meta charset="utf-8">` as the first element in the `<head>`. This is required: the file uses non-ASCII characters (emoji, arrows, box-drawing) and, without the charset declaration, a browser opening the local `file://` page falls back to a legacy encoding and renders them as mojibake (e.g. `→` becomes `â†’`, `🔤` becomes `ðŸ”¤`). Make the whole thing one long page with section headers and a table of contents. Don't use tabs for the top-level structure. Basic responsive styling so you can view it on a phone is nice too. Save the file in `$HOME/Desktop` (outside the code repo) named `<branch_name>_<unix_timestamp>.html`, where `branch_name` is the current git branch with any `/` replaced by `-` and `unix_timestamp` is the current Unix epoch seconds. For example: `$HOME/Desktop/main_1720915200.html`.
- Please write with the clarity and flow of Martin Kleppmann, making it engaging and written in classic style. Transitions between sections should be smooth.
- Some tips on diagrams. Ideally, you should pick a small number of diagram families that can be reused throughout the explanation to explain various cases. Some useful kinds of diagrams:
  - A very simplified version of the UI that the user sees in the app, to explain UI changes.
  - A system diagram showing data flow or communication between components. Make sure to include example data here!
- Don't use ASCII diagrams. Always use simple HTML designs for your diagrams, HTML lists for lists of things, etc.
  - For code blocks, always use `<pre>` tags. If you use a custom styled div instead, it **must** have
    `white-space: pre-wrap` in its CSS, or the browser will collapse all newlines into a single line.
    Before saving the file, scan each code block in the HTML source and confirm its CSS includes
    `white-space: pre` or `pre-wrap`.
- Use callouts for key concepts or definitions, important edge cases, etc.
