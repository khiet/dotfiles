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
      local lazygit  = Terminal:new({
        cmd = "lazygit",
        direction = "float",
        hidden = true
      })

      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.keymap.set('n', 'gl', "<cmd>lua _lazygit_toggle()<CR>", { silent = true, noremap = true })
      vim.keymap.set('n', 'tt', ":ToggleTerm direction=float<CR>", { silent = true, noremap = true })
    end
  }
}
