---
name: consult-pi
description: Get a second opinion from the pi coding agent. Use when the user asks to consult pi.
---

Get a **second opinion** from pi: a different model that reads this repo read-only and has none of this conversation.

## 1. Write the brief

Write the brief to a temp file. It carries:

- **The question**, phrased so that it has a wrong answer: `Is the retry loop in foo.rb:40 safe under concurrent writers?`, or a choice among named options, each described evenly.
- **Pointers**: `path:line` references, the branch or fixed point, a command that reproduces the behavior. pi reads them itself, so point rather than paste. Save evidence from outside the repo, such as a spec from a tracker, to a file and pass it as an attachment in step 2.
- **Established facts**: what was observed and what was ruled out, each with how it was established.
- **Answer shape**: verdict first, then evidence as `path:line`, then what pi could not verify.

Give pi observations and constraints, and hold your own conclusion and preferred option for step 3, so pi forms its view before it hears yours.

Done when pi could answer the question from the brief, the repo, and the attachments alone.

## 2. Run

Run `~/dotfiles/scripts/pi-consult.sh [attachment...] < <brief file>` as a background command with stdout and stderr captured. While it runs, carry on only with work that leaves the repo unchanged, because the script blames pi for any change it finds. Wait for its exit before step 3.

- Exit 0: stdout is pi's answer.
- Exit 3: the repo changed during the run. Stop and print the script's stderr, which shows what changed.
- Any other exit: the second opinion did not happen. Report the stderr reason.

## 3. Report

Open the cited lines for every claim of pi's that would change what you do, and mark each one confirmed, refuted, or unverified.

Then report, naming whose view each line is:

- pi's verdict, in one line.
- Where pi and you agree.
- Where you differ: both positions, the evidence for each, and which one you hold after checking. Where the evidence leaves it open, the decision is the user's.
- What is unverified: pi's claims you could not check, and what neither of you looked at.
