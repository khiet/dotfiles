return {
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      require("bufferline").setup({
        options = {
          hover = { enabled = false },
          buffer_close_icon = '',
          modified_icon = '~',
        }
      })
    end
  }
}
