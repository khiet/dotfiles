function _G.rspec_foldexpr()
  local line = vim.fn.getline(vim.v.lnum)

  -- fold on describe/context/it
  if line:match("^%s*describe%s+'") or
      line:match("^%s*context%s+'") or
      line:match("^%s*it%s+'") then
    return ">1"
  end

  -- close fold on 'end'
  if line:match("^%s*end%s*$") then
    return "<1"
  end

  return "="
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.rspec_foldexpr()"
    vim.opt_local.foldlevel = 99 -- show all folds open initially
  end
})
