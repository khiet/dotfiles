return {
  {
    "tpope/vim-fugitive",
    init = function()
      vim.keymap.set("n", "gb", vim.cmd.GBrowse, { silent = true })
    end
  }
}
