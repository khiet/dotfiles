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
  Plug 'https://github.com/dominikduda/vim_current_word'
  Plug 'https://github.com/pbrisbin/vim-mkdir'
  Plug 'https://github.com/scrooloose/nerdtree'
  Plug 'https://github.com/mileszs/ack.vim'
  Plug 'https://github.com/itchyny/lightline.vim'
  Plug 'https://github.com/tpope/vim-surround'
  Plug 'https://github.com/junegunn/vim-easy-align'

  " Colorscheme
  Plug 'https://github.com/morhetz/gruvbox'
  Plug 'https://github.com/joshdick/onedark.vim'

  " Tmux
  Plug 'https://github.com/christoomey/vim-tmux-navigator'
  Plug 'https://github.com/janko-m/vim-test'
  Plug 'https://github.com/benmills/vimux'

  " Git
  Plug 'https://github.com/tpope/vim-fugitive'
  Plug 'https://github.com/airblade/vim-gitgutter'

  " Rails
  Plug 'https://github.com/tpope/vim-rails'

  " HTML
  Plug 'https://github.com/alvan/vim-closetag'

  " CSS
  Plug 'https://github.com/ap/vim-css-color'

  " JS, JSX, ES
  Plug 'https://github.com/mxw/vim-jsx'
  Plug 'https://github.com/othree/yajs.vim'
  Plug 'https://github.com/othree/es.next.syntax.vim'

  Plug 'https://github.com/w0rp/ale'

  " Note
  Plug 'https://github.com/glidenote/memolist.vim'

  " Flutter
  Plug 'https://github.com/dart-lang/dart-vim-plugin'
  Plug 'https://github.com/thosakwe/vim-flutter'

  " LSC
  " Plug 'https://github.com/natebosch/vim-lsc'
  " Plug 'https://github.com/natebosch/vim-lsc-dart'
call plug#end()
" ----------------------------------------

noremap <Up>    <NOP>
noremap <Down>  <NOP>
noremap <Left>  <NOP>
noremap <Right> <NOP>

let mapleader=" "

" edit config files
nnoremap <leader>ev :tabedit $MYVIMRC<CR>
nnoremap <leader>eb :tabedit <C-R>=expand($HOME."/.bash_profile")<CR><CR>
nnoremap <leader>ez :tabedit <C-R>=expand($HOME."/.zshrc")<CR><CR>
nnoremap <leader>et :tabedit <C-R>=expand($HOME."/.tmux.conf")<CR><CR>

" buffers
nnoremap <leader>bu :buffers<cr>:buffer<space>
nnoremap <leader>bd :buffers<cr>:bdelete<space>
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>

" indent file
nnoremap <leader>= ggvG=<C-o><C-o>

" saving
nnoremap <leader>w :w<cr>
nnoremap <leader>x :x<cr>

" replace
nnoremap <leader>s :%s//

" noh
nnoremap <leader>h :noh<CR>

" reload
nnoremap <leader>e :e!<CR>

" set cursorcolumn
nnoremap <leader>cc :set cursorcolumn!<CR>

" copy relative path
nnoremap <leader>cf :let @*=expand("%")<CR>
" copy absolute path
nnoremap <leader>cF :let @*=expand("%:p")<CR>

" list invisibles
nnoremap <leader>ls :set list!<CR>

" enable spell check
"nnoremap <leader>sp :set spell!<CR>

" Ack
nnoremap <leader>a :Ack!<space>

" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" yank
" http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
xnoremap <silent> p p:let @+=@0<CR>:let @"=@0<CR>

" switch between the last two files
" https://github.com/thoughtbot/dotfiles/blob/master/vimrc#L128
nnoremap <Leader><Leader> <C-^>

" indenting
vnoremap << <gv
vnoremap >> >gv

inoremap jj <esc>

" byebug
noremap <leader>dr obyebug<esc>:w<cr>
" debugger
noremap <leader>dj odebugger;<esc>:w<cr>

set hlsearch
" gf
" recognize .js without extension
set suffixesadd=.js
" allow backspacing over everything in i-mode
set backspace=indent,eol,start
" consider '-' as part of a word
set iskeyword+=-
" show status
set laststatus=2
set title
set titlestring=%F
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
" autocomplete with dictionary words when spell check is on
set complete+=kspell

