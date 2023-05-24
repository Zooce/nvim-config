return {
  {
    -- LSP management and configuration
    'williamboman/mason.nvim',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'nvim-telescope/telescope.nvim',
      -- 'folke/neodev.nvim',
    },
    config = function()
      require('mason').setup {
        ui = { border = 'rounded' },
      }

      -- put other LSP servers you want here
      local servers = {
        pyright = {},
        ['rust_analyzer@nightly'] = {
          procMacro = { enable = true },
        },
        -- Lua LSP resources:
        -- * https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua
        -- * https://github.com/LuaLS/lua-language-server/wiki/Settings
        -- lua_ls = {
        --   Lua = {
        --     runtime = {
        --       -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        --       version = 'LuaJIT',
        --     },
        --     diagnostics = {
        --       -- Get the language server to recognize the `vim` global
        --       globals = { 'vim' },
        --     },
        --     workspace = {
        --       -- Make the server aware of Neovim runtime files
        --       library = vim.api.nvim_get_runtime_file("", true),
        --       checkThirdParty = false,
        --     },
        --     -- Do not send telemetry data containing a randomized but unique identifier
        --     telemetry = {
        --       enable = false,
        --     },
        --   },
        -- },
        svelte = {},
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local mason_config = require 'mason-lspconfig'
      mason_config.setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      }
      local on_attach = function(_, bufnr)
        local lnmap = function(k, f, d)
          require('helpers').nmap(k, f, 'LSP: ' .. d)
        end

        -- keymaps for LSP attached buffers (Telescope gives us extra goodies)
        local telescope = require 'telescope.builtin'
        lnmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
        lnmap('<leader>.', vim.lsp.buf.code_action, '[c]ode[a]ction')
        lnmap('gd', telescope.lsp_definitions, '[g]oto [d]efinition')
        lnmap('<leader>/r', telescope.lsp_references, 'Search references')
        lnmap('<leader>/sd', telescope.lsp_document_symbols, 'Search document symbols')
        lnmap('<leader>/sw', telescope.lsp_dynamic_workspace_symbols, 'Search workspace symbols')
        lnmap('K', vim.lsp.buf.hover, 'Hover documentation')
        lnmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')

        -- Custom `:Format` command
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format the current buffer' })
      end
      mason_config.setup_handlers {
        function(server)
          require('lspconfig')[server].setup {
            capabilities = capabilities,
            settings = servers[server],
            on_attach = on_attach,
          }
        end,
      }
    end,
  },
  -- {
  --   -- Lua LSP for Neovim config
  --   'folke/neodev.nvim',
  --   -- event = 'VeryLazy',
  --   config = true,
  -- },
  {
    -- LSP status
    'j-hui/fidget.nvim',
    event = 'BufRead',
    config = function()
      require('fidget').setup {
        text = {
          spinner = 'dots',
        },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
