require("nvim.remap")
require("nvim.lazy")

-- disable command-line window
vim.keymap.set('n', 'q:', '<NOP>', { noremap = true })
-- disable ex-mode
vim.keymap.set('n', 'Q', '<NOP>', { noremap = true })

vim.keymap.set('n', '<Up>', '<NOP>', { noremap = true })
vim.keymap.set('n', '<Down>', '<NOP>', { noremap = true })
vim.keymap.set('n', '<Left>', '<NOP>', { noremap = true })
vim.keymap.set('n', '<Right>', '<NOP>', { noremap = true })

vim.keymap.set('n', 'Q', 'q', { noremap = true })
vim.keymap.set('n', 'q', '<NOP>', { noremap = true })

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

vim.cmd([[set listchars=tab:»\ ,eol:$,nbsp:%,trail:~,extends:>,precedes:<]])
vim.cmd('colorscheme dracula_pro')
vim.cmd('set termguicolors')

vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { noremap = true })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { noremap = true })

vim.keymap.set('n', '<leader>w', vim.cmd.w, { noremap = true })
vim.keymap.set('n', '<leader>x', vim.cmd.x, { noremap = true })
vim.keymap.set('n', '<leader>q', vim.cmd.q, { noremap = true })
vim.keymap.set('n', '<leader>Q', "vim.cmd.q!", { noremap = true })
vim.keymap.set('n', '<leader>=', "<C-w>=", { noremap = true })

vim.keymap.set({'n', 'v'}, '<<', '<gv', { noremap = true })
vim.keymap.set({'n', 'v'}, '>>', '>gv', { noremap = true })

vim.keymap.set('n', '[b', vim.cmd.bp, { silent = true, noremap = true })
vim.keymap.set('n', ']b', vim.cmd.bn, { silent = true, noremap = true })
vim.keymap.set('n', '<leader>bd', vim.cmd.bd, { noremap = true })

vim.keymap.set('n', '<leader>h', vim.cmd.noh, { noremap = true })
-- switch between the last two files
vim.keymap.set('n', '<leader><leader>', '<C-^>', { noremap = true })

vim.keymap.set('n', '<leader>s', ":%s//", { noremap = true })
-- ❓vim.keymap.set({'n', 'v'}, '<leader>s', ":s//", { noremap = true })

-- https://vi.stackexchange.com/a/22889
-- ❓vim.keymap.set('n', '<leader>k', "<Cmd>let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<CR>", { noremap = true })

-- vim_current_word
vim.cmd("hi CurrentWord gui=underline")
vim.cmd("hi CurrentWordTwins gui=underline")

-- vim-easy-align
vim.keymap.set({'n', 'x'}, 'ga', "<Plug>(EasyAlign)", { noremap = true })
vim.keymap.set('n', 'ga', "<Plug>(EasyAlign)", { noremap = true })

-- vim-polyglot
vim.g.csv_no_conceal = 1
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_markdown_conceal = 0
