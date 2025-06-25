return {
  'echasnovski/mini.ai',
  version = '*',
  config = function()
    require('mini.ai').setup({
      silent = true,
    })
  end
}
