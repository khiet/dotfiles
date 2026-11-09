return {
  "khiet/tickbox.nvim",
  ft = "markdown",
  opts = {
    progress = true,
    auto_check_parent = true,
  },
  keys = {
    { "<leader>cc", "<Plug>(tickbox-toggle)",  mode = { "n", "x" }, ft = "markdown" },
    { "<CR>",       "<Plug>(tickbox-newline)", mode = "i",          ft = "markdown" },
  },
}
