return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      local builtin = require("telescope.builtin")

      vim.keymap.set('n', '<C-f>', builtin.find_files, { noremap = true })
      vim.keymap.set('n', '<C-g>', builtin.git_status, { noremap = true })
      vim.keymap.set('n', '<C-b>', builtin.buffers, { noremap = true })
      vim.keymap.set(
        'n',
        '<leader>g',
        function() builtin.live_grep({ disable_coordinates = true }) end,
        { noremap = true }
      )
      vim.keymap.set(
        'n',
        '<leader>G',
        function() builtin.grep_string({ disable_coordinates = true }) end,
        { noremap = true }
      )
      vim.keymap.set(
        'n',
        '<leader>mf',
        function()
          require("telescope.builtin").find_files({ cwd = (os.getenv("HOME") .. "/notes") })
        end,
        { noremap = true }
      )
    end,
    config = function()
      local actions = require("telescope.actions")

      -- default_mappings: https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L133
      require('telescope').setup({
        defaults = {
          sorting_strategy = 'ascending',
          layout_strategy = 'flex',
          layout_config = {
            horizontal = {
              height = 0.9,
              preview_cutoff = 120,
              prompt_position = "top",
              width = 0.8
            },
            vertical = {
              height = 0.9,
              preview_cutoff = 40,
              prompt_position = "top",
              mirror = true,
              width = 0.8
            }
          },
          vimgrep_arguments = {
            "rg",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--hidden",
            "--sort",
            "path",
          },
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-k>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.cycle_history_next,
              ["<C-d>"] = actions.delete_buffer,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--sort",
              "path",
            },
          },
        },
      })
    end
  }
}
