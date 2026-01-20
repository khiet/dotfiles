import type { Plugin } from "@opencode-ai/plugin"

export const PermissionNotifyPlugin: Plugin = async ({ $ }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "permission.updated") {
        await $`terminal-notifier -title "OpenCode" -message "Permission required" -sound Ping`
      }
    },
  }
}
