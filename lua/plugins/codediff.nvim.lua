return {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  opts = {
    highlights = {
      line_insert = "#102718",
      char_insert = "#214d30",
      line_delete = "#2a1116",
      char_delete = "#6b2f3a",
    },
    explorer = {
      auto_open_on_cursor = true
    },
    diff = {
      layout = "inline", -- toggle between "side-by-side" and "inline" with 't'
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
        vim.cmd('CodeDiff ' .. vim.fn.fnameescape(ref .. '^') .. ' ' .. vim.fn.fnameescape(ref))
      end
    end, opt_sn)
  end,
}
