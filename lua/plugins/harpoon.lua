return {
  {
    "ThePrimeagen/harpoon",
    keys = { "<leader>a", "<C-m>" },
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file)
      vim.keymap.set("n", "<C-m>", ui.toggle_quick_menu)
    end
  }
}
