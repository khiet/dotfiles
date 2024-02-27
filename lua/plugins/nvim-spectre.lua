return {
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('spectre').setup({
        mapping = {
          ['send_to_qf'] = {
            map = "<F12>",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all items to quickfix"
          },
        }
      })

      vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").open()<CR>', {
        desc = "Open Spectre"
      })
      vim.keymap.set('n', '<leader>Sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
        desc = "Search current word"
      })
    end
  }
}
