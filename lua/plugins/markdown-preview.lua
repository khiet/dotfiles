return {
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }

      vim.keymap.set('n', '<leader>em', "<Plug>MarkdownPreviewToggle", { noremap = true })
    end
  }
}
