return {
  {
    "mbbill/undotree",
    init = function()
      vim.opt.undodir = os.getenv("HOME") .. "/.undodir"
      vim.opt.undofile = true

      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { noremap = true })
    end
  }
}
