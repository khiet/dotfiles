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

      -- https://github.com/rest-nvim/rest.nvim/issues/417#issuecomment-2322786365
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "json" },
        callback = function()
          vim.api.nvim_set_option_value("formatprg", "jq", { scope = 'local' })
        end
      })
    end
  }
}
