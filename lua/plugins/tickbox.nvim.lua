return {
  "khiet/tickbox.nvim",
  ft = "markdown",
  opts = {
    progress = true,
    auto_check_parent = true,
  },
  keys = {
    { "<leader>cc", "<Plug>(tickbox-toggle)", mode = { "n", "x" }, ft = "markdown", desc = "Toggle task" },
    { "<leader>ci", "<Plug>(tickbox-set-in-progress)", mode = { "n", "x" }, ft = "markdown", desc = "Mark task in progress" },
    { "<leader>cC", "<Plug>(tickbox-set-cancelled)", mode = { "n", "x" }, ft = "markdown", desc = "Mark task cancelled" },
    { "<CR>", "<Plug>(tickbox-newline)", mode = "i", ft = "markdown" },
  },
}
