if has('nvim')
  " https://neovim.io/doc/user/nvim.html#nvim-from-vim
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
  let &packpath = &runtimepath
endif

" vim-plug
" automatic installation: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" PlugInstall, PlugClean, PlugUpdate
call plug#begin('~/.vim/plugged')
  " General
  Plug 'https://github.com/dominikduda/vim_current_word'
  Plug 'https://github.com/pbrisbin/vim-mkdir'
  Plug 'https://github.com/tpope/vim-surround'
  Plug 'https://github.com/tpope/vim-repeat'
  Plug 'https://github.com/junegunn/vim-easy-align'
  Plug 'https://github.com/sheerun/vim-polyglot'
  Plug 'https://github.com/junegunn/fzf'
  Plug 'https://github.com/junegunn/fzf.vim'
  Plug 'https://github.com/FooSoft/vim-argwrap'
  Plug 'https://github.com/itchyny/lightline.vim'
  Plug 'https://github.com/yggdroot/indentline'
  Plug 'https://github.com/simeji/winresizer'

  if has('nvim')
    Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}
    Plug 'https://github.com/norcalli/nvim-colorizer.lua'
    Plug 'https://github.com/justinmk/vim-sneak'
  endif

  " Colorscheme
  Plug 'https://github.com/morhetz/gruvbox'
  Plug 'https://github.com/dracula/vim'
  Plug 'git@github.com:khiet/dracula-pro.git', {'branch': 'main'}

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
  Plug 'https://github.com/AndrewRadev/tagalong.vim'
call plug#end()

noremap <Up>    <NOP>
noremap <Down>  <NOP>
noremap <Left>  <NOP>
noremap <Right> <NOP>

noremap q: <Nop>
" disable ex-mode
noremap Q <Nop>

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
nnoremap <leader>bd :bd<CR>

