-- yank to "* register i.e. system clipboard
vim.opt.clipboard = "unnamed"

vim.opt.dictionary:append("/usr/share/dict/words")
vim.opt.complete:append("kspell")

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.number = true

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"
vim.opt.updatetime = 200
vim.opt.laststatus = 2

vim.opt.iskeyword:append("-")
