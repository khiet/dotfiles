---
description: Investigate a CloudWatch alarm or error down to a root cause using alarms, metrics, and logs
---

# CloudWatch Debug

Use the `cloudwatch-debug` skill to investigate the target below and drive it to a root cause.

Usage: `/cw_debug [alarm name, error message, service, or description of the symptom]`

If no target is given, start from `get_active_alarms` in `eu-west-2` and report what is currently firing.
