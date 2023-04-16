return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      local builtin = require('telescope.builtin')

      require('telescope').setup({
        defaults = {
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
          },
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-u>"] = false,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = {
              "rg",
              "--files",
              "--sort",
              "path",
            },
          },
        },
      })

      vim.keymap.set('n', '<C-f>', builtin.find_files, { noremap = true })
      vim.keymap.set('n', '<C-g>', builtin.git_status, { noremap = true })
      vim.keymap.set('n', '<leader>g', function() builtin.live_grep({ disable_coordinates = true }) end, { noremap = true })
      vim.keymap.set('n', '<leader>G', function() builtin.grep_string({ disable_coordinates = true }) end, { noremap = true })

      vim.keymap.set(
        'n',
        '<leader>mf',
        function()
          require("telescope.builtin").find_files({ cwd = (os.getenv("DEVS_HOME") .. "/vim/notes") })
        end,
        { noremap = true }
      )
    end
  }
}
