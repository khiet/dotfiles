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

Audio narration:

- Add a Medium-style audio player near the top of the page that narrates a spoken walkthrough of the explanation. Copy the widget verbatim from `player-template.html` (the three parts: styles, markup, script) so every generated page's player is identical; fill in only the `<audio src>` with the base64 data URI.
- The narration is a real pre-generated audio file, embedded directly in the HTML as a base64 `data:` URI (e.g. `<audio src="data:audio/mp4;base64,...">`) so the file stays fully self-contained. Do not link to an external audio file or a network URL.
- Produce the audio at skill-run time with these steps:
  1. Build the narration script from the page's own prose: read out the Background, Intuition, and Code sections as written. Skip the quiz and elements that don't speak (code blocks, diagrams, the table of contents); where a code block or diagram is central, replace it with a one-line spoken description of what it shows. Do not compose a separate summary.
  2. Synthesize it with the macOS built-in `say` command: `say -v Ava -o narration.aiff -f narration.txt`.
  3. Convert to a compact format before embedding: `afconvert narration.aiff narration.m4a -f m4af -d aac`. This keeps the base64 payload small.
  4. Base64-encode the `.m4a` and inline it into the `<audio>` element's `src` with the `audio/mp4` MIME type.
- If synthesis genuinely fails, omit the player rather than embedding a broken one, and note in your summary that audio was skipped and why.

Theme:

- Style the page with the Dracula Classic (dark) palette. The palette lives as CSS custom properties in the `:root` block of `player-template.html` (part 1); copy that block into the page's `<style>` and use the variables throughout. Do not hardcode ad hoc colors elsewhere, and to retheme edit only that `:root` block.
- Use Background for the page, Foreground for body text, and Comment for muted/secondary text. Reserve Current Line/Selection for surfaces like cards, callouts, code-block backgrounds, and borders. Draw on the accent hues (Cyan, Green, Purple, Pink, Orange, Yellow) for headings, links, diagram elements, and syntax highlighting, using Red for warnings or errors. Keep contrast readable against the dark background.

Format:

- Output a single self-contained HTML file which includes CSS and JavaScript. Make the whole thing one long page with section headers and a table of contents. Don't use tabs for the top-level structure. Basic responsive styling so you can view it on a phone is nice too. Save the file in `$HOME/Desktop` (outside the code repo) named `<branch_name>_<unix_timestamp>.html`, where `branch_name` is the current git branch with any `/` replaced by `-` and `unix_timestamp` is the current Unix epoch seconds. For example: `$HOME/Desktop/main_1720915200.html`.
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
