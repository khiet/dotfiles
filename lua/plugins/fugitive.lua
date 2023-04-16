return {
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "gb", vim.cmd.GBrowse, { silent = true })
    end
  }
}
