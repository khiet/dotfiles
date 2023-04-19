return {
  {
    "ThePrimeagen/harpoon",
    keys = { "<leader>a", "<C-e>" },
    config = function()
      require("harpoon").setup({
        menu = {
          width = 120
        }
      })

      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file)
      vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
    end
  }
}
