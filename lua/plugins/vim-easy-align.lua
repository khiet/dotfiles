return {
  {
    "junegunn/vim-easy-align",
    init = function()
      vim.keymap.set({ 'n', 'x' }, 'ga', "<Plug>(EasyAlign)", { noremap = true })
      vim.keymap.set('n', 'ga', "<Plug>(EasyAlign)", { noremap = true })
    end
  }
}
