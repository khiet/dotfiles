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

  if has_character('）') then
    vim.cmd([[%s/[)]/)/g]])
  end

  if has_character('（') then
    vim.cmd([[%s/[（]/(/g]])
  end
end

function convert_to_emojis_and_symbols()
  if has_character('->') then
    vim.cmd([[%s/->/→/g]])
  end

  if has_character(':bulb:') then
    vim.cmd([[%s/:bulb:/💡/g]])
  end

  if has_character(':warning:') then
    vim.cmd([[%s/:warning:/⚠️/g]])
  end

  if has_character('（') then
    vim.cmd([[%s/（/(/g]])
  end

  if has_character('）') then
    vim.cmd([[%s/）/)/g]])
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

function pretty_print_table(tbl, indent)
  if not indent then indent = 0 end

  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "

    if type(v) == "table" then
      print(formatting)
      pretty_print_table(v, indent + 1)
    elseif type(v) == "boolean" then
      print(formatting .. tostring(v))
    else
      print(formatting .. v)
    end
  end
end

function search_dictionary(lang)
  if lang == 'en' then
    os.execute('open "https://dictionary.cambridge.org/dictionary/english/' .. vim.fn.expand('<cword>') .. '"')
  elseif lang == 'jp' then
    os.execute('open "https://www.google.com/search?q=' .. vim.fn.expand('<cword>') .. '+意味"')
  end
end

function create_spec_file()
  local cmd = '!ruby ~/dotfiles/scripts/create_spec_file.rb ' .. vim.fn.expand("%:p")
  vim.api.nvim_command("silent execute '" .. cmd .. "'")
end

vim.keymap.set('n', '<leader>cw', delete_trailing_whitespaces, { noremap = true })
vim.keymap.set('n', '<leader>cq', replace_curly_quotes, { noremap = true })
vim.keymap.set('n', '<leader>cm', convert_to_emojis_and_symbols, { noremap = true })

vim.keymap.set('n', '<leader>Z', function() vim.cmd([[normal 1z=]]) end, { noremap = true })

vim.keymap.set('n', '<leader>rc', create_spec_file, { noremap = true })
