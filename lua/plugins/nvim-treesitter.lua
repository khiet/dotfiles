local parsers = {
  "c",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "ruby",
  "embedded_template",
  "javascript",
  "typescript",
  "tsx",
  "xml",
  "json",
  "markdown",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    -- After changing `parsers`, run `:Lazy build nvim-treesitter` to install
    -- missing parsers and update existing ones. Removed parsers must be
    -- uninstalled manually with `:TSUninstall <parser>`.
    build = function()
      local treesitter = require("nvim-treesitter")

      treesitter.install(parsers):wait(300000)
      treesitter.update(parsers):wait(300000)
    end,
    config = function()
      local treesitter = require("nvim-treesitter")

      treesitter.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      vim.treesitter.language.register("embedded_template", "eruby")

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
