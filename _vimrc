if has('nvim')
  " https://neovim.io/doc/user/nvim.html#nvim-from-vim
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath

  " automatic installation: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
  if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  end
else
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif
endif

" PlugInstall to install plugins, PlugClean to delete plugins, PlugUpdate to
" update plugins
" https://github.com/junegunn/vim-plug#commands
call plug#begin('~/.vim/plugged')
  " General
  Plug 'https://github.com/dominikduda/vim_current_word'
  Plug 'https://github.com/pbrisbin/vim-mkdir'
  Plug 'https://github.com/scrooloose/nerdtree'
  Plug 'https://github.com/mileszs/ack.vim'
  Plug 'https://github.com/vim-airline/vim-airline'
  Plug 'https://github.com/tpope/vim-surround'
  Plug 'https://github.com/junegunn/vim-easy-align'
  Plug 'https://github.com/sheerun/vim-polyglot'
  if has('nvim')
    Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}
  endif

  " Colorscheme
  Plug 'https://github.com/morhetz/gruvbox'

  " Tmux
  Plug 'https://github.com/christoomey/vim-tmux-navigator'
  Plug 'https://github.com/janko-m/vim-test'
  Plug 'https://github.com/benmills/vimux'

  " Git
  Plug 'https://github.com/airblade/vim-gitgutter'
  Plug 'https://github.com/tpope/vim-fugitive'

  " Rails
  Plug 'https://github.com/tpope/vim-rails'

  " HTML
  Plug 'https://github.com/alvan/vim-closetag'

  " Note
  Plug 'https://github.com/vimwiki/vimwiki'
call plug#end()

noremap <Up>    <NOP>
noremap <Down>  <NOP>
noremap <Left>  <NOP>
noremap <Right> <NOP>

let mapleader=" "

inoremap jj <esc>

" edit config files
nnoremap <leader>ev :e <C-R>=expand($HOME."/dotfiles/_vimrc")<CR><CR>
nnoremap <leader>ez :e <C-R>=expand($HOME."/dotfiles/_zshrc")<CR><CR>
nnoremap <leader>et :e <C-R>=expand($HOME."/dotfiles/_tmux.conf")<CR><CR>

