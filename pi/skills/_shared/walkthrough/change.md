# Walkthrough of a change

Shared rules for walkthroughs whose subject is a change: the diff between a base and a head revision. The calling skill names the two revisions and the sources of claims; this file says what evidence a change needs and how its Scope check is built.

## Change evidence

Diff from the merge-base of base and head, which stays correct after the change merges. Keep each claim's provenance apart from what only the diff shows. Read the callers and tests of every changed function, and list the consumers of every changed contract. Record the test delta as added, changed, removed, or skipped; with no test changes, say so.

Done when every claim is located in the diff or marked `missing`, every changed file is classified behavioral or mechanical, every behavioral change has a claim or is marked `undescribed`, every changed contract has its consumers listed, and every test in the delta has a status per **Verification** in `page.md`.

## Scope check

A table with columns Claim, Where, Verdict, inside a closed `<details>`.

- **Rows**: one per independently checkable claim, however often its sources repeat it, and one per undescribed change: a behavioral change in the diff that no source claims. A precondition or failure mode that follows from a described change stays in the calling skill's failure modes, without a row. A sentence whose clauses could hold or fail separately gets a row per clause; clauses that one declaration decides together, such as a list of attributes or a removed line and its replacement, share a row. A removed or renamed externally consumed contract, including a public endpoint, gets its own row. With no claims and nothing undescribed, one sentence replaces the table.
- **Where**: a locator for each piece of code, test, or CI workflow job that decides the claim, the call sites included when the claim says who uses or calls something, with the `(base)` locator as well when the claim is about what was removed or replaced; `whole diff` for a claim that something is absent or untouched; `not in diff` for missing implementation.
- **Verdict**: exactly `done`, `partial` (the code or the cited evidence supports only part of the claim), `missing`, or `undescribed` (no source claims it: a documentation gap, not a code-quality judgment).

Carry every `partial`, `missing`, or behavioral `undescribed` row into the section outside the `<details>` where it matters; a mention in the opening alone does not carry it.
