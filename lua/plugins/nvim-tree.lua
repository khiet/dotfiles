local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- https://github.com/nvim-tree/nvim-tree.lua/blob/8f92e1edd399f839a23776dcc6eee4ba18030370/lua/nvim-tree/keymap.lua#L37
  vim.keymap.set('n', 'a', api.fs.create, opts('Create File Or Directory'))
  vim.keymap.set('n', 'yy', api.fs.copy.node, opts('Copy'))
  vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
  vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
  vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
  vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
  vim.keymap.set('n', 'yf', api.fs.copy.filename, opts('Copy Name'))
  vim.keymap.set('n', '<leader>yp', api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', '<leader>Yp', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
  vim.keymap.set('n', '<leader>q', api.tree.close, opts('Close'))
  vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
  vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))

  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'o', api.node.run.system, opts('Run System'))
end

return {
  {
    "kyazdani42/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { "<C-n>" },
    config = function()
      require("nvim-tree").setup({
        on_attach = on_attach,
        view = {
          adaptive_size = true,
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
