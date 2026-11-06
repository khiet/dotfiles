vim.api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
  group = vim.api.nvim_create_augroup("DotfilesHerdr", { clear = true }),
  pattern = "Sticky.md",
  callback = function(event)
    -- Autocommand patterns can be case-insensitive on macOS.
    if vim.fs.basename(event.file) ~= "Sticky.md" then
      return
    end

    local tab_id = vim.env.HERDR_TAB_ID
    if vim.env.HERDR_ENV ~= "1" or not tab_id or tab_id == "" or vim.fn.executable("herdr") ~= 1 then
      return
    end

    -- Keep the label after leaving the buffer, like the shell's agent labels.
    vim.fn.jobstart({ "herdr", "tab", "rename", tab_id, "note" })
  end,
})
