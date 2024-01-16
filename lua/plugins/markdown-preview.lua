return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_images_path = (os.getenv("HOME") .. "/notes/images")

    vim.keymap.set('n', '<leader>em', "<Plug>MarkdownPreviewToggle", { noremap = true })
  end
}
