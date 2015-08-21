" Pathogen
call pathogen#infect()
call pathogen#helptags()

let mapleader=","
inoremap jj <Esc>

"\ to go back for the f{char} search
nnoremap \ ,

set wildignore+=*/tmp/*,*.so,*.swp,*.zip " mac/linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe " windows

set laststatus=2


" consider '-' as part of a word
set iskeyword+=-

au Filetype html,xml,eruby source ~/.vim/scripts/closetag.vim
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

" pry
"map <leader>bp orequire 'pry-remote'; binding.remote_pry<esc>:w<cr>
map <leader>bp orequire'pry'; Pry.send(:binding).pry<esc>:w<cr>

" http://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim
" copy relative path
nmap <leader>cf :let @*=expand("%")<CR>
" copy absolute path
nmap <leader>cF :let @*=expand("%:p")<CR>
nmap <F12> :let @*=expand("%") . ':' . line(".")<CR>

let g:vroom_spec_command = 'spec '
let g:vroom_rspec_version = '1.x'
let g:vroom_cucumber_path = 'cucumber '
let g:vroom_use_vimux = 1

nmap <F9> :set filetype=ruby<CR>

if executable('ag')
  " use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " use ag in ctrlp for listing files (it respects .gitignore)
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that ctrlp doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

noremap H ^
noremap L $

" allow backspacing over everything in i-mode
set backspace=indent,eol,start

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
end

if &t_Co > 2 || has("gui_running") " &t_Co > 2 # if colors exist
    syntax on
    set hlsearch
endif

" -----------------------------------------------
"    GUI
" -----------------------------------------------
if has("gui_running")
    colorscheme tomorrow-night-eighties "jellybeans
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
      colorscheme tomorrow-night-eighties "jellybeans
    endif
endif

" -----------------------------------------------
"   general preferences
" -----------------------------------------------
set history=50 " 50 lines of command history
set ruler " show cursor position at all time
"set showcmd

" searching
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
"set autoindent
"set wrapscan
" -----------------------------------------------

if has("autocmd")
    filetype plugin indent on
    " For all text files, set 'textwidth' to 78 characters.
    "autocmd FileType text setlocal textwidth=78

    "autocmd Filetype xml* set filetype=xml (for showing Android's .xml* files)
    "autocmd FileType html,css,scss,ruby,pml setlocal ts=2 sts=2 sw=2 expandtab
    "autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
    "autocmd FileType markdown setlocal wrap linebreak nolist
    "autocmd BufNewFile,BufRead *.rss setfiletype xml

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

" editting config files
nmap <leader>ev :tabedit $MYVIMRC<CR>
nmap <leader>eb :tabedit <C-R>=expand($HOME."/.bash_profile")<CR><CR>
nmap <leader>et :tabedit <C-R>=expand($HOME."/.tmux.conf")<CR><CR>

" #5 - indenting
vmap << <gv
vmap >> >gv

" disable F1 built-in help key
:nmap <F1> :echo<CR>
:imap <F1> <C-o>:echo<CR>

" -----------------------------------------------
"   navigation
" -----------------------------------------------

" windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" buffers
"nnoremap <C-Right> :bn<CR>
"nnoremap <C-Left> :bp<CR>

" tabs
"nmap <C-Right> :tabnext<CR>
"nmap <C-Left> :tabprevious<CR>

" ctrlp
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
let g:ctrlp_custom_ignore = { 'dir':  '\v[\/]\.(git|hg|svn)$', 'file': '\v\.(exe|so|dll)$', 'link': 'some_bad_symbolic_links' }

"nmap <leader>m :CtrlPMRU<CR>
"nmap <leader>b :CtrlPBuffer<CR>

" -----------------------------------------------

" -----------------------------------------------
"   function
" -----------------------------------------------
function! DosToUnixLineEnding()
    :update
    :e ++ff=dos
    :setlocal ff=unix
    :w
endfunction

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

" /n to count # of lines containing keyword i.e. %s///n
nnoremap <leader>s :%s//
nnoremap <leader>h :%s/:\([^ ]*\)\(\s*\)=>/\1:/g

" list invisibles
"nmap <leader>l :set list!<CR>
" enable spell check
"nmap <leader>s :set spell!<CR>

highlight ExtraWhitespace ctermbg=red guibg=red
au BufWritePre * match ExtraWhitespace /\s\+$/

" show a vertical line
"set colorcolumn=100
"highlight ColorColumn ctermbg=red guibg=red

" -----------------------------------------------
"    OS specifics
" -----------------------------------------------
" :h feature-list to check OS for specific settings
if has("mac") " Mac
    " <C-x><C-k> to complete
    "  location of dictionary on Mac
    set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words
    set complete-=k complete+=k

    " #1 - invisibles
    " <C-v>u<hex> to insert unicode
    set listchars=tab:»\ ,eol:$,nbsp:%,trail:~,extends:>,precedes:<

    "clipboard - http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
    "get tmux to play nice with clipboard - https://coderwall.com/p/j9wnfw
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
"     Cheat Sheets
" -----------------------------------------------
" tmux
" cmd, % # split vertically
" cmd, " # split horizontally
"
" gx # open URL
"
" Folding
" zi: toggle fold (global)
" za: toggle fold (local)
" zf: create fold
" zd: delete fold

" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)
" -----------------------------------------------
