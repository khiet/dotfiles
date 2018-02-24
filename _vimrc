" ----------------------------------------
" vim-plug
" ----------------------------------------
" automatic installation - https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" PlugInstall to install plugins, PlugClean to delete plugins
call plug#begin('~/.vim/plugged')
  Plug 'https://github.com/tpope/vim-rails'
  Plug 'https://github.com/benmills/vimux'
  Plug 'https://github.com/skalnik/vim-vroom'
  Plug 'https://github.com/tpope/vim-fugitive'
  Plug 'https://github.com/airblade/vim-gitgutter'
  Plug 'https://github.com/ihacklog/hicursorwords'
  Plug 'https://github.com/pbrisbin/vim-mkdir'
  Plug 'https://github.com/christoomey/vim-tmux-navigator'
  Plug 'https://github.com/glidenote/memolist.vim'
  Plug 'https://github.com/scrooloose/nerdtree'
call plug#end()
" ----------------------------------------

let mapleader=","
inoremap jj <esc>

noremap H ^
noremap L $

" allow backspacing over everything in i-mode
set backspace=indent,eol,start

" consider '-' as part of a word
set iskeyword+=-
" show status
set laststatus=2
" full path in status
set statusline=%F

" filetype and syntax
au BufRead,BufNewFile *.inky-haml set ft=haml

" byebug
map <leader>bb obyebug<esc>:w<cr>
" console
map <leader>cl oconsole<esc>:w<cr>

" copy relative path
nmap <leader>cf :let @*=expand("%")<CR>
" copy absolute path
nmap <leader>cF :let @*=expand("%:p")<CR>

" vroom
if filereadable("bin/rspec")
  let g:vroom_use_binstubs = 1
endif

let g:vroom_spec_command  = 'rspec --format progress'
let g:vroom_rspec_version = '3.x'
let g:vroom_use_vimux = 1

if executable('ag')
  " https://robots.thoughtbot.com/faster-grepping-in-vim
  " use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" fzf
set rtp+=/usr/local/opt/fzf
nnoremap <silent> <c-t> :FZF<cr>
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~25%' }

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=35

set nobackup " disable ~ files
set nowritebackup
set noswapfile " disable .swap files

" enable mouse in terminal emulators
if has("mouse")
  set mouse=a
endif

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

" -----------------------------------------------
"    GUI
" -----------------------------------------------
if has("gui_running")
  colorscheme tomorrow-night
  set guioptions-=m   "remove menu bar
  set guioptions-=T   "remove toolbar
  "set guioptions-=r  "remove right-hand scroll bar

if has("gui_macvim")
    set guifont=Monaco:h10 " :set guifont=Monaco:h10
    "set transparency=30
elseif has("gui_win32")
    set guifont=Lucida_Console:h10:w6 " Notepad's default
endif
else " terminal
  set t_Co=256
  if (&t_Co == 256) " if terminal supports 256 colours
    colorscheme tomorrow-night
  endif
endif
" -----------------------------------------------

set history=50 " 50 lines of command history
set ruler " show cursor position at all time

" search
set ignorecase
set incsearch
set smartcase

"set cursorline
set number
set autoindent

" hidden buffer
set hidden

" indenting
set smartindent

if has("autocmd")
  " http://stackoverflow.com/questions/2400264/is-it-possible-to-apply-vim-configurations-without-restarting/2400289#2400289
  augroup myvimrc
    au!
    autocmd BufWritePost .vimrc source ~/.vimrc
  augroup END
endif

" #2 - tabs and spaces
set expandtab " insert spaces when tab is pressed
set tabstop=2 " spaces when tab is pressed
set shiftwidth=2 " spaces for indentation
set softtabstop=2 " treat spaces like a tab when backspace is pressed

" edit config files
nmap <leader>ev :tabedit $MYVIMRC<CR>
nmap <leader>eb :tabedit <C-R>=expand($HOME."/.bash_profile")<CR><CR>
nmap <leader>et :tabedit <C-R>=expand($HOME."/.tmux.conf")<CR><CR>

" #5 - indenting
vmap << <gv
vmap >> >gv

" disable F1 built-in help key
:nmap <F1> :echo<CR>
:imap <F1> <C-o>:echo<CR>

" saving
nnoremap <leader>w :w<cr>
nnoremap <leader>x :x<cr>

" replace
nnoremap <leader>s :%s//

" memolist
let g:memolist_path = "$HOME/Dropbox/memolist"
let g:memolist_memo_suffix = "txt"
let g:memolist_memo_date = "%d %b %Y"
nmap <leader>m :exe 'FZF' g:memolist_path<CR>

" list invisibles
"nmap <leader>l :set list!<CR>
" enable spell check
"nmap <leader>s :set spell!<CR>

highlight ExtraWhitespace ctermbg=red guibg=red
au BufWritePre * match ExtraWhitespace /\s\+$/

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

" vim-gutter
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
let g:gitgutter_map_keys = 0 " turn off all key mappings

" -----------------------------------------------
"   function
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
" -----------------------------------------------

nnoremap <silent> <leader>t :call <SID>StripTrailingWhitespaces()<CR>

" -----------------------------------------------
"     Cheat Sheets
" -----------------------------------------------
" gx # open URL
"
" folding
" zi: toggle fold (global)
" za: toggle fold (local)
" zf: create fold
" zd: delete fold

" macro
" qd	start recording to register d
" ...
" q	stop recording
"
" @d	execute your macro
" @@	execute your macro again
"
" f{char} search
" ; to go forward
" , to go backward
" -----------------------------------------------
