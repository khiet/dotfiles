return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  opts = {
    explorer = {
      auto_open_on_cursor = true
    },
  },
  init = function()
    local opt_sn = { silent = true, noremap = true }
    vim.keymap.set('n', '<leader>ds', ':CodeDiff<CR>', opt_sn)
    vim.keymap.set('n', '<leader>dm', ':CodeDiff main<CR>', opt_sn)
    vim.keymap.set('n', '<leader>dh', ':CodeDiff HEAD~<CR>', opt_sn)
    vim.keymap.set('n', '<leader>dc', function()
      local ref = vim.fn.getreg('+'):match('^%s*(.-)%s*$')

      if ref ~= '' then
        vim.cmd('CodeDiff history ' .. vim.fn.fnameescape(ref))
      end
    end, opt_sn)
  end,
}
