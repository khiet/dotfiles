return {
  "khiet/tickbox.nvim",
  ft = "markdown",
  opts = {},
  keys = {
    { "<leader>t", "<Plug>(tickbox-toggle)", mode = { "n", "x" }, ft = "markdown", desc = "Toggle task" },
    { "<CR>", "<Plug>(tickbox-newline)", mode = "i", ft = "markdown", desc = "New line, continuing a task list" },
  },
}
