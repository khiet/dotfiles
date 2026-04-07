return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")

      treesitter.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      treesitter.install({
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "ruby",
        "javascript",
        "typescript",
        "tsx",
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if vim.bo[args.buf].filetype == "markdown" then
            return
          end

          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end
  }
}
