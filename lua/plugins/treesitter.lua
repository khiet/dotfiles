return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "ruby", "javascript", "typescript", "lua" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          disable = { "markdown" },
          additional_vim_regex_highlighting = false,
        },
      })
    end
  }
}
