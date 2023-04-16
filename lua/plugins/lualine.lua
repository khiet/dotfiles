return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = false,
        theme = 'dracula',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          {
            'filename',
            path = 1
          }
        },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    }
  end
}
