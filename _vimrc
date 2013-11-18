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

" -----------------------------------------------
"    rails
" -----------------------------------------------
" set filetype? to check filetype of a file
au Filetype html,xml,eruby source ~/.vim/scripts/closetag.vim
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

" http://robots.thoughtbot.com/post/55273519322/running-specs-from-vim-sent-to-tmux-via-tslime
let g:rspec_command = 'call Send_to_Tmux("bundle exec rspec {spec}\n")'

"map <Leader>sf :call RunCurrentSpecFile()<CR>
"map <Leader>sn :call RunNearestSpec()<CR>
"map <Leader>sl :call RunLastSpec()<CR>
"map <Leader>sa :call RunAllSpecs()<CR>

" https://github.com/epeli/slimux
map <C-c><C-c> :SlimuxREPLSendLine<CR>
vmap <C-c><C-c> :SlimuxREPLSendSelection<CR>

map <leader>ff :SlimuxShellRun bundle exec cucumber <C-R>=expand(@%)<CR><CR>
map <leader>fn :SlimuxShellRun bundle exec cucumber <C-R>=expand(@%) . ":" . line(".")<CR><CR>
map <leader>sf :SlimuxShellRun bundle exec spec <C-R>=expand(@%)<CR><CR>
map <leader>sn :SlimuxShellRun bundle exec spec <C-R>=expand(@%) . ":" . line(".")<CR><CR>
" -----------------------------------------------

" yank ring
"nmap <F11> :YRShow <CR>

" ack
nmap <F10> :Ack
let g:ackprg='ag --nogroup --nocolor --column' " using ag in ack.vim

if executable('ag')
  " use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " use ag in CtrlP for listing files. lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" ctrlp - https://github.com/kien/ctrlp.vim
nmap <F5> :CtrlP<CR>

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
"let g:ctrlp_custom_ignore = {
"  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
"  \ 'file': '\v\.(exe|so|dll)$',
"  \ 'link': 'some_bad_symbolic_links',
"  \ }

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
    colorscheme zenburn
    set guioptions-=m   "remove menu bar
    set guioptions-=T   "remove toolbar
    "set guioptions-=r  "remove right-hand scroll bar

    if has("gui_macvim")
        set guifont=Monaco:h12 " :set guifont=Monaco:h10
        "set transparency=30
    elseif has("gui_win32")
        set guifont=Lucida_Console:h10:w6 " Notepad's default
    endif
else " terminal
    set t_Co=256
    if (&t_Co == 256) " if terminal supports 256 colours
        colorscheme jellybeans
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
map <leader>t :NERDTreeToggle <CR>

" indent - <C-o><C-o> to set cursor to original position
map <leader>= ggvG=<C-o><C-o>

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
map <Right> :bn<CR>
map <Left> :bp<CR>

" tabs
nmap <C-Right> :tabnext <CR>
nmap <C-Left> :tabprevious <CR>

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

nnoremap <silent> <leader>w :call <SID>StripTrailingWhitespaces()<CR>
" autocmd BufWritePre *.py,*.js :call <SID>StripTrailingWhitespaces()
" -----------------------------------------------

" /n to count # of matches i.e. %s///n
nnoremap <leader>r :%s//

" list invisibles
nmap <leader>l :set list! <CR>
" enable spell check
"nmap <leader>s :set spell! <CR>

" invisible character colors
"highlight NonText guifg=#FF0000
"highlight SpecialKey guifg=#FF0000

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

    nmap <F11> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
    imap <F11> <Esc>:set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
    "nmap <F12> :.w !pbcopy<CR><CR>
    "vmap <F12> :w !pbcopy<CR><CR>
elseif has("win32") " Windows
    " from mswin.vim
    " CTRL-X is Cut
    vnoremap <C-X> "+x
    " CTRL-C is Copy
    vnoremap <C-C> "+y
    " CTRL-V is Paste
    vnoremap <C-V> "+gP
endif

" moving around lines
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" vimwiki
let g:vimwiki_list = [{'path': '~/Dropbox/codeschool/wiki'}]

" highlight lines longer than 80 characters
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

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
