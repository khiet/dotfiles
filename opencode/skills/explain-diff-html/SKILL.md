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

- Add a Medium-style audio player near the top of the page: a round play/pause button with a title like "Listen to this explanation", a running timecode, and a seek bar. It should narrate a spoken walkthrough of the explanation.
- The narration is a real pre-generated audio file, embedded directly in the HTML as a base64 `data:` URI (e.g. `<audio src="data:audio/mp4;base64,...">`) so the file stays fully self-contained. Do not link to an external audio file or a network URL.
- Produce the audio at skill-run time with these steps:
  1. Write a narration script: a curated, conversational walkthrough of the key ideas (Background essence, Intuition, and the most important Code changes). Do NOT read the page word-for-word or narrate the quiz. Aim for roughly 2-4 minutes so the embedded audio stays a reasonable size.
  2. Synthesize it to an audio file. Prefer a high-quality TTS API if the user has one configured (for example an OpenAI TTS call when `OPENAI_API_KEY` is set). Otherwise fall back to the macOS built-in `say` command, which needs no key: `say -v Ava -o /tmp/narration.aiff -f /tmp/narration.txt`.
  3. Convert to a compact, broadly supported format before embedding, e.g. `afconvert /tmp/narration.aiff /tmp/narration.m4a -f m4af -d aac` (or use `ffmpeg` to produce `.mp3`). This keeps the base64 payload small.
  4. Base64-encode the audio and inline it into the `<audio>` element's `src`. Verify the data URI's MIME type matches the encoded format (`audio/mp4` for m4a/AAC, `audio/mpeg` for mp3).
- Drive the player UI from the single `<audio>` element with JavaScript: toggle play/pause, update the timecode and seek bar from `timeupdate`, and allow seeking by clicking the bar. Keep it keyboard-accessible.
- If synthesis genuinely fails (no TTS available), omit the player rather than embedding a broken one, and note in your summary that audio was skipped and why.

Format:

- Output a single self-contained HTML file which includes CSS and JavaScript. Make the whole thing one long page with section headers and a table of contents. Don't use tabs for the top-level structure. Basic responsive styling so you can view it on a phone is nice too. Put the file in a global place on my computer outside of the code repo, and make sure the filename always starts with today's date in `YYYY-MM-DD-` format, because it helps keep the files time-sorted and out of version control. For example: /tmp/2026-01-12-explanation-<slug>.html
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
