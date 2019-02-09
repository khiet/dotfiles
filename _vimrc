" ----------------------------------------
"    vim-plug
" ----------------------------------------
" automatic installation - https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" PlugInstall to install plugins, PlugClean to delete plugins, PlugUpdate to
" update plugins
" https://github.com/junegunn/vim-plug#commands
call plug#begin('~/.vim/plugged')
  " Utilities
  Plug 'https://github.com/pboettch/vim-highlight-cursor-words'
  Plug 'https://github.com/pbrisbin/vim-mkdir'
  Plug 'https://github.com/scrooloose/nerdtree'
  Plug 'https://github.com/mileszs/ack.vim'
  Plug 'https://github.com/itchyny/lightline.vim'

  " Colorscheme
  Plug 'https://github.com/morhetz/gruvbox'

  " Rails
  Plug 'https://github.com/tpope/vim-rails'

  " Note
  Plug 'https://github.com/glidenote/memolist.vim'

  " HTML
  Plug 'https://github.com/alvan/vim-closetag'

  " CSS
  Plug 'https://github.com/ap/vim-css-color'

  " Tmux
  Plug 'https://github.com/christoomey/vim-tmux-navigator'
  Plug 'https://github.com/janko-m/vim-test'
  Plug 'https://github.com/benmills/vimux'

  " Git
  Plug 'https://github.com/tpope/vim-fugitive'
  Plug 'https://github.com/airblade/vim-gitgutter'

  " JS, JSX, ES
  Plug 'https://github.com/mxw/vim-jsx'
  Plug 'https://github.com/othree/yajs.vim'
  Plug 'https://github.com/othree/es.next.syntax.vim'

  " Language Server
  Plug 'https://github.com/w0rp/ale'
call plug#end()
" ----------------------------------------

noremap <Up>    <NOP>
noremap <Down>  <NOP>
noremap <Left>  <NOP>
noremap <Right> <NOP>

let mapleader=","
inoremap jj <esc>

" edit config files
nmap <leader>ev :vs $MYVIMRC<CR>
nmap <leader>eb :vs <C-R>=expand($HOME."/.bash_profile")<CR><CR>
nmap <leader>et :vs <C-R>=expand($HOME."/.tmux.conf")<CR><CR>
" open schema.rb (from vim-rails)
nmap <leader>vs :Vschema <CR>

" buffers
nmap <leader>bu :buffers<cr>:buffer<space>
nmap <leader>bd :buffers<cr>:bdelete<space>
nmap <leader>bn :bn<CR>
nmap <leader>bp :bp<CR>

" yank
" http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
xnoremap <silent> p p:let @+=@0<CR>:let @"=@0<CR>

" gf
" recognize .js without extension
set suffixesadd=.js

" indenting
vmap << <gv
vmap >> >gv

" indent file
nmap <leader>= ggvG=<C-o><C-o>

" saving
nnoremap <leader>w :w<cr>
nnoremap <leader>x :x<cr>

" replace
nnoremap <leader>s :%s//

" noh
nnoremap <leader>h :noh<CR>

" allow backspacing over everything in i-mode
set backspace=indent,eol,start
" consider '-' as part of a word
set iskeyword+=-
" show status
set laststatus=2
" full path in status
" set statusline=%F
" 20 lines of command history
set history=20
" show cursor position at all time
set ruler
" search
set ignorecase
set incsearch
set smartcase
set number
set cursorline
set autoindent
" allow opening a new file even if there are unsaved files
set hidden
" indenting
set smartindent
" disable ~ files
set nobackup
set nowritebackup
 " disable .swap files
set noswapfile
" tabs and spaces
set expandtab " insert spaces when tab is pressed
set tabstop=2 " spaces when tab is pressed
set shiftwidth=2 " spaces for indentation
set softtabstop=2 " treat spaces like a tab when backspace is pressed

" filetype
au BufRead,BufNewFile *.inky-haml set ft=haml

" spell-checking
au BufRead,BufNewFile *.md set filetype=markdown
au FileType markdown setlocal spell
au FileType gitcommit setlocal spell

" byebug
map <leader>dr obyebug<esc>:w<cr>
" debugger
map <leader>dj odebugger;<esc>:w<cr>

" copy relative path
nmap <leader>cf :let @*=expand("%")<CR>
" copy absolute path
nmap <leader>cF :let @*=expand("%:p")<CR>

" enable mouse in terminal emulators
if has("mouse")
  set mouse=a
endif

" vim-test
let test#strategy = "vimux"
nnoremap <leader>T :TestNearest<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tf :TestFile<CR>

if executable('ag')
  " https://robots.thoughtbot.com/faster-grepping-in-vim
  " use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " https://github.com/mileszs/ack.vim#can-i-use-ag-the-silver-searcher-with-this
  let g:ackprg = 'ag --vimgrep'
endif

" Ack
nnoremap <leader>a :Ack!<space>

