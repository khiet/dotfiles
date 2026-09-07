# Acceptance document shape

The shape of the document step 6 of [`SKILL.md`](SKILL.md) writes. Its reader is an agent driving a browser through Playwright, one example at a time.

Write every step as something that agent can do and see in the UI: navigate, click, type, read. Keep assertions on the database, API responses, and logs out; a different kind of test owns those.

## Sections

### Header

Story ID and title, the date written, and one paragraph on what shipped so the runner knows what it is verifying.

### Context

- The environment or URL to test against.
- The test account, and where its credentials come from.
- How to seed or reset data before a run.
- Whatever the invocation arguments asked for, such as a mock design the UI must match: name the file and say what the runner compares against it.
- The features that are out of scope for this run.

### Journeys

One `##` section per journey, holding:

- **Persona and goal:** who is using the product, and what they came to do.
- **Preconditions:** the state the account and data must be in before the first step.
- Numbered examples as `###` sections, written Given / When / Then, where each When names a visible control and each Then names an observable outcome.

Every example carries:

- **Features covered:** the numbers from the feature list.
- **Result:** left blank for the runner to fill with pass or fail.
- **Evidence:** left blank for the runner to fill with a screenshot path or a quoted observation.
- **Notes:** left blank for the runner.

### Coverage map

A table of feature number, feature name, and the examples that exercise it.

### Defect log

An empty table for the runner to fill as it goes: example, expected, observed, severity.

### How to report back

Instructions addressed to the runner: work through the examples in order, fill Result, Evidence, and Notes for each, add a defect log row for every failure, and close with a summary of passes, failures, and blocked examples.
