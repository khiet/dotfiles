return {
  {
    "voldikss/vim-floaterm",
    init = function()
      vim.keymap.set('n', 'gl', ":FloatermNew lazygit<CR>", { silent = true, noremap = true })
      vim.keymap.set('n', 'tn', ":FloatermNew<CR>", { silent = true, noremap = true })
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_width = 0.8
    end
  }
}
