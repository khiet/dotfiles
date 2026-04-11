-- https://neovim.getkulala.net/docs/usage
return {
  "mistweaverco/kulala.nvim",
  keys = {
    { "<leader>rr", "<cmd>lua require('kulala').run()<CR>",              desc = "Send request",       ft = { "http", "rest" } },
    { "<leader>re", "<cmd>lua require('kulala').set_selected_env()<CR>", desc = "Select environment", ft = { "http", "rest" } },
  },
  ft = { "http", "rest" },
  opts = {
    global_keymaps = false,
    kulala_keymaps_prefix = "",
    ui = {
      -- https://neovim.getkulala.net/docs/getting-started/configuration-options#uiwin_opts
      max_response_size = 10485760, -- 10MB
      win_opts = {
        wo = { foldenable = false },
      },
    },
  },
}
