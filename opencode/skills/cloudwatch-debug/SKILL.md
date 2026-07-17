---
name: cloudwatch-debug
description: Investigate a CloudWatch alarm, error, or incident down to a root cause by querying alarms, metrics, and logs. Use when the user points at an alarm, asks why a service is failing, wants logs grepped for an error, or runs `/cw_debug`.
---

# CloudWatch Debug

Take an alarm, an error message, or a vague "prod looks broken" and drive it to a root cause: what broke, when it started, and the log lines that prove it.

Read-only. This skill never mutates AWS state.

## Always pass region explicitly

Pass `region` on every `mcp__cloudwatch__*` call. Never rely on the default.

The server falls back to `us-east-1`, which holds unrelated leftovers. A query there returns an empty result rather than an error, so an omitted region looks like "no problems found" instead of "wrong region". Default to `eu-west-2` unless the user names another.

If a query comes back suspiciously empty, re-check the region before concluding nothing is wrong.

## Workflow

### 1. Establish the window

Everything downstream depends on getting the time window right, so pin it before querying logs.

- Starting from an alarm: `get_alarm_history` gives the exact `OK -> ALARM` transition. That timestamp is the anchor.
- Starting from a report ("checkout broke this morning"): ask for or infer a window, then confirm it against the data.
- `get_active_alarms` lists what is firing right now, but a resolved alarm is still worth investigating. Absence from this list is not evidence of health.

Query from a few minutes *before* the transition. The cause precedes the alarm; the alarm fires on a threshold the cause already crossed.

### 2. Find the right log group

Map the alarm's dimensions to a service, then `describe_log_groups` with a prefix to find its group. Confirm the group actually corresponds to the failing service before querying it -- a plausible name is not proof, and a confident answer from the wrong log group is worse than no answer.

Prefer a `log_group_name_prefix` over listing everything.

### 3. Query the logs

Use `execute_log_insights_query`. Query more than one group at once with `execute_cwl_insights_batch` when the failure could span services.

Start broad, then narrow. A first pass that shows the shape of the errors beats guessing an exact filter:

```
fields @timestamp, @message
| filter @message like /(?i)(error|exception|fatal|timeout)/
| sort @timestamp desc
| limit 50
```

Then pivot on what you find -- a request id, a stack frame, a downstream host. Follow the id across log groups when the trail leaves the service.

When you do not know what to grep for, `analyze_log_group` surfaces anomalies and error patterns without needing a filter. Reach for it when the broad query returns too much noise to read.

#### Empty results are ambiguous

An empty result means "nothing matched the query as written", which is not the same as "the service is healthy". Before reporting all-clear, rule out the boring explanations: wrong region, wrong log group, window outside the data, or a filter that is too specific.

A cheap disambiguator is an unfiltered `limit 3` over a wide window. Data means the query was wrong; no data means the group is genuinely dormant. Several groups in this account are large but retired -- size on disk says nothing about recent activity.

#### Timeouts

Insights scans the whole window, so wide ranges over large groups hit the `max_timeout` and return `Polling Timeout` with a `queryId`. The query is still running server-side -- pass that id to `get_logs_insight_query_results` rather than re-running it.

Prefer narrowing the window or aggregating with `stats` over raising the timeout.

### 4. Corroborate with metrics

A log line shows a failure; a metric shows its scale. Use `get_metric_data` or `analyze_metric` to distinguish one unlucky request from a systemic outage, and to establish whether the pattern is a spike, a step change, or a slow climb. This is usually what separates a real root cause from a coincidence.

### 5. Report

Lead with the root cause. Then:

- **When it started** -- the first bad timestamp, not the alarm time
- **Blast radius** -- how many requests, which region, which users, from metrics
- **Evidence** -- the specific log lines, quoted
- **Fix** -- if the cause is in a repo you can see, name the file and line

State plainly what you could not determine. An honest "the logs show the symptom but not the cause" is worth more than a plausible guess, because the guess costs someone a debugging session to disprove.

## Escalation

When CloudWatch alone does not explain it:

- `mcp__aws-api__call_aws` (read-only) inspects service state -- ECS task health, recent deployments, Beanstalk events. "It broke because it deployed" is a common answer that logs alone will not tell you.
- `mcp__sentry__*` has richer stack traces and grouping for application exceptions.
- Correlate the start time against `git log` in the relevant repo. A failure that begins minutes after a deploy usually belongs to that deploy.
