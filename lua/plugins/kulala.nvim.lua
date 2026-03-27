-- https://neovim.getkulala.net/docs/usage
return {
  "mistweaverco/kulala.nvim",
  keys = {
    { "<leader>Rr", function() require("kulala").run() end, desc = "Send request" },
    { "<leader>Re", function() require("kulala").set_selected_env() end, desc = "Select environment" },
  },
  ft = { "http", "rest" },
  opts = {
    max_response_size = 10485760, -- 10MB
    global_keymaps = false,
    kulala_keymaps_prefix = "",
    ui = {
      -- https://neovim.getkulala.net/docs/getting-started/configuration-options#uiwin_opts
      win_opts = {
        wo = { foldenable = false },
      },
    },
  },
}
