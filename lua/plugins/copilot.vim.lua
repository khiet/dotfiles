return {
  {
    "github/copilot.vim",
    config = function()
      -- Eisable copilot for some file types
      vim.g.copilot_filetypes = {
        ["*"] = false,
        gitcommit = true,
        markdown = true,
      }

      vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.g.copilot_no_tab_map = true
    end
  }
}
