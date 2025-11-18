return {
  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/nvim-cmp',         -- autocompletion
      'hrsh7th/cmp-nvim-lsp',     -- LSP source
      'hrsh7th/cmp-buffer',       -- buffer source
      'hrsh7th/cmp-path',         -- path source
      'saadparwaiz1/cmp_luasnip', -- snippet source
      'L3MON4D3/LuaSnip',         -- snippet
    },
    config = function()
      vim.o.completeopt = "menu,menuone,noselect"

      local luasnip = require("luasnip")
      require("snippets.all")

      -- https://github.com/neovim/nvim-lspconfig/wiki/Snippets
      local cmp = require('cmp')
      cmp.setup({
        completion = {
          autocomplete = false,
        },
        mapping = {
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item({ behavior = 'insert' })
            else
              cmp.complete()
            end
          end),
          ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item({ behavior = 'insert' })
            else
              cmp.complete()
            end
          end),
        },
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          {
            name = 'buffer',
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end
            }
          },
          { name = 'path' },
          { name = "nvim_lsp" },
          { name = 'luasnip' },
        }),
      })

      local on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format()
          vim.cmd('write')
        end, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', 'gc', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gi", function()
          vim.lsp.buf.code_action({
            context = { only = { "source.addMissingImports.ts" } },
            apply = true,
          })
        end, { desc = "Auto import missing imports" })
      end

      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      -- Migrated to vim.lsp.config (Neovim 0.11+)
      local servers = {
        'ts_ls',
        'eslint',
        'jsonls',
        'lua_ls',
      }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, { on_attach = on_attach })
        vim.lsp.enable(server)
      end

      -- npm install -g typescript
      vim.lsp.config('ruby_lsp', {
        on_attach = on_attach,
        filetypes = { "ruby" },
        init_options = {
          addonSettings = {
            ["Ruby LSP Rails"] = {
              enablePendingMigrationsPrompt = false,
            },
          },
        },
      })
      vim.lsp.enable('ruby_lsp')
    end
  },
}
