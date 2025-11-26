return {
  {
    "akinsho/toggleterm.nvim",
    init = function()
      require("toggleterm").setup({
        float_opts = {
          width = function()
            return math.floor(vim.go.columns * 0.95)
          end,
          height = function()
            return math.floor(vim.go.lines * 0.95)
          end,
          border = 'single'
        }
      })

      -- https://github.com/akinsho/toggleterm.nvim?tab=readme-ov-file#custom-terminals
      local Terminal = require('toggleterm.terminal').Terminal

      local function create_terminal_toggle(cmd)
        local term = Terminal:new({
          cmd = cmd,
          direction = "float",
          hidden = true
        })
        return function()
          term:toggle()
        end
      end

      _lazygit_toggle = create_terminal_toggle("lazygit")
      _lazydocker_toggle = create_terminal_toggle("lazydocker")

      vim.keymap.set('n', 'tt', ":ToggleTerm direction=float<CR>",   { silent = true, noremap = true })
      vim.keymap.set('n', 'tg', "<cmd>lua _lazygit_toggle()<CR>",    { silent = true, noremap = true })
      vim.keymap.set('n', 'td', "<cmd>lua _lazydocker_toggle()<CR>", { silent = true, noremap = true })
    end
  }
}
