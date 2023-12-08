return {
  "lukas-reineke/indent-blankline.nvim",
  cmd = "IBLToggle",
  init = function()
    vim.keymap.set('n', '<leader>ti', ":IBLToggle<CR>", { noremap = true })
  end,
  config = function()
    require("ibl").setup()

    vim.cmd([[IBLToggle]]) -- vim.keymap.set("n", "<leader>a", mark.add_file)
  end
}
