return {
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    init = function()
      vim.keymap.set({ "n", "v" }, "gb", ":GBrowse<CR>", { silent = true, noremap = true })
      vim.keymap.set("n", "gB", ":0GBrowse<CR>", { silent = true, noremap = true })
    end
  }
}
