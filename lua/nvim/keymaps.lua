vim.g.mapleader = " "
vim.g.maplocalleader = " "

local set = vim.keymap.set

local opt_n = { noremap = true }
local opt_sn = { silent = true, noremap = true }

-- disable command-line window
set('n', 'q:', '<NOP>', opt_n)
-- disable ex-mode
set('n', 'Q', '<NOP>', opt_n)

set('n', 'Q', 'q', opt_n)
set('n', 'q', '<NOP>', opt_n)

set('n', '<Up>', '<NOP>', opt_n)
set('n', '<Down>', '<NOP>', opt_n)
set('n', '<Left>', '<NOP>', opt_n)
set('n', '<Right>', '<NOP>', opt_n)

set('n', '<C-j>', '<C-w><C-j>', opt_n)
set('n', '<C-k>', '<C-w><C-k>', opt_n)
set('n', '<C-l>', '<C-w><C-l>', opt_n)
set('n', '<C-h>', '<C-w><C-h>', opt_n)

set('n', '<leader>w', vim.cmd.w, opt_n)
set('n', '<leader>W', vim.cmd.wa, opt_n)
set('n', '<leader>x', vim.cmd.x, opt_n)
set('n', '<leader>X', vim.cmd.xa, opt_n)
set('n', '<leader>q', vim.cmd.q, opt_n)
set('n', '<leader>Q', ":q!<CR>", opt_n)
set('n', '<leader>e', ":e!<CR>", opt_n)

-- http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
set('x', 'p', [[p:let @+=@0<CR>:let @"=@0<CR>]], opt_sn)

-- switch between the last two files
set('n', '<leader><leader>', '<C-^>', opt_n)

set({ 'n', 'v' }, '<<', '<gv', opt_n)
set({ 'n', 'v' }, '>>', '>gv', opt_n)

set('n', '<leader>=', "<C-w>=", opt_n)

set('n', '[b', vim.cmd.bp, opt_sn)
set('n', ']b', vim.cmd.bn, opt_sn)

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(args)
    local bufnr = args.buf
    local term_name = vim.api.nvim_buf_get_name(bufnr)

    -- only apply <Esc> mapping if NOT lazygit
    if not term_name:find("lazygit") then
      vim.keymap.set('t', '<Esc>', [[<C-\><C-N>]], { buffer = bufnr, noremap = true, silent = true })
    end
  end,
})

set('n', '[q', vim.cmd.cp, opt_sn)
set('n', ']q', vim.cmd.cn, opt_sn)

set('n', '<leader>h', vim.cmd.noh, opt_n)

set({ 'n', 'v' }, '<leader>s', [[:s//]], opt_n)
set('n', '<leader>s', [[:%s//]], opt_n)

-- https://vi.stackexchange.com/a/22889
set('n', '<leader>k', [[<Cmd>let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<CR>]], opt_n)

set("n", "J", "mzJ`z", opt_n)
set("n", "<C-d>", "<C-d>zz", opt_n)
set("n", "<C-u>", "<C-u>zz", opt_n)

set('n', '+', '<C-w>5+', opt_n)
set('n', '_', '<C-w>5-', opt_n)
set('n', '-', '<C-w>5<', opt_n)
set('n', '=', '<C-w>5>', opt_n)

set("n", "<leader>yp", ":let @+ = expand('%:.') . ':' . line('.')<CR>", opt_n)

set("n", "<leader>ev", ':e <C-R>=expand($HOME."/dotfiles/lua/nvim/keymaps.lua")<CR><CR>', opt_n)
set("n", "<leader>ez", ':e <C-R>=expand($HOME."/dotfiles/_zshrc")<CR><CR>', opt_n)
set("n", "<leader>et", ':e <C-R>=expand($HOME."/dotfiles/tmux/_tmux.conf")<CR><CR>', opt_n)
set("n", "<leader>eo", ':e <C-R>=expand($HOME."/dotfiles/opencode/_opencode.jsonc")<CR><CR>', opt_n)
