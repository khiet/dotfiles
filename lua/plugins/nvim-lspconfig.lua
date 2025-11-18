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

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          -- set omnifunc for LSP completion
          vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- LSP keymaps
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
        end,
      })

      -- get LSP capabilities from cmp-nvim-lsp for enhanced completion
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      local servers = {
        'ts_ls',
        'eslint',
        'jsonls',
        'lua_ls',
      }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, { capabilities = capabilities })
        vim.lsp.enable(server)
      end

      -- npm install -g typescript
      vim.lsp.config('ruby_lsp', {
        capabilities = capabilities,
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
