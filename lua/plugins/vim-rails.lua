return {
  {
    "tpope/vim-rails",
    ft = { "ruby" },
    config = function()
      vim.keymap.set('n', '<leader>rr', vim.cmd.R, { noremap = true })
      vim.keymap.set('n', '<leader>ra', vim.cmd.A, { noremap = true })

      vim.g.rails_projections = {
        ["app/controllers/*_controller.rb"] = {
          alternate = {
            "spec/requests/{}_spec.rb",
          },
        },
        ["spec/requests/*_spec.rb"] = {
          alternate = {
            "app/controllers/{}_controller.rb",
          },
        },
      }
    end
  }
}
