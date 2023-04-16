require("nvim.remap")
require("nvim.lazy")

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

vim.cmd('colorscheme dracula_pro')
vim.cmd('set termguicolors')

vim.cmd("au BufWinEnter *.md setlocal syntax=markdown")

-- highlight trailing whitespaces
vim.cmd([[au BufWritePre * match ExtraWhitespace /\s\+$/]])
vim.cmd("hi ExtraWhitespace guibg=#ff5555")

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

-- vim-argwrap
vim.keymap.set('n', 'gS', vim.cmd.ArgWrap, { silent = true, noremap = true })

-- markdown-preview
vim.keymap.set('n', '<leader>em', "<Plug>MarkdownPreviewToggle", { noremap = true })

-- functions
function delete_trailing_whitespaces()
  local s = vim.fn.getreg('/')
  local l = vim.fn.line('.')
  local c = vim.fn.col('.')

  vim.cmd('%s/\\s\\+$//e')

  vim.fn.setreg('/', s)
  vim.fn.cursor(l, c)
end

vim.keymap.set('n', '<leader>td', delete_trailing_whitespaces, { noremap = true })
-- vim.keymap.set('n', '<leader>cq', replace_curly_quotes, { noremap = true })
