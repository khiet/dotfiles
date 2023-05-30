return {
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('spectre').setup({})

      vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").open()<CR>', {
        desc = "Open Spectre"
      })
      vim.keymap.set('n', '<leader>Sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
        desc = "Search current word"
      })
    end
  }
}
