return {
  "FooSoft/vim-argwrap",
  init = function()
    vim.keymap.set('n', 'gS', vim.cmd.ArgWrap, { silent = true, noremap = true })
  end
}
