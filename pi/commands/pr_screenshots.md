---
description: Upload UI screenshots with GitHub CLI and format the PR's Evidence section
---

# PR Screenshots

Fill the current PR's Evidence section with screenshots of the UI this branch changes. Show the new UI only.

## Rules

- **Require `--attach`.** If `gh pr edit --help` does not list `--attach`, report that the installed GitHub CLI cannot upload attachments and stop.
- **Check existing images before every write.** Look for Markdown images, `<img>` tags, and `github.com/user-attachments` URLs in the `**Screenshots:**` block, and in a screenshot table under `**After:**` left by earlier runs. On the first check, if any exist, show each image URL and its location, then wait for the user to choose which to replace or keep. On later checks, stop and ask only if images changed since the user's decision.

## Process

1. **Locate the PR.** Run `gh pr view --json number,url,body`. If there is no PR, report that and stop. Check existing images.

2. **Reuse screenshots before capturing.** Look in `.playwright-mcp/` and files captured earlier in this session, newest first. Select PNG/JPEG files modified after the branch-base commit (`git merge-base main HEAD`) that show UI touched by this diff. List each selected path and mtime, and flag any screenshot older than the latest commit that changed the UI it shows, since it may not reflect the final state. Keep usable assets as-is, without recapturing, cropping, or resizing. If any are usable, skip step 3.

3. **Capture only when nothing is reusable.** Use the `smoke-test` skill and collect screenshots from its output directories using step 2's criteria. Only screenshots listed under `Passed` are eligible. Report `Failed` findings and exclude their screenshots. On `Skipped: no UI changes`, report that there is nothing to capture; on any other `Skipped` label, report the gate. Stop on either skipped outcome or if no eligible screenshots remain.

4. **Build the body.** Fetch the latest body with `gh pr view <pr-url> --json body` and check existing images. Build a two-column table of the selected screenshots in capture order, left to right then top to bottom, leaving the last cell empty for an odd count. Header cells name the route or UI state. Use each screenshot's absolute local path as a placeholder `src`; step 6 swaps in the uploaded URL. Set width on each `<img>` tag so the columns render at a consistent size.

   ```markdown
   | Sign-in form | Sign-in error state |
   | --- | --- |
   | <img src="/abs/path/sign-in.png" width="600"> | <img src="/abs/path/sign-in-error.png" width="600"> |
   ```

   Place the table with a targeted edit of the fetched body:
   - The table goes under a `**Screenshots:**` label at the end of `## Evidence`, after the **Before** and **After** lines. If that block exists, update its table according to the user's keep/replace decision; a screenshot table under **After:** from an earlier run moves into the block. If Evidence is missing, add it after `## Summary` holding only this block.
   - Preserve the **Before** and **After** lines and all unrelated content.

   Check that the diff against the fetched body contains only these edits, then save it to a temp file.

5. **Upload.** Run `gh pr edit <pr-url> --body-file <file> --attach '<absolute-path>#<filename>'`, repeating `--attach` for each selected screenshot. `--attach` does not rewrite `<img src>` paths; it appends one `![<filename>](<url>)` reference per upload to the end of the body.

6. **Swap in the URLs.** Re-fetch the body, including after a non-zero exit: partial failures still publish the uploads that succeeded. Match each appended reference to its screenshot by alt text.
   - If any upload failed, retry once: save the re-fetched body to the temp file and rerun step 5 attaching only those files.
   - If an upload still has no appended reference, report the error and the affected files, then stop without the swap below.

   Replace each placeholder `src` with its uploaded URL, remove the appended references, and run `gh pr edit <pr-url> --body-file <file>` without `--attach`. Re-fetch and confirm every table cell holds a `github.com/user-attachments` URL and no local path or appended reference remains.

7. **Report** the PR URL, which files were reused versus captured, and the final table.
