vim.keymap.set('n', '<leader>rr', vim.cmd.R, { noremap = true })
vim.keymap.set('n', '<leader>ra', vim.cmd.A, { noremap = true })

-- let g:rails_projections = {
-- \   "app/controllers/*_controller.rb": {
-- \     "test": ["spec/requests/{}_request_spec.rb", "spec/requests/{}_spec.rb"]
-- \   },
-- \   "spec/requests/*_spec.rb": {
-- \     "alternate": "app/controllers/{}_controller.rb"
-- \   },
-- \   "spec/requests/*_request_spec.rb": {
-- \     "alternate": "app/controllers/{}_controller.rb"
-- \   },
-- \ }