" tabs
nnoremap <silent> ]t :tabn<CR>
nnoremap <silent> [t :tabp<CR>
nnoremap <leader>ts :tab split<CR>
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
vnoremap <leader>s :s//

" noh
nnoremap <leader>h :noh<CR>

" reload
nnoremap <leader>e :e!<CR>

" list invisibles
nnoremap <leader>ls :set list!<CR>

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

set splitbelow
set splitright

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
set hlsearch
set ignorecase
set incsearch
set smartcase
set number
set cursorline
set autoindent
nnoremap # :normal! #N<CR>

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

  colorscheme dracula_pro
endif

" filetype
au BufRead,BufNewFile *.inky-haml set filetype=haml
au BufRead,BufNewFile tsconfig.json set filetype=jsonc
au BufRead,BufNewFile coc-settings.json set filetype=jsonc

" spell-checking
au BufRead,BufNewFile *.md set filetype=markdown
au FileType markdown setlocal spell
au FileType gitcommit setlocal spell
" https://www.youtube.com/watch?v=lwD8G1P52Sk&t=147s
function! FixLastSpellingError()
  normal! mm[s1z=`m
endfunction
nnoremap <leader>S :call FixLastSpellingError()<CR>

" vim-test
let test#strategy = "vimux"
let g:VimuxOrientation = "h"
let g:VimuxHeight = "25"
let g:test#javascript#runner = 'jest'

nnoremap <leader>T :TestNearest<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tf :TestFile<CR>
nnoremap <Leader>tL :call VimuxRunCommand("clear; bin/rake factory_bot:lint")<CR>

" argwrap
nnoremap <silent>gS :ArgWrap<CR>

" lightline
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'dracula',
  \ }

" vim-sneak
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

hi clear SpellBad
hi SpellBad gui=underline guifg=#ff5555

" fzf
nnoremap <silent> <c-t> :Files<CR>
nnoremap <silent> <c-b> :Buffers<CR>
nnoremap <silent> <c-g> :GFiles?<CR>
nnoremap <silent>gc :BCommits<CR>

" nnoremap <silent> <c-?> :Commits<CR>
nnoremap <silent> <c-s> :History<CR>
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
command! -nargs=* -bang RGW call RipgrepFzf(<q-args>, <bang>0, '$DEVS_HOME/vim/wiki')

" wiki
nnoremap <leader>mf :exe 'FZF' "$DEVS_HOME/vim/wiki"<CR>
nnoremap <leader>mg :RGW 

" vim_current_word
hi CurrentWord gui=underline
hi CurrentWordTwins gui=underline

" highlight trailing whitespaces
au BufWritePre * match ExtraWhitespace /\s\+$/
hi ExtraWhitespace guibg=#ff5555

" gitgutter
let g:gitgutter_map_keys = 0 " turn off all key mappings
let g:gitgutter_grep = 'rg'

nmap <silent>[c <Plug>(GitGutterPrevHunk)
nmap <silent>]c <Plug>(GitGutterNextHunk)

" vim-fugitive
nnoremap <silent>gb :Git blame<CR>

" vim-closetag
let g:closetag_filenames = '*.html,*.erb,*.js,*.jsx'
" tagalong
let g:tagalong_filetypes = ['html', 'xml', 'eruby', 'javascript', 'javascriptreact', 'typescriptreact']

if has('nvim')
  " prerequisites
  "
  " * python provider
  "   sudo easy_install pip
  "   python2 -m pip install --user --upgrade pynvim
  "
  " :CocConfig to open coc-settings.json
  " :checkhealth and :CocInfo to get information about installation

  set cmdheight=1
  set shortmess+=c

  " global extentions are automatically installed when tye are not installed,
  " CocUninstall to uninstall extensions, CocUpdate to update extensions
  " https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#update-extensions
  let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-eslint',
    \ 'coc-prettier',
    \ 'coc-solargraph',
    \ 'coc-json',
    \ 'coc-snippets',
    \ 'coc-explorer',
    \ 'coc-rust-analyzer',
    \ ]

  " navigate diagnostics
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)
  nmap <silent> <space>d :<C-u>CocList diagnostics<CR>

  nmap <silent> gd <Plug>(coc-definition)
  nmap <leader>rn <Plug>(coc-rename)

  " https://github.com/neoclide/coc.nvim/wiki/Multiple-cursors-support
  hi CocCursorRange guibg=#ffb86c guifg=#282a36
  nmap <silent> <C-m> <Plug>(coc-cursors-word)*

  nmap <leader>ce :CocList extensions<CR>
  nmap <leader>cf :CocFix<CR>
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  nmap <leader>f :CocCommand eslint.executeAutofix<CR>

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
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_conceal = 0

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
    r!echo 'binding.pry'
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
  if has('nvim')
    if &filetype == 'ruby'
    " format and save
      call CocAction('format')
    elseif IsAJavascript()
    " format and save
      execute 'CocCommand' 'prettier.formatFile'
    endif
  endif

  write
endfunction
" -----------------------------------------------

function! OpenIn()
  " yank current word in register
  normal! viWy
  let word = getreg("0")
  if word =~ "http"
    let escaped = escape(word, '#&+?%[]')
    silent execute '!open' escaped
  else
    silent execute '!open' expand("%:p:h")
  end
endfunction

function! CreateSpecFile()
  silent execute '!ruby ~/dotfiles/scripts/create_spec_file.rb' expand("%:p")
endfunction
function! SwitchCases()
  let word = system('ruby ~/dotfiles/scripts/switch_cases.rb' . ' ' . expand('<cword>'))
  exe 'normal! ciw' . word
  exe 'normal! b'
endfunction
function! ConsoleLog()
  execute "normal! yiwo" . "console.log" . "('')\<C-[>F';a\<C-[>pf'a, \<C-[>p<CR>"
endfunction
nnoremap <silent> gx :call OpenIn()<CR>

nnoremap <silent> <leader>cd :call AddDebugBreakpoint()<CR>
nnoremap <silent> <leader>cl :call ConsoleLog()<CR>
nnoremap <silent> <leader>cq :call ReplaceCurlyQuotes()<CR>
nnoremap <silent> <leader>ct :call RunCtags()<CR>
nnoremap <silent> <leader>cs :call RunScript()<CR>
nnoremap <silent> <leader>cc :call SwitchCases()<CR>
nnoremap <silent> <leader>rc :call CreateSpecFile()<CR>
nnoremap <silent> <leader>t :call RemoveTrailingWhitespaces()<CR>
nnoremap <silent> <leader>w :call RunSave()<CR>

" vim-rails
nnoremap <leader>rr :R<CR>
nnoremap <leader>ra :A<CR>
" https://github.com/tpope/vim-rails/issues/368#issuecomment-265086019
let g:rails_projections = {
\   "app/controllers/*_controller.rb": {
\     "test": ["spec/requests/{}_request_spec.rb", "spec/requests/{}_spec.rb"]
\   },
\   "spec/requests/*_spec.rb": {
\     "alternate": "app/controllers/{}_controller.rb"
\   },
\   "spec/requests/*_request_spec.rb": {
\     "alternate": "app/controllers/{}_controller.rb"
\   },
\ }
