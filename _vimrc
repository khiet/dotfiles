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
  Plug 'https://github.com/vim-airline/vim-airline'
  Plug 'https://github.com/tpope/vim-surround'
  Plug 'https://github.com/junegunn/vim-easy-align'
  Plug 'https://github.com/sheerun/vim-polyglot'
  Plug 'https://github.com/neoclide/jsonc.vim'
  Plug 'https://github.com/junegunn/fzf'
  Plug 'https://github.com/junegunn/fzf.vim'
  Plug 'https://github.com/FooSoft/vim-argwrap'
  if has('nvim')
    Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}
    Plug 'https://github.com/norcalli/nvim-colorizer.lua'
  endif

  " Colorscheme
  Plug 'https://github.com/morhetz/gruvbox'
  Plug 'https://github.com/dracula/vim'

  " Tmux
  Plug 'https://github.com/janko-m/vim-test'
  Plug 'https://github.com/benmills/vimux'

  " Git
  Plug 'https://github.com/airblade/vim-gitgutter'
  Plug 'https://github.com/tpope/vim-fugitive'
  Plug 'https://github.com/tpope/vim-rhubarb'

  " Rails
  Plug 'https://github.com/tpope/vim-rails'

  " HTML
  Plug 'https://github.com/alvan/vim-closetag'

  " Note
  Plug 'https://github.com/vimwiki/vimwiki', {'branch': 'dev'}
call plug#end()

noremap <Up>    <NOP>
noremap <Down>  <NOP>
noremap <Left>  <NOP>
noremap <Right> <NOP>

" https://thoughtbot.com/blog/vim-splits-move-faster-and-more-naturally
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

let mapleader=" "

" edit config files
nnoremap <leader>ev :e <C-R>=expand($HOME."/.vimrc")<CR><CR>
nnoremap <leader>eV :source $MYVIMRC<CR>
nnoremap <leader>ez :e <C-R>=expand($HOME."/.zshrc")<CR><CR>
nnoremap <leader>et :e <C-R>=expand($HOME."/.tmux.conf")<CR><CR>

