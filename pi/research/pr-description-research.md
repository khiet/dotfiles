# PR descriptions for a 30-second first read

Researched September 12, 2026. Requested window: March 12 through September
12, 2026.

[Open the three-style HTML comparison](pr-description-styles.html).

## Recommendation

Choose **Outcome + caveat** as the single `issue_pr` format: one sentence
combining the behavior change and its reason; an optional, plainly labeled
non-obvious caveat; and one short verification line when useful. Routine changes
can be one sentence. Aim for roughly 40-80 words when context is needed, not a
mandatory word count. Preserve material risks even if that requires more space.

The 30-second goal and word budget are design recommendations, not measured
findings from these sources. Thirty seconds should establish intent, affected
behavior, and the important exception; it is not enough to approve the code.

## Recent evidence

### 1. Trim agent prose and retain human ownership

**GitHub, Andrea Griffiths, May 7, 2026.**
[Agent pull requests are everywhere. Here's how to review them.](https://github.blog/ai-and-ml/generative-ai/agent-pull-requests-are-everywhere-heres-how-to-review-them/)

Page date verified in the fetched article. In "One note for authors":

> Agents love verbosity. They describe what's better explored through the code
> itself.

The same section advises annotating the diff where context helps and reviewing
the PR yourself before requesting others' review, to validate that the agent
captured your intent.

**Implication:** Compress the description rather than replaying the diff. The
author still checks the generated description against the intended change. A
polished summary is not evidence of correctness. This is the most directly
relevant source to the requested format change.

### 2. A short description cannot rescue an unfocused change

**GitHub, Julia Muiruri, August 4, 2026.**
[Turn one giant AI-generated pull request to a reviewable stack](https://github.blog/engineering/turn-one-giant-ai-generated-pull-request-to-a-reviewable-stack/)

Page date verified in the fetched article. The "GitHub stacked pull requests"
section recommends layers:

> each scoped to a single concern

It describes small, logically ordered PRs with enough context flowing from
preceding work.

**Implication:** Summarize one concern. For a partial ticket or dependent PR,
include the relationship or remaining scope in one line. If the explanation
requires several independent stories, splitting the PR may help more than
squeezing the prose. Stacking is an option, not a prerequisite for adopting
these templates.

### 3. Keep constraints and exceptions visible

**GitLab, August 24, 2026.**
[When code is abundant](https://about.gitlab.com/blog/when-code-is-abundant/)

The fetched page explicitly says "Published on: August 24, 2026." In "The new
platform architecture," it defines context as:

> a coherent picture of the requirement, code, history, business priority and
> constraints surrounding the work.

It also argues that policies and tests automate decisions already made, while
unanticipated cases require human attention.

**Implication:** Preserve consequential constraints the diff cannot establish,
such as accepted data staleness, deployment order, or an intentionally deferred
migration. This is broader vendor strategy, not a study of PR-description
length; it supports the emphasis on context, not a particular template.

### 4. Direct attention to judgment, not mechanical reporting

**Rachel Laycock, September 2, 2026, published on Martin Fowler's site.**
[Maybe We Shouldn't Be Reviewing All This Code](https://martinfowler.com/rachels-ramblings/code-review.html)

Page date verified in the fetched article. "Shift the judgment left" argues for
exploring alternatives before implementation and automating deterministic
checks. "Review by exception" identifies cases needing human judgment,
including:

> something crossing a sensitive security boundary, a change with a huge blast
> radius

**Implication:** For consequential choices, a decision-first description can
highlight the accepted cost and what needs scrutiny. This is an explicitly
opinionated essay. We borrow its focus on judgment, not its broader proposal to
reduce mandatory human reviews.

## Synthesis for `issue_pr`

The following are proposed local rules, informed by the sources rather than
prescribed verbatim by them:

- Use one default, with no `tiny` or `long` argument and no replacement size
  selector.
- Merge the opening summary and "Why" into a concrete outcome sentence. Describe
  behavior in the codebase's domain vocabulary.
- Let meaningful content determine length. Remove the current quotas for 2-3
  "Why" sentences and 3-5 change bullets.
- Add technical detail only when omitting it could change approval, rollout, or
  understanding: accepted tradeoffs, hidden assumptions, compatibility,
  security, data migration, failure behavior, or remaining ticket scope.
- Keep a material caveat visible, not in a collapsed details block. Put routine
  mechanism in the diff; place a durable operational contract in code or
  maintained docs as appropriate, and link it rather than duplicating a design
  document.
- Include one concise verification outcome when it adds information beyond the
  Checks tab. Identify an unverified critical path or failing/pending required
  check even if it costs words. Link detailed evidence rather than pasting logs.
  Every test claim must trace to an actual run on the relevant revision.
- Treat AI-written descriptions as drafts to reconcile against the request,
  diff, and evidence. Include agent provenance only if team policy requires it;
  a transcript is not a substitute for reasoning or validation.
- Keep existing draft-creation behavior, confirmation before overwriting an
  existing description, title detection, and evidence/completeness gates.
  Selecting a shorter format should not weaken those safeguards.

## Three directions

1. **Outcome + caveat:** Minimal narrative. Best default for routine work; the
   important exception is hard to miss.
2. **Before / After:** Contrast-led. Best for behavior fixes that need a clear
   mental model; can feel forced for internal refactors.
3. **Decision brief:** Choice-led. Best when the reviewer needs to assess an
   accepted cost; unnecessary ceremony for routine changes. Record an accepted
   decision as such; distinguish it from an unresolved question.

These are candidates for one default, not three new command modes. The HTML
shows the same fictional sign-in/sync change in each format so the team can
compare presentation rather than different examples. Its validation claims are
illustrative, not tests run in this dotfiles repository.

## The 24-hour caveat

A daily schedule alone does not establish a hard freshness guarantee. To promise
"at most 24 hours," verify the reference point, maximum interval, job duration,
retries, and failure handling. An honest concise example is:

> Existing users can see data up to 24 hours old when the daily sync succeeds on
> schedule; failed or delayed runs can extend that window.

If a hard bound is required, this is a behavior/operations requirement, not
something to solve by wording the PR more confidently.

## Method and limitations

Searched three initial angles (agentic PR descriptions, GitHub guidance,
Anthropic review guidance), then targeted Cursor, GitLab, Martin Fowler, and
OpenAI. Fetched candidate pages and inspected source passages and visible dates.
Four dated first-party/original-author publications within the requested window
support the recommendations above. They are guidance and opinion, not controlled
comparisons of templates. Vendor guidance can reflect product incentives.

Other candidates were not used as evidence: an undated CodeRabbit guide (recency
unverified), a practitioner essay whose visible publication date was not
established, and a GitHub product changelog with little direct formatting
guidance. One later OpenAI search hit the search provider's rate limit; coverage
is therefore not exhaustive. No source reviewed demonstrates that a particular
template produces comprehension in exactly 30 seconds.

`pi/commands/issue_pr.md` is unchanged pending the team's format choice.
