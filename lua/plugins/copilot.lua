return {
  {
    "github/copilot.vim",
    config = function()
      -- Enable copilot for all file types by default
      vim.g.copilot_enabled = true

      -- Enable copilot for git commit messages
      vim.g.copilot_filetypes = {
        gitcommit = true
      }

      -- Set up key mappings
      vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.g.copilot_no_tab_map = true

      -- Toggle copilot enable/disable
      vim.keymap.set('n', '<leader>ct', ':Copilot toggle<CR>', { noremap = true, silent = true })
    end
  }
}
