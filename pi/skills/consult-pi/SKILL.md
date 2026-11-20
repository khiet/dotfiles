---
name: consult-pi
description: Get a second opinion from the pi coding agent, which runs a different model. Use when the user asks to consult pi.
---

Get a **second opinion** from pi: a different model, reading this repo read-only, with none of this conversation. A second opinion is independent, so pi forms its view from the repo before it hears yours.

## 1. Write the brief

Write the brief to a temp file. It is everything pi knows, so it carries:

- **The question**, phrased so that it has a wrong answer: `Is the retry loop in foo.rb:40 safe under concurrent writers?`, or a choice among named options, each described evenly.
- **Pointers**: `path:line` references, the branch or fixed point, a command that reproduces the behavior. pi reads them itself, so point rather than paste.
- **Established facts**: what was observed and what was ruled out, each with how it was established.
- **Answer shape**: verdict first, then evidence as `path:line`, then what pi could not verify.

Give pi observations and constraints, and hold your own conclusion and preferred option for step 3.

Done when pi could answer the question from the brief and the repo alone.

## 2. Run

Run `~/dotfiles/scripts/pi-consult.sh [attachment...] < <brief file>` as a background command with stdout and stderr captured, and carry on with work that does not depend on the answer. An attachment is a file pi cannot reach by path, such as a spec fetched from a tracker.

- Exit 0: stdout is pi's answer.
- Exit 3: pi changed files. Stop and print the script's stderr, which names them.
- Any other exit: the second opinion did not happen. Report the stderr reason.

## 3. Report

Open the cited lines for every claim of pi's that would change what you do, so each one is confirmed or refuted before it reaches the user.

Then report, naming whose view each line is:

- pi's verdict, in one line.
- Where pi and you agree.
- Where you differ: both positions, the evidence for each, and which one you hold after checking.
- What neither of you verified.

Where you still differ, the decision is the user's.
