return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  opts = {},
  config = function()
    require("colorizer").setup({
      filetypes = {
        "*",
        "!markdown",
      },
      options = {
        parsers = {
          css = true,
          tailwind = {
            enable = true,
            lsp = true,
          },
        },
      },
    })
  end
}
