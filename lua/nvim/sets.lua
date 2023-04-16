-- yank to "* register i.e. system clipboard
vim.cmd("set clipboard=unnamed")

vim.cmd("set dictionary+=/usr/share/dict/words")
vim.cmd("set complete+=kspell")

vim.cmd("set splitbelow")
vim.cmd("set splitright")

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
-- avoid 'safe write': https://webpack.js.org/guides/development/#adjusting-your-text-editor
vim.cmd("set backupcopy=yes")

vim.cmd("set number")
vim.cmd("set cursorline")
vim.cmd("set autoindent")

vim.cmd("set hlsearch")
vim.cmd("set incsearch")
vim.cmd("set smartcase")

vim.cmd("set backspace=indent,eol,start")
vim.cmd("set iskeyword+=-")

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set softtabstop=2")

vim.cmd("set signcolumn=yes")
vim.cmd("set updatetime=200")

vim.cmd("set cmdheight=1")
vim.cmd("set laststatus=2")

vim.opt.termguicolors = true
