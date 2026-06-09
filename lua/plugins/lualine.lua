return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local function project_relative_path()
      local file = vim.fn.expand('%:p')

      local git_root = vim.fn.systemlist(
        'git rev-parse --show-toplevel'
      )[1]

      if git_root and git_root ~= '' then
        return file:sub(#git_root + 2)
      end

      return vim.fn.expand('%:.')
    end

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'dracula',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          {
            'branch',
            fmt = function(branch)
              return #branch > 19
                  and branch:sub(1, 17) .. '..'
                  or branch
            end,
          },
          'diff',
          'diagnostics',
        },
        lualine_c = {
          project_relative_path,
        },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    }
  end
}
