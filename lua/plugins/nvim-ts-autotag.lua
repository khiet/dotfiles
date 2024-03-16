return {
  {
    "windwp/nvim-ts-autotag",
    ft = {
      'html',
      'javascript',
      'jsx',
      'markdown',
      'tsx',
      'typescript',
      'vue',
      'xml',
      'eruby'
    },
    config = function()
      require('nvim-ts-autotag').setup()
    end
  }
}
