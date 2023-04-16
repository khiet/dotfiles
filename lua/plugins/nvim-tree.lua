return {
  {
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        view = {
          adaptive_size = true,
          mappings = {
            list = {
              { key = "l", action = "edit" },
              { key = "Y", action = "copy_absolute_path" },
              { key = "o", action = "system_open" },
            },
          },
        },
        renderer = {
          group_empty = true,
          icons = {
            glyphs = {
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "R",
                untracked = "??",
                deleted = "D",
                ignored = "!!",
              },
            },
          },
        },
        filters = {
          dotfiles = false,
        },
      })

      vim.keymap.set('n', '<C-n>', ":NvimTreeFindFileToggle!<CR>", { noremap = true })
    end
  }
}

