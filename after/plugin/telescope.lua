local actions = require("telescope.actions")
local builtin = require('telescope.builtin')

require('telescope').setup({
  defaults = {
    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-u>"] = false
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--sort", "path" },
    },
  },
})

vim.keymap.set('n', '<C-f>', builtin.find_files, {})
vim.keymap.set('n', '<C-b>', builtin.git_status, {})

vim.keymap.set('n', '<leader>mf', function()
  require("telescope.builtin").find_files({cwd = (os.getenv("DEVS_HOME") .. "/vim/notes")})
end, {})

