return {
  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/nvim-cmp',         -- autocompletion
      'hrsh7th/cmp-nvim-lsp',     -- LSP source
      'saadparwaiz1/cmp_luasnip', -- snippet source
      'L3MON4D3/LuaSnip',         -- snippet
      'simrat39/rust-tools.nvim',
    },
    config = function()
      vim.o.completeopt = "menu,menuone,noselect"

      local luasnip = require("luasnip")
      require("snippets.all")

      -- https://github.com/hrsh7th/nvim-cmp/wiki/Language-Server-Specific-Samples#rust-with-rust-toolsnvim
      -- https://github.com/neovim/nvim-lspconfig/wiki/Snippets
      local cmp = require('cmp')
      cmp.setup({
        completion = {
          autocomplete = false,
        },
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = 'luasnip' },
        }),
      })

      -- nvim-lspconfig
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

      -- https://neovim.io/doc/user/diagnostic.html#diagnostic-api
      local diagnostic_format = function(diagnostic)
        return string.format("(%s: %s) %s", diagnostic.code, diagnostic.source, diagnostic.message)
      end

      vim.diagnostic.config({
        virtual_text = {
          severity = vim.diagnostic.severity.ERROR,
          spacing = 0,
          format = diagnostic_format,
        },
      })

      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<leader>F', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      end

      local lspconfig = require('lspconfig')

      local servers = { 'solargraph', 'tsserver', 'eslint', 'tailwindcss', 'jsonls', 'lua_ls' }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({ on_attach = on_attach })
      end

      lspconfig.volar.setup({
        on_attach = on_attach,
        init_options = {
          typescript = {
            tsdk = "/opt/homebrew/lib/node_modules/typescript/lib"
          }
        }
      })

      -- rust-tools
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("rust-tools").setup({
        server = {
          capabilities = capabilities,
          on_attach = on_attach,
        }
      })
    end
  },
}