" buffers
nnoremap <silent> ]b :bn<CR>
nnoremap <silent> [b :bp<CR>
nnoremap <leader>bd :bd<CR>

" tabs
nnoremap <silent> ]t :tabn<CR>
nnoremap <silent> [t :tabp<CR>
nnoremap <leader>te :tabedit<CR>
nnoremap <leader>tc :tabclose<CR>

" windows
nnoremap <leader>vs :vs<CR>
nnoremap <leader>q :q<CR>

" quickfix
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprev<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [l :lprev<CR>

" saving
nnoremap <leader>w :w<CR>
nnoremap <leader>x :x<CR>

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
nnoremap <leader><leader> <C-^>

" indenting
vnoremap << <gv
vnoremap >> >gv

set hlsearch
" recognize .js without extension when gf
set suffixesadd=.js
" allow backspacing over everything in i-mode
set backspace=indent,eol,start
" consider '-' as part of a word
set iskeyword+=-
" status display
set laststatus=2
set title
set titlestring=%F
" 20 lines of command history
set history=20
" always show cursor position
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
" avoid 'safe write': https://webpack.js.org/guides/development/#adjusting-your-text-editor
set backupcopy=yes
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

highlight clear SpellBad
highlight SpellBad cterm=underline ctermfg=red gui=underline guifg=red

" enable spell check
"nnoremap <leader>sp :set spell!<CR>

" enable mouse in terminal emulators
if has("mouse")
  set mouse=a
endif

" vim-test
let test#strategy = "vimux"
nnoremap <leader>T :TestNearest<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tf :TestFile<CR>

" ag
if executable('ag')
  " https://robots.thoughtbot.com/faster-grepping-in-vim
  " use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " https://github.com/mileszs/ack.vim#can-i-use-ag-the-silver-searcher-with-this
  let g:ackprg = 'ag --vimgrep'
endif

" fzf
set runtimepath+=/usr/local/opt/fzf
nnoremap <silent> <c-t> :FZF<CR>

" NERDTree
noremap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeWinSize=35

" airline
let g:airline_theme='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

if $TMUX != '' " tmux specific settings
  " https://github.com/christoomey/vim-tmux-navigator#vim-1
  let g:tmux_navigator_no_mappings = 1

  nnoremap <silent> <c-h> :TmuxNavigateLeft<CR>
  nnoremap <silent> <c-j> :TmuxNavigateDown<CR>
  nnoremap <silent> <c-k> :TmuxNavigateUp<CR>
  nnoremap <silent> <c-l> :TmuxNavigateRight<CR>
end

set t_Co=256
if (&t_Co == 256) " if terminal supports 256 colours

  " true colour: https://github.com/tmux/tmux/issues/1246
  if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif

  colorscheme gruvbox
endif

" vim_current_word
hi CurrentWord guifg=#ffffff guibg=#721b65
hi CurrentWordTwins gui=underline cterm=underline

" highlight trailing whitespaces
au BufWritePre * match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=red guibg=red

" vimwiki
nnoremap <leader>mf :exe 'FZF' g:vimwiki_list[0].path<CR>
let g:vimwiki_list = [{'path': "$HOME/Dropbox/vimwiki", 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_map_prefix = '<leader>m'
" :VWS
" :VimwikiTable

" gitgutter
let g:gitgutter_map_keys = 0 " turn off all key mappings
" https://github.com/airblade/vim-gitgutter#sign-column
set signcolumn=yes
let g:gitgutter_grep = 'ag'
" https://github.com/airblade/vim-gitgutter#getting-started
set updatetime=200

" vim-closetag
let g:closetag_filenames = '*.html,*.erb,*.js,*.jsx'

if has('nvim')
  " prerequisites
  "
  " * solargraph gem
  "   gem install solargraph
  " * python provider
  "   sudo easy_install pip
  "   python2 -m pip install --user --upgrade pynvim

  " coc
  let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-solargraph',
    \ 'coc-highlight',
    \ 'coc-emmet',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-json',
    \ 'coc-snippets',
    \ 'coc-flutter'
    \ ]

  " :CocConfig
  " :checkhealth
  " :CocInfo
  " set cmdheight=2
  set shortmess+=c

  " trigger completion
  inoremap <silent><expr> <c-t> coc#refresh()
  " navigate diagnostics
  nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
  nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

  nmap <silent> gd <Plug>(coc-definition)
  " nmap <silent> gy <Plug>(coc-type-definition)
  " nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  nmap <leader>rn <Plug>(coc-rename)
  nmap <leader>= <Plug>(coc-format)
  " auto-fixing
  nmap <leader>f <Plug>(coc-codeaction)

  " show documentation
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " coc-highlight
  ":call CocAction('pickColor')
  ":call CocAction('colorPresentation')

  " coc-emmet
  " <c-y> to select

  " coc-snippets
  set runtimepath+=~/.vim/custom_snippets
  nnoremap <leader>es :<C-u>CocCommand snippets.editSnippets<CR>

  nnoremap <leader>cc :<C-u>CocCommand<space>
  nnoremap <leader>cl :<C-u>CocList<space>
end

" vim-polyglot
let g:csv_no_conceal = 1

" -----------------------------------------------
"    OS specifics
" -----------------------------------------------
" :h feature-list to check OS for specific settings
if has("mac") " Mac
  " <C-x><C-k> to complete
  " location of dictionary on Mac
  set dictionary+=/usr/share/dict/words
  set complete+=kspell

  " invisibles
  set listchars=tab:»\ ,eol:$,nbsp:%,trail:~,extends:>,precedes:<

  "clipboard: http://vim.wikia.com/wiki/Mac_OS_X_clipboard_sharing
  set clipboard=unnamed " yank to "* register i.e. system clipboard
endif
" -----------------------------------------------

" -----------------------------------------------
"    function
" -----------------------------------------------
" http://vimcasts.org/episodes/tidying-whitespace/
function! <SID>StripTrailingWhitespaces()
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

function! <SID>ReplaceCurlyQuotes()
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/[’‘]/'/g
  %s/[”“]/"/g
  let @/=_s
  call cursor(l, c)
endfunction

" ctags: http://vim.wikia.com/wiki/Autocmd_to_update_ctags_file
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
  \ "app/controllers/*_controller.rb": {
  \     "test": [
  \       "spec/requests/{}_spec.rb",
  \       "spec/controllers/{}_controller_spec.rb",
  \     ],
  \     "alternate": [
  \       "spec/requests/{}_spec.rb",
  \       "spec/controllers/{}_controller_spec.rb",
  \     ],
  \   },
  \   "spec/requests/*_spec.rb": {
  \      "alternate": "app/controllers/{}_controller.rb"
  \   },
  \ }
