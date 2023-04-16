vim.g.mapleader = " "

vim.keymap.set("n", "<leader>ev", ':e <C-R>=expand($HOME."/dotfiles/lua/nvim/")<CR><CR>', { noremap = true })
vim.keymap.set("n", "<leader>ez", ':e <C-R>=expand($HOME."/dotfiles/_zshrc")<CR><CR>', { noremap = true })
vim.keymap.set("n", "<leader>et", ':e <C-R>=expand($HOME."/dotfiles/_tmux.conf")<CR><CR>', { noremap = true })
