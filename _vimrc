" PlugInstall, PlugClean, PlugUpdate
call plug#begin('~/.vim/plugged')
  Plug 'https://github.com/simeji/winresizer'
  Plug 'https://github.com/itchyny/lightline.vim'

  if has('nvim')
    Plug 'https://github.com/williamboman/mason.nvim', {'branch': 'main'}
    Plug 'https://github.com/williamboman/mason-lspconfig.nvim', {'branch': 'main'}
    Plug 'https://github.com/norcalli/nvim-colorizer.lua'
    Plug 'https://github.com/nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'https://github.com/neovim/nvim-lspconfig'
    Plug 'https://github.com/kyazdani42/nvim-tree.lua'
    Plug 'https://github.com/ggandor/leap.nvim', {'branch': 'main'}
    Plug 'https://github.com/hrsh7th/nvim-cmp', {'branch': 'main'}
    Plug 'https://github.com/hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
    Plug 'https://github.com/saadparwaiz1/cmp_luasnip'
    Plug 'https://github.com/L3MON4D3/LuaSnip', {'tag': '*'}
    Plug 'https://github.com/johmsalas/text-case.nvim', {'branch': 'main'}
    Plug 'https://github.com/numToStr/Comment.nvim'

    " Rust
    Plug 'https://github.com/simrat39/rust-tools.nvim'

    " Markdown
    Plug 'https://github.com/iamcco/markdown-preview.nvim', {'do': 'cd app && yarn install'}
  endif

  " HTML
  Plug 'https://github.com/alvan/vim-closetag'
  Plug 'https://github.com/AndrewRadev/tagalong.vim'

  " Wiki
  Plug 'https://github.com/vimwiki/vimwiki', {'branch': 'dev'}
call plug#end()

" tabs
nnoremap <silent> ]t :tabn<CR>
nnoremap <silent> [t :tabp<CR>
nnoremap <leader>ts :tab split<CR>
nnoremap <leader>te :tabedit<CR>
nnoremap <leader>tc :tabclose<CR>

" quickfix
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprev<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [l :lprev<CR>

" reload
nnoremap <leader>e :e!<CR>

" yank
" http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
xnoremap <silent> p p:let @+=@0<CR>:let @"=@0<CR>

" recognize .js without extension when gf
set suffixesadd=.js

" filetype
au BufRead,BufNewFile *.inky-haml set filetype=haml
au BufRead,BufNewFile tsconfig.json set filetype=jsonc

" spell-checking
au BufRead,BufNewFile *.md set filetype=markdown
au FileType markdown setlocal spell
au FileType gitcommit setlocal spell

" lightline
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'dracula',
  \ }

hi clear SpellBad
hi SpellBad gui=underline guifg=#ff5555

" fzf
nnoremap <silent> <C-F> :Files<CR>
nnoremap <silent> <C-B> :Buffers<CR>
nnoremap <silent> <C-G> :GFiles?<CR>

nnoremap <silent> <D-E> :GFiles?<CR>

" nnoremap <silent> <c-?> :Commits<CR>
nnoremap <leader>g :RG 
let g:fzf_action = { 'ctrl-l': 'edit', 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.9 } }
let g:fzf_preview_window = ['down:75%']

" https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration
function! RipgrepFzf(query, fullscreen, directory = '.')
  let command_fmt = 'rg --sort-files --column --line-number --no-heading --color=always --smart-case -- %s --files ' . a:directory . ' || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
command! -nargs=* -bang RGW call RipgrepFzf(<q-args>, <bang>0, '$DEVS_HOME/vim/notes')

" vim-closetag
let g:closetag_filenames = '*.html,*.erb,*.js,*.jsx,*.vue'
" tagalong
let g:tagalong_filetypes = ['html', 'xml', 'eruby', 'javascript', 'javascriptreact', 'typescriptreact', 'vue']

" -----------------------------------------------
"    function
" -----------------------------------------------
function IsAJavascript()
  return index(['javascript', 'typescript', 'typescriptreact', 'html', 'json'], &filetype) != -1
endfunction

function! ReplaceCurlyQuotes()
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/[’‘]/'/g
  %s/[”“]/"/g
  let @/=_s
  call cursor(l, c)
endfunction

" ctags: http://vim.wikia.com/wiki/Autocmd_to_update_ctags_file
function! RunCtags()
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"
  let cmd = 'ctags -R -f ' . tagfilename
  let resp = system(cmd)
endfunction

function! AddDebugBreakpoint()
  if IsAJavascript()
    r!echo 'debugger;'
    write
  elseif index(['ruby', 'haml'], &filetype) != -1
    r!echo "require 'debug'; debugger"
    write
  endif
endfunction

function! RunScript()
  if &filetype == 'javascript'
    call VimuxRunCommand("node " . bufname("%"))
  elseif &filetype == 'ruby'
    call VimuxRunCommand("ruby -w " . bufname("%"))
  elseif &filetype == 'rust'
    call VimuxRunCommand("cargo run")
  elseif &filetype == 'sh'
    call VimuxRunCommand("./" . bufname("%"))
  endif
endfunction

" http://vimcasts.org/episodes/tidying-whitespace/
function! DeleteTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

function! CreateSpecFile()
  silent execute '!ruby ~/dotfiles/scripts/create_spec_file.rb' expand("%:p")
endfunction

function! ConsoleLog()
  execute "normal! yiwo" . "console.log" . "('')\<C-[>F';a\<C-[>pf'a, \<C-[>p<CR>"
endfunction

function! SearchDictionary()
  silent execute '!open "https://dictionary.cambridge.org/dictionary/english/' . expand('<cword>') . '"'
endfunction
" -----------------------------------------------

nnoremap <silent> <leader>cd :call AddDebugBreakpoint()<CR>
nnoremap <silent> <leader>cl :call ConsoleLog()<CR>
nnoremap <silent> <leader>cq :call ReplaceCurlyQuotes()<CR>
nnoremap <silent> <leader>ct :call RunCtags()<CR>
nnoremap <silent> <leader>cs :call RunScript()<CR>
nnoremap <silent> <leader>cD :call SearchDictionary()<CR>
nnoremap <silent> <leader>rc :call CreateSpecFile()<CR>
nnoremap <silent> <leader>td :call DeleteTrailingWhitespaces()<CR>

if has('nvim')
  lua require('vimrc_lua_config')

  " text-case
  nnoremap gas :lua require('textcase').current_word('to_snake_case')<CR>
  nnoremap gak :lua require('textcase').current_word('to_dash_case')<CR>
  nnoremap gac :lua require('textcase').current_word('to_camel_case')<CR>
  nnoremap gap :lua require('textcase').current_word('to_pascal_case')<CR>
end
