function delete_trailing_whitespaces()
  local s = vim.fn.getreg('/')
  local l = vim.fn.line('.')
  local c = vim.fn.col('.')

  vim.cmd('%s/\\s\\+$//e')

  vim.fn.setreg('/', s)
  vim.fn.cursor(l, c)
end

vim.keymap.set('n', '<leader>td', delete_trailing_whitespaces, { noremap = true })
-- vim.keymap.set('n', '<leader>cq', replace_curly_quotes, { noremap = true })
