return {
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_images_path = (os.getenv("HOME") .. "/notes/images")

      vim.keymap.set('n', '<leader>em', "<Plug>MarkdownPreviewToggle", { noremap = true })
    end
  }
}
