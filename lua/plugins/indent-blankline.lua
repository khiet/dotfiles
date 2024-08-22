return {
  "lukas-reineke/indent-blankline.nvim",
  cmd = "IBLToggle",
  init = function()
    vim.keymap.set('n', '<leader>ti', ":IBLToggle<CR>", { noremap = true })
  end,
  config = function()
    require("ibl").setup()

    -- call IBLToggle so that next time IBLToggle is called, it enables it
    vim.cmd([[IBLToggle]])
  end
}
