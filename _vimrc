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
set scrolloff=10

" consider '-' as part of a word
set iskeyword+=-

" -----------------------------------------------
"    rails
" -----------------------------------------------
" set filetype? to check filetype of a file
au Filetype html,xml,eruby source ~/.vim/scripts/closetag.vim
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
" -----------------------------------------------

" pry
map <Leader>bp orequire'pry'; Pry.send(:binding).pry<esc>:w<cr>

" http://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim
" copy relative path
nmap <leader>cf :let @*=expand("%")<CR>
" copy absolute path
nmap <leader>cF :let @*=expand("%:p")<CR>

let g:vroom_spec_command = 'spec '
let g:vroom_rspec_version = '1.x'
let g:vroom_cucumber_path = 'cucumber '
let g:vroom_use_vimux = 1

" yankring
"nmap <F11> :YRShow <CR>
let g:yankring_history_dir = $HOME . '/.vim/'

" mru - https://github.com/yegappan/mru/blob/master/plugin/mru.vim
let MRU_File = $HOME . '/.vim/_vim_mru_files'
" exlude . files
let MRU_Include_Files = '\.rb$\|\.haml$\|\.erb$\|\.css$\|\.sass$\|\.scss$\|\.js$'
let MRU_Window_Height = 24
nmap <F12> :MRU <CR>

if executable('ag')
  " use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " use ag in CtrlP for listing files. lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" ctrlp - https://github.com/kien/ctrlp.vim
let g:ctrlp_map = '<leader>e'

let g:ctrlp_custom_ignore = { 'dir': '\v[\/]\.(git|hg|svn)$', 'file': '\v\.(exe|so|dll)$', 'link': 'some_bad_symbolic_links' }

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

set cursorline
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
      autocmd bufwritepost .vimrc source ~/.vimrc
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

" NERDTree
map <C-e> :NERDTreeToggle <CR>

" indent - <C-o><C-o> to set cursor to original position
map <leader>= ggvG=<C-o><C-o>

" disable F1 built-in help key
:nmap <F1> :echo<CR>
:imap <F1> <C-o>:echo<CR>

" -----------------------------------------------
"   navigation
" -----------------------------------------------

noremap H ^
noremap L $

" windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" buffers
map <Right> :bn <CR>
map <Left> :bp <CR>

" tabs
"nmap <C-Right> :tabnext <CR>
"nmap <C-Left> :tabprevious <CR>

" quickfix items
noremap <Up> :cp <CR>
noremap <Down> :cn <CR>
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

nnoremap <silent> <leader>t :call <SID>StripTrailingWhitespaces()<CR>
" autocmd BufWritePre *.py,*.js :call <SID>StripTrailingWhitespaces()
" -----------------------------------------------

" /n to count # of lines containing keyword i.e. %s///n
nnoremap <leader>s :%s//

" list invisibles
"nmap <leader>l :set list! <CR>
" enable spell check
"nmap <leader>s :set spell! <CR>

" show trailing whitespace - http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=green guibg=green
match ExtraWhitespace /\s\+\%#\@<!$/
"nnoremap <leader>? :match ExtraWhitespace /\s\+\%#\@<!$/<CR>
"nnoremap <leader>? :match<CR>
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
" Folding
" zi: toggle fold (global)
" za: toggle fold (local)
" zf: create fold
" zd: delete fold

" set spell
" e.g. z=, 1z=
"
" NERDTreeBookmarks are kept in $HOME/.NERDTreeBookmarks

" http://vim.wikia.com/wiki/Mapping_keys_in_Vim_-_Tutorial_(Part_1)
"n  Normal mode map. Defined using ':nmap' or ':nnoremap'.
"i  Insert mode map. Defined using ':imap' or ':inoremap'.
"v  Visual and select mode map. Defined using ':vmap' or ':vnoremap'.
"x  Visual mode map. Defined using ':xmap' or ':xnoremap'.
"s  Select mode map. Defined using ':smap' or ':snoremap'.
"c  Command-line mode map. Defined using ':cmap' or ':cnoremap'.
"o  Operator pending mode map. Defined using ':omap' or ':onoremap'.
"
"<Space>  Normal, Visual and operator pending mode map. Defined using
"         ':map' or ':noremap'.
"!  Insert and command-line mode map. Defined using 'map!' or
"   'noremap!'.
" -----------------------------------------------
