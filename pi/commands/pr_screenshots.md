---
description: Save UI screenshots to ~/Desktop, wait for manual GitHub upload, then use gh to format them in the PR description
---

# PR Screenshots

Fill the `Visuals` slot of the current PR description with screenshots of the UI this branch changes. Only the new UI is shown - no before/after pairing.

Usage: `/pr_screenshots [url-or-route ...]`

The argument is the page (or pages) to capture when no usable screenshot exists. Omit it when the recent Playwright session already produced captures.

## Rules

- **Reuse before capture.** If screenshots from the recent Playwright session exist, use them as-is. Do not recapture, recrop, or resize a usable asset.
- **Manual upload only.** Save screenshots to `~/Desktop` and ask the user to upload them to GitHub. Stop until the user confirms the upload; never automate the upload or publish local paths as image URLs.
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

5. **Stage on the Desktop.** Copy each selected screenshot, without modifying the original or its image bytes, to `~/Desktop`. Use unique, descriptive filenames containing the PR number and route or UI state; never overwrite an unrelated Desktop file. Keep a mapping of each Desktop path to its source, caption, and capture order.

6. **Ask the user to upload, then stop.** Print the PR URL and the exact Desktop paths. Ask the user to open the PR description editor, drag those files into the `Visuals` slot (creating it if absent), save the description without changing anything else, and reply when the upload is complete. Do not upload through browser tools, poll for completion, or run `gh pr edit` yet. End the turn and wait for the user's reply.

7. **Resolve uploaded images and build the table.** After the user confirms the upload, re-fetch the same PR with `gh pr view <pr-url> --json body`. Extract the uploaded GitHub image URLs from its description and match them to the Desktop file mapping. If any upload is missing or the mapping is ambiguous, ask the user for the corresponding GitHub image URL or inserted Markdown and wait again. Never guess a URL or use a local path. Preserve the user's earlier add/replace decision; newly uploaded images are expected, but unrelated new images or edits require clarification before changing them.

   Build the table with the confirmed uploaded URLs. Two columns, screenshots in capture order, left to right then top to bottom. An odd final screenshot leaves the last cell empty. Header cells name the route or UI state shown.

   ```markdown
   | Sign-in form | Sign-in error state |
   | --- | --- |
   | <img src="https://github.com/user-attachments/assets/..." width="600"> | <img src="https://github.com/user-attachments/assets/..." width="600"> |
   ```

8. **Write the body using GitHub CLI.** Apply the Visuals-slot rule to the freshly fetched body, replacing the raw upload lines within that slot with the table. Preserve all content outside the slot and any existing images the user chose to keep. Save to a temp file and run `gh pr edit <pr-url> --body-file <file>`. Re-fetch the same PR and confirm the table and uploaded URLs are present and content outside the slot is unchanged.

9. **Report:** the PR URL, which files were reused versus captured, and the final table.

$ARGUMENTS
