vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  command = "setlocal spell spelllang=en_us"
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  command = "setlocal spell spelllang=en_us"
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "_zshrc",
  command = "set filetype=zsh"
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "_tmux.conf",
  command = "set filetype=tmux"
})

-- Set filetype=haml for *.inky-haml files
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.inky-haml",
  command = 'set filetype=haml'
})

-- Set syntax=yaml for *.yml files, even overriding plugins
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.yml",
  command = 'set filetype=yaml'
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = ".env.*",
  command = 'set filetype=sh'
})

-- https://github.com/rest-nvim/rest.nvim/issues/417#issuecomment-2322786365
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json" },
  callback = function()
    vim.api.nvim_set_option_value("formatprg", "jq", { scope = 'local' })
  end
})