" enable mouse in terminal emulators
if has("mouse")
  set mouse=a
endif

" dart
let dart_style_guide = 2
let dart_format_on_save = 1

" lsc
" let g:lsc_auto_map = v:true

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

" fzf
set rtp+=/usr/local/opt/fzf
nnoremap <silent> <c-t> :FZF<cr>
let g:fzf_action = { 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~25%' }

" NERDTree
noremap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=35

" lightline
let g:lightline = { 'component_function': { 'filename': 'LightLineFilename' }, 'colorscheme': 'onedark' }
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

" ale

" see :h ale-support for a list of linters
let g:ale_fixers           = { 'javascript': ['prettier', 'eslint'], 'ruby': 'rubocop' }
let g:ale_linters          = { 'javascript': 'all', 'ruby': 'all' }
let g:ale_linters_explicit = 1
let g:ale_fix_on_save      = 1
" -----------------------------------------------
"    GUI
" -----------------------------------------------
if has("gui_running")
  colorscheme onedark
  set guioptions-=m   "remove menu bar
  set guioptions-=T   "remove toolbar
  "set guioptions-=r  "remove right-hand scroll bar
else " terminal
  set t_Co=256
  if (&t_Co == 256) " if terminal supports 256 colours

    " true colour
    if exists('+termguicolors')
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      set termguicolors
    endif

    colorscheme onedark
  endif
endif
" -----------------------------------------------

" vim_current_word
hi CurrentWord ctermbg=56
" hi CurrentWordTwins ctermbg=237

" highlight trailing whitespaces
au BufWritePre * match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=red guibg=red

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
nnoremap <leader>m :exe 'FZF' g:memolist_path<CR>

highlight clear SpellBad
highlight SpellBad cterm=underline ctermfg=red gui=underline guifg=red

" gitgutter
let g:gitgutter_map_keys = 0 " turn off all key mappings
" https://github.com/airblade/vim-gitgutter#sign-column
set signcolumn=yes
let g:gitgutter_grep = 'ag'
" https://github.com/airblade/vim-gitgutter#getting-started
set updatetime=400

" vim-closetag
let g:closetag_filenames = '*.html,*.erb,*.js,*.jsx'

" -----------------------------------------------
"    OS specifics
" -----------------------------------------------
" :h feature-list to check OS for specific settings
if has("mac") " Mac
  " <C-x><C-k> to complete
  " location of dictionary on Mac
  " set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words
  " set complete-=k complete+=k

  " invisibles
  set listchars=tab:»\ ,eol:$,nbsp:%,trail:~,extends:>,precedes:<

  "clipboard - http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
  set clipboard=unnamed " yank to "* register i.e. system clipboard
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

" ctags - http://vim.wikia.com/wiki/Autocmd_to_update_ctags_file
function! UpdateTags()
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"
  let cmd = 'ctags -R -f ' . tagfilename
  let resp = system(cmd)
endfunction
" -----------------------------------------------

nnoremap <silent> <leader>t :call <SID>StripTrailingWhitespaces()<CR>
nnoremap <silent> <leader>cq :call <SID>ReplaceCurlyQuotes()<CR>
nnoremap <script> <leader>ct :call UpdateTags()<CR>

" vim-rails
" https://github.com/tpope/vim-rails/issues/368#issuecomment-265086019
let g:rails_projections = {
      \  "app/controllers/*_controller.rb": {
      \      "test": [
      \        "spec/requests/{}_spec.rb",
      \        "spec/controllers/{}_controller_spec.rb",
      \      ],
      \      "alternate": [
      \        "spec/requests/{}_spec.rb",
      \        "spec/controllers/{}_controller_spec.rb",
      \      ],
      \   },
      \   "spec/requests/*_spec.rb": {
      \      "alternate": "app/controllers/{}_controller.rb"
      \   },
      \ }

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
"
" vim-surround
" cs"'
" cst'
" ysiw
" yss e.g. yss[ to surround with space and ] without space
" -----------------------------------------------
