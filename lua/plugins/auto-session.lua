return {
  'rmagatti/auto-session',
  lazy = false,
  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { '~/', '/' },
    auto_restore = false,
    -- log_level = 'debug',
  },
  init = function()
    vim.keymap.set('n', '<leader>br', '<cmd>AutoSession restore<CR>', { desc = 'Restore session', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>bs', '<cmd>AutoSession search<CR>', { desc = 'Search sessions', noremap = true, silent = true })
    vim.keymap.set("n", "<leader>bd", [[:let curr=bufnr() | bufdo if bufnr() != curr && !&modified | bdelete | endif<CR>]], { silent = true })
  end
}
