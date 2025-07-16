return {
  "yetone/avante.nvim",
  -- fix a build issue: https://github.com/yetone/avante.nvim/issues/612#issuecomment-2375729928
  build = "make",
  event = "VeryLazy",
  version = false,
  opts = {
    provider = "claude",
    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
}
