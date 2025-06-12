return {
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
    init = function()
      vim.keymap.set('n', '<leader>rr', ":Rest run<CR>", { noremap = true })
      vim.keymap.set('n', '<leader>rl', ":Rest run last<CR>", { noremap = true })
    end
  }
}
