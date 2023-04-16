return {
  "FooSoft/vim-argwrap",
  config = function()
    vim.keymap.set('n', 'gS', vim.cmd.ArgWrap, { silent = true, noremap = true })
  end
}
