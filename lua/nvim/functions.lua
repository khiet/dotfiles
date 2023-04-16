function delete_trailing_whitespaces()
  local s = vim.fn.getreg('/')
  local l = vim.fn.line('.')
  local c = vim.fn.col('.')

  vim.cmd('%s/\\s\\+$//e')

  vim.fn.setreg('/', s)
  vim.fn.cursor(l, c)
end

function search_dictionary()
  os.execute('open "https://dictionary.cambridge.org/dictionary/english/'..vim.fn.expand('<cword>')..'"')
end

vim.keymap.set('n', '<leader>td', delete_trailing_whitespaces, { noremap = true })
vim.keymap.set('n', '<leader>cd', search_dictionary, { noremap = true })
-- vim.keymap.set('n', '<leader>cq', replace_curly_quotes, { noremap = true })

-- " " -----------------------------------------------
-- "    function
-- " -----------------------------------------------
-- function IsAJavascript()
--   return index(['javascript', 'typescript', 'typescriptreact', 'html', 'json'], &filetype) != -1
-- endfunction
--
-- function! ReplaceCurlyQuotes()
--   let _s=@/
--   let l = line(".")
--   let c = col(".")
--   %s/[’‘]/'/g
--   %s/[”“]/"/g
--   let @/=_s
--   call cursor(l, c)
-- endfunction
--
-- " ctags: http://vim.wikia.com/wiki/Autocmd_to_update_ctags_file
-- function! RunCtags()
--   let cwd = getcwd()
--   let tagfilename = cwd . "/tags"
--   let cmd = 'ctags -R -f ' . tagfilename
--   let resp = system(cmd)
-- endfunction
--
-- function! AddDebugBreakpoint()
--   if IsAJavascript()
--     r!echo 'debugger;'
--     write
--   elseif index(['ruby', 'haml'], &filetype) != -1
--     r!echo "require 'debug'; debugger"
--     write
--   endif
-- endfunction
--
-- function! RunScript()
--   if &filetype == 'javascript'
--     call VimuxRunCommand("node " . bufname("%"))
--   elseif &filetype == 'ruby'
--     call VimuxRunCommand("ruby -w " . bufname("%"))
--   elseif &filetype == 'rust'
--     call VimuxRunCommand("cargo run")
--   elseif &filetype == 'sh'
--     call VimuxRunCommand("./" . bufname("%"))
--   endif
-- endfunction
--
-- " http://vimcasts.org/episodes/tidying-whitespace/
-- function! DeleteTrailingWhitespaces()
--   " Preparation: save last search, and cursor position.
--   let _s=@/
--   let l = line(".")
--   let c = col(".")
--   " do the business:
--   %s/\s\+$//e
--   " clean up: restore previous search history, and cursor position
--   let @/=_s
--   call cursor(l, c)
-- endfunction
--
-- function! CreateSpecFile()
--   silent execute '!ruby ~/dotfiles/scripts/create_spec_file.rb' expand("%:p")
-- endfunction
--
-- function! ConsoleLog()
--   execute "normal! yiwo" . "console.log" . "('')\<C-[>F';a\<C-[>pf'a, \<C-[>p<CR>"
-- endfunction
--
-- " -----------------------------------------------
--
-- nnoremap <silent> <leader>cd :call AddDebugBreakpoint()<CR>
-- nnoremap <silent> <leader>cl :call ConsoleLog()<CR>
-- nnoremap <silent> <leader>cq :call ReplaceCurlyQuotes()<CR>
-- nnoremap <silent> <leader>ct :call RunCtags()<CR>
-- nnoremap <silent> <leader>cs :call RunScript()<CR>
-- nnoremap <silent> <leader>rc :call CreateSpecFile()<CR>
-- nnoremap <silent> <leader>td :call DeleteTrailingWhitespaces()<CR>
