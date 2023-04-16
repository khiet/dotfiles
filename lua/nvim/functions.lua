function delete_trailing_whitespaces()
  vim.cmd('%s/\\s\\+$//e')
end

function replace_curly_quotes()
  if has_character('’') or has_character('‘') then
    vim.cmd([[%s/[’‘]/'/g]])
  end

  if has_character('”') or has_character('“') then
    vim.cmd([[%s/[”“]/"/g]])
  end
end

function has_character(char)
  local character = char

  local current_buffer = vim.api.nvim_get_current_buf()
  local buffer_contents = vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false)

  for _, line in ipairs(buffer_contents) do
    if string.find(line, character, 1, true) ~= nil then
      return true
    end
  end

  return false
end

function search_dictionary()
  os.execute('open "https://dictionary.cambridge.org/dictionary/english/' .. vim.fn.expand('<cword>') .. '"')
end

function create_spec_file()
  local cmd = '!ruby ~/dotfiles/scripts/create_spec_file.rb ' .. vim.fn.expand("%:p")
  vim.api.nvim_command("silent execute '" .. cmd .. "'")
end

function run_script()
  local filetype = vim.bo.filetype

  if filetype == 'javascript' then
    vim.fn.VimuxRunCommand("node " .. vim.fn.bufname("%"))
  elseif filetype == 'ruby' then
    vim.fn.VimuxRunCommand("ruby -w " .. vim.fn.bufname("%"))
  elseif filetype == 'rust' then
    vim.fn.VimuxRunCommand("cargo run")
  elseif filetype == 'sh' then
    vim.fn.VimuxRunCommand("./" .. vim.fn.bufname("%"))
  end
end

vim.keymap.set('n', '<leader>td', delete_trailing_whitespaces, { noremap = true })
vim.keymap.set('n', '<leader>cd', search_dictionary, { noremap = true })
vim.keymap.set('n', '<leader>cq', replace_curly_quotes, { noremap = true })
vim.keymap.set('n', '<leader>rc', create_spec_file, { noremap = true })
vim.keymap.set('n', '<leader>cs', run_script, { noremap = true })