" buffers
nnoremap <silent> ]b :bn<CR>
nnoremap <silent> [b :bp<CR>

" tabs
nnoremap <silent> ]t :tabn<CR>
nnoremap <silent> [t :tabp<CR>
nnoremap <leader>te :tabedit<CR>
nnoremap <leader>tc :tabclose<CR>

" windows
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>
" resize to equal width/height
nmap <leader>= <C-w>=

" quickfix
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprev<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [l :lprev<CR>

" save
nnoremap <leader>x :x<CR>

" replace
nnoremap <leader>s :%s//

" noh
nnoremap <leader>h :noh<CR>

" reload
nnoremap <leader>e :e!<CR>

" set cursorcolumn
nnoremap <leader>lc :set cuc!<CR>

" list invisibles
nnoremap <leader>ls :set list!<CR>

" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" yank
" http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
xnoremap <silent> p p:let @+=@0<CR>:let @"=@0<CR>
nnoremap yi ^y$

" switch between the last two files
" https://github.com/thoughtbot/dotfiles/blob/master/vimrc#L128
nnoremap <leader><leader> <C-^>

" indenting
vnoremap << <gv
vnoremap >> >gv

" https://github.com/ChristianChiarulli/nvim/blob/master/general/settings.vim

set splitbelow
set splitright

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

set nobackup
set nowritebackup
set noswapfile
set backupcopy=yes " avoid 'safe write': https://webpack.js.org/guides/development/#adjusting-your-text-editor
" tabs and spaces
set expandtab " insert spaces when tab is pressed
set tabstop=2 " spaces when tab is pressed
set shiftwidth=2 " spaces for indentation
set softtabstop=2 " treat spaces like a tab when backspace is pressed

set signcolumn=yes
set updatetime=200

set t_Co=256
if (&t_Co == 256) " if terminal supports 256 colours

  " true colour: https://github.com/tmux/tmux/issues/1246
  if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
  endif

  colorscheme dracula
endif

" filetype
au BufRead,BufNewFile *.inky-haml set ft=haml
au BufRead,BufNewFile tsconfig.json set filetype=jsonc
au BufRead,BufNewFile coc-settings.json set filetype=jsonc

" spell-checking
au BufRead,BufNewFile *.md set filetype=markdown
au FileType markdown setlocal spell
au FileType gitcommit setlocal spell

" enable mouse in terminal emulators
if has("mouse")
  set mouse=a
endif

" vim-test
let test#strategy = "vimux"
let g:VimuxOrientation = "h"
let g:VimuxHeight = "50"

nnoremap <leader>T :TestNearest<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tf :TestFile<CR>
nnoremap <Leader>tL :call VimuxRunCommand("clear; bin/rake factory_bot:lint")<CR>

" argwrap
nnoremap <silent> <silent>gS :ArgWrap<CR>

" fzf
nnoremap <silent> <c-t> :Files<CR>
nnoremap <silent> <c-b> :Buffers<CR>
nnoremap <silent> <c-g> :GFiles?<CR>
" nnoremap <silent> <c-?> :Commits<CR>
nnoremap <silent> <c-s> :History<CR>
nnoremap <leader>g :RG 
let g:fzf_action = { 'ctrl-l': 'edit', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let g:fzf_preview_window = ['down:75%']

" https://github.com/junegunn/fzf.vim#example-advanced-ripgrep-integration
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" airline
let g:airline_theme='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
function! AirlineInit()
  let g:airline_section_b = airline#section#create([])
  let g:airline_section_c = airline#section#create(['file'])
endfunction
autocmd User AirlineAfterInit call AirlineInit()

hi clear SpellBad
hi SpellBad gui=underline guifg=#ff5555

" vim_current_word
hi CurrentWord guifg=#ffffff guibg=#6272a4
hi CurrentWordTwins gui=underline,bold

" highlight trailing whitespaces
au BufWritePre * match ExtraWhitespace /\s\+$/
hi ExtraWhitespace guibg=#ff5555

" vimwiki
let g:vimwiki_list = [{'path': "$HOME/Dropbox/Apps/vim/vimwiki", 'syntax': 'markdown', 'ext': '.md'}]
" https://github.com/vimwiki/vimwiki/blob/dev/doc/vimwiki.txt#L3329
let g:vimwiki_key_mappings =
  \ {
  \   'all_maps': 1,
  \   'global': 0,
  \   'headers': 0,
  \   'text_objs': 0,
  \   'table_format': 0,
  \   'table_mappings': 0,
  \   'lists': 0,
  \   'links': 1,
  \   'html': 0,
  \   'mouse': 0,
  \ }
nmap <leader>mw <Plug>VimwikiIndex
nmap <leader>ms <Plug>VimwikiIndex :VWS<space>
nnoremap <leader>mf :exe 'FZF' g:vimwiki_list[0].path<CR>
" :VimwikiTable

" gitgutter
let g:gitgutter_map_keys = 0 " turn off all key mappings
let g:gitgutter_grep = 'rg'

" vim-closetag
let g:closetag_filenames = '*.html,*.erb,*.js,*.jsx'

if has('nvim')
  " prerequisites
  "
  " * python provider
  "   sudo easy_install pip
  "   python2 -m pip install --user --upgrade pynvim
  "
  " :CocConfig to open coc-settings.json
  " :checkhealth and :CocInfo to get information about installation

  set cmdheight=2
  set shortmess+=c

  " global extentions are automatically installed when tye are not installed,
  " CocUninstall to uninstall extensions, CocUpdate to update extensions
  " https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#update-extensions
  let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-eslint',
    \ 'coc-solargraph',
    \ 'coc-emmet',
    \ 'coc-json',
    \ 'coc-snippets',
    \ 'coc-explorer',
    \ ]

  " navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " https://github.com/neoclide/coc.nvim/wiki/Multiple-cursors-support
  hi CocCursorRange guibg=#ffb86c guifg=#282a36
  nmap <silent> <C-m> <Plug>(coc-cursors-word)*
  nmap <leader>f :CocSearch 

  nmap <leader>ce :CocList extensions<CR>

  " coc-snippets
  set runtimepath+=~/.vim/custom_snippets
  nnoremap <leader>es :CocCommand snippets.openSnippetFiles<CR>

  " coc-explorer
  noremap <C-n> :CocCommand explorer<CR>

  " nvim-colorizer
  lua require'colorizer'.setup()
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
  if index(['javascript', 'typescript', 'typescriptreact', 'html'], &filetype) != -1
    r!echo 'debugger;'
    write
  elseif index(['ruby', 'haml'], &filetype) != -1
    r!echo 'byebug'
    call CocAction('format')

    write
  endif
endfunction

function! RunScript()
  if &filetype == 'javascript'
    call VimuxRunCommand("node " . bufname("%"))
  elseif &filetype == 'ruby'
    call VimuxRunCommand("ruby " . bufname("%"))
  endif
endfunction

" http://vimcasts.org/episodes/tidying-whitespace/
function! RemoveTrailingWhitespaces()
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

function! RunSave()
  if &filetype == 'ruby'
  " format and save
    call CocAction('format')
  endif

  write
endfunction
" -----------------------------------------------

nnoremap <script> <leader>cd :call AddDebugBreakpoint()<CR>
nnoremap <silent> <leader>cq :call ReplaceCurlyQuotes()<CR>
nnoremap <script> <leader>ct :call RunCtags()<CR>
nnoremap <script> <leader>cs :call RunScript()<CR>
nnoremap <silent> <leader>t :call RemoveTrailingWhitespaces()<CR>
nnoremap <script> <leader>w :call RunSave()<CR>

" vim-rails
nnoremap <leader>rr :R<CR>
nnoremap <leader>ra :A<CR>
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