" fzf
set rtp+=/usr/local/opt/fzf
nnoremap <silent> <c-t> :FZF<cr>
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~25%' }

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=35

" lightline
let g:lightline = { 'component_function': { 'filename': 'LightLineFilename' } }
function! LightLineFilename()
  return expand('%')
endfunction

if $TMUX != '' " tmux specific settings
  " enable mouse in tmux
  set ttymouse=xterm2

  let g:tmux_navigator_no_mappings = 1

  nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
  nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
  nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
end

if &t_Co > 2 || has("gui_running") " &t_Co > 2 # if colors exist
  set hlsearch
endif

" ale

" see :h ale-support for a list of linters
let g:ale_fixers = { 'javascript': ['prettier', 'eslint'] }
" ['eslint', 'flow', 'jscs', 'jshint', 'prettier', 'prettier-eslint', 'prettier-standard', 'standard', 'xo']
let g:ale_linters = { 'javascript': 'all' }
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
" -----------------------------------------------
"    GUI
" -----------------------------------------------
if has("gui_running")
  colorscheme gruvbox
  set guioptions-=m   "remove menu bar
  set guioptions-=T   "remove toolbar
  "set guioptions-=r  "remove right-hand scroll bar

  if has("gui_macvim")
      " set guifont=Monaco:h10
  elseif has("gui_win32")
      set guifont=Lucida_Console:h10:w6 " Notepad's default
  endif
else " terminal
  set t_Co=256
  if (&t_Co == 256) " if terminal supports 256 colours
    colorscheme gruvbox
  endif
endif
" -----------------------------------------------

if has("autocmd")
  " http://stackoverflow.com/questions/2400264/is-it-possible-to-apply-vim-configurations-without-restarting/2400289#2400289
  augroup myvimrc
    au!
    autocmd BufWritePost .vimrc source ~/.vimrc
  augroup END
endif

" memolist
let g:memolist_path = "$HOME/Dropbox/memolist"
let g:memolist_memo_suffix = "txt"
let g:memolist_memo_date = "%d %b %Y"
nmap <leader>m :exe 'FZF' g:memolist_path<CR>

" list invisibles
"nmap <leader>l :set list!<CR>
" enable spell check
"nmap <leader>s :set spell!<CR>

highlight clear SpellBad
highlight SpellBad cterm=underline ctermfg=red gui=underline guifg=red

" gitgutter
let g:gitgutter_map_keys = 0 " turn off all key mappings
" https://github.com/airblade/vim-gitgutter#sign-column
if exists('&signcolumn')
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

" vim-closetag
let g:closetag_filenames = '*.html,*.erb,*.js,*.jsx'

" vim-highlight-cursor-words
let g:HiCursorWords_linkStyle='StatusLine'
" -----------------------------------------------
"    OS specifics
" -----------------------------------------------
" :h feature-list to check OS for specific settings
if has("mac") " Mac
  " <C-x><C-k> to complete
  " location of dictionary on Mac
  " set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words
  " set complete-=k complete+=k

  " #1 - invisibles
  set listchars=tab:»\ ,eol:$,nbsp:%,trail:~,extends:>,precedes:<

  "clipboard - http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
  set clipboard=unnamed " yank to "* register i.e. system clipboard
elseif has("win32") " Windows
  " from mswin.vim
  " CTRL-X is Cut
  vnoremap <C-X> "+x
  " CTRL-C is Copy
  vnoremap <C-C> "+y
  " CTRL-V is Paste
  vnoremap <C-V> "+gP
endif

" -----------------------------------------------
"    function
" -----------------------------------------------
" ref - http://vimcasts.org/episodes/tidying-whitespace/
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

function! <SID>ReplaceCurlyQuotes()
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/[’‘]/'/g
  %s/[”“]/"/g
  let @/=_s
  call cursor(l, c)
endfunction
" -----------------------------------------------

nnoremap <silent> <leader>t :call <SID>StripTrailingWhitespaces()<CR>
nnoremap <silent> <leader>c :call <SID>ReplaceCurlyQuotes()<CR>
" highlight trailing whitespaces
au BufWritePre * match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=red guibg=red

" replace rails params hash into { foo: 'bar', ... }
" nnoremap <leader>h :%s/"\(\w*\)"\s*=>/\1: /g <bar> :%s/,/,\r/g <bar> :noh <CR>

" -----------------------------------------------
"    cheat sheets
" -----------------------------------------------
" gx # open URL
"
" macro
" qd	start recording to register d
" ...
" q	stop recording
"
" @d	execute your macro
" @@	execute your macro again
"
" Ctrl-D  move half-page down
" Ctrl-U  move half-page up
" Ctrl-B  page up
" Ctrl-F  page down
" Ctrl-O  jump to last (older) cursor position
" Ctrl-I  jump to next cursor position (after Ctrl-O)
" Ctrl-Y  move view pane up
" Ctrl-E  move view pane down
" -----------------------------------------------
