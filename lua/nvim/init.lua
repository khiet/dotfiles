require("nvim.remap")
require("nvim.lazy")

-- yank to "* register i.e. system clipboard
vim.cmd("set clipboard=unnamed")

vim.cmd("set dictionary+=/usr/share/dict/words")
vim.cmd("set complete+=kspell")

vim.cmd("set splitbelow")
vim.cmd("set splitright")

vim.cmd([[set listchars=tab:»\ ,eol:$,nbsp:%,trail:~,extends:>,precedes:<]])
vim.cmd('colorscheme dracula')

vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { noremap = true })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { noremap = true })

vim.keymap.set('n', '<leader>w', vim.cmd.w, { noremap = true })
vim.keymap.set('n', '<leader>x', vim.cmd.x, { noremap = true })
vim.keymap.set('n', '<leader>q', vim.cmd.q, { noremap = true })
vim.keymap.set('n', '<leader>Q', "vim.cmd.q!", { noremap = true })
vim.keymap.set('n', '<leader>=', "<C-w>=", { noremap = true })

-- disable command-line window
vim.keymap.set('n', 'q:', '<NOP>', { noremap = true })
-- disable ex-mode
vim.keymap.set('n', 'Q', '<NOP>', { noremap = true })

vim.keymap.set('n', '<Up>', '<NOP>', { noremap = true })
vim.keymap.set('n', '<Down>', '<NOP>', { noremap = true })
vim.keymap.set('n', '<Left>', '<NOP>', { noremap = true })
vim.keymap.set('n', '<Right>', '<NOP>', { noremap = true })

vim.keymap.set('n', '<leader>h', vim.cmd.noh, { noremap = true })
-- switch between the last two files
vim.keymap.set('n', '<leader><leader>', '<C-^>', { noremap = true })

vim.keymap.set('n', '<leader>s', ":%s//", { noremap = true })
-- ❓vim.keymap.set({'n', 'v'}, '<leader>s', ":s//", { noremap = true })
