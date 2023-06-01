return {
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    init = function()
      vim.keymap.set("n", "gb", vim.cmd.GBrowse, { silent = true })
    end
  }
}
