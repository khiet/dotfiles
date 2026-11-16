---
description: Group compatible open Renovate PRs into one Linear ticket and report the ones to address alone
---

# Group Renovate PRs

Use the `group-dependency-prs` skill with these inputs:

- **Bot author**: `app/renovate`
- **Ticket title**: `Group compatible Renovate updates into one PR (<owner/repo>)`, with the repository filled in
- **Standalone rules**: the group ships as an OTA update, so every update that needs a native rebuild is Separate at any version level, with the reason "not OTA-safe". That covers `react-native`, `react-native-*`, `@react-native/*`, `expo`, `@sentry/react-native`, `mixpanel-react-native`, any other native module, build tools, and build or runtime configuration changes. When OTA safety is uncertain, the update is Separate.

Usage: `/group_renovate_prs [owner/repo]`

$ARGUMENTS
