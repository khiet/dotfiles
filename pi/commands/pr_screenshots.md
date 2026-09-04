---
description: Attach screenshots of this change's UI to the PR description as a two-column table, reusing Playwright captures when they exist
---

# PR Screenshots

Fill the `Visuals` slot of the current PR description with screenshots of the UI this branch changes. Only the new UI is shown - no before/after pairing.

Usage: `/pr_screenshots [url-or-route ...]`

The argument is the page (or pages) to capture when no usable screenshot exists. Omit it when the recent Playwright session already produced captures.

## Rules

- **Reuse before capture.** If screenshots from the recent Playwright session exist, use them as-is. Do not recapture, recrop, or resize a usable asset.
- **Warn on existing screenshots.** If the PR body already contains images (`![`, `<img`, or a `github.com/user-attachments` URL), stop and show which ones are present. Continue only after the user confirms whether to replace them or add to them.
- **Touch only the Visuals slot.** Never regenerate the rest of the description. Replace the placeholder that `/issue_pr` emits, or an existing screenshot table, otherwise append a Visuals section that matches the body's header style (`## Visuals` when the body uses `##` headers, `**Visuals**` when it uses bold inline headers).
- **Image width is set on the `<img>` tag,** not the table. Markdown cannot size table columns, so every cell is `<img src="..." width="600">`. GitHub scales two 600px images down to fit the body; that is expected.

## Process

1. **Locate the PR:** `gh pr view --json url,body,headRefName`. If there is no PR, stop and point to `/issue_pr`, which creates it.

2. **Check for existing images** in the body (see the warning rule). Report each image URL and where it sits, then wait for the user's decision.

3. **Collect candidate screenshots.** Look in, newest first:
   - `.playwright-mcp/` (Playwright MCP default output dir)
   - `test-results/` and `playwright-report/` (test runs)
   - files captured earlier in this session

   Keep only PNG/JPEG files modified after the branch base (`git merge-base main HEAD`) and that show the UI this diff touches. List the candidates with path and mtime, and say which are reused. When at least one candidate is usable, skip step 4.

4. **Capture only when nothing is reusable.** Requires a target page: use the argument, or derive the route from the diff when it is unambiguous, otherwise ask. Confirm the dev server is up before navigating; if it is not, ask how to start it rather than guessing. Capture with the Playwright MCP (`browser_navigate`, then `browser_take_screenshot` to a named file); fall back to `npx playwright screenshot <url> <file>` when the MCP is unavailable. One full-page capture per route or UI state.

5. **Upload through the browser.** GitHub has no API for attachments, so images are hosted by uploading them into the PR body editor:
   - Open the PR URL in Chrome, open the description editor (`...` menu on the first comment, then `Edit`).
   - Upload each file into the body textarea. GitHub inserts a `![name](https://github.com/user-attachments/assets/...)` line per file.
   - Read the inserted URLs from the textarea, then **cancel the edit**. The attachments stay hosted; the body is written in the next step so the edit is deterministic.
   - When browser tools are unavailable (for example in pi), stop here: print the local file paths and the table from step 6 with `src="<local path>"` placeholders, and tell the user to drag the files into the PR editor and paste the resulting URLs.

6. **Build the table.** Two columns, screenshots in capture order, left to right then top to bottom. An odd final screenshot leaves the last cell empty. Header cells name the route or UI state shown.

   ```markdown
   | Sign-in form | Sign-in error state |
   | --- | --- |
   | <img src="https://github.com/user-attachments/assets/..." width="600"> | <img src="https://github.com/user-attachments/assets/..." width="600"> |
   ```

7. **Write the body.** Apply the Visuals-slot rule to the fetched body, save to a temp file, and run `gh pr edit --body-file <file>`. Re-fetch and confirm the table renders in the body.

8. **Report:** the PR URL, which files were reused versus captured, and the final table.

$ARGUMENTS
