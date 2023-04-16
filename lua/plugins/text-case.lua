return {
  "johmsalas/text-case.nvim",
  config = function()
    vim.keymap.set('n', 'gas', ':lua require("textcase").current_word("to_snake_case")<CR>', { noremap = true })
    vim.keymap.set('n', 'gak', ':lua require("textcase").current_word("to_dash_case")<CR>', { noremap = true })
    vim.keymap.set('n', 'gac', ':lua require("textcase").current_word("to_camel_case")<CR>', { noremap = true })
    vim.keymap.set('n', 'gap', ':lua require("textcase").current_word("to_pascal_case")<CR>', { noremap = true })
  end
}
