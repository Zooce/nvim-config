-- set up single borders for lsp
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = 'single',
  }
)
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = 'single',
  }
)
vim.diagnostic.config{
  float = { border = 'single' },
}

return {
  {
    -- LSP management and configuration
    'williamboman/mason.nvim',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'folke/neodev.nvim',
    },
    config = function()
      require('mason').setup {
        ui = { border = 'single' },
      }

      -- put other LSP servers you want here
      local servers = {
        ['rust_analyzer@nightly'] = {
          procMacro = { enable = true },
          checkOnSave = { command = 'clippy' },
        },
        -- Lua LSP resources:
        -- * https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua
        -- * https://github.com/LuaLS/lua-language-server/wiki/Settings
        lua_ls = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            -- diagnostics = {
            --   -- Get the language server to recognize the `vim` global
            --   globals = { 'vim' },
            -- },
            workspace = {
              -- Make the server aware of Neovim runtime files
              -- library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local mason_config = require 'mason-lspconfig'
      mason_config.setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = true,
      }
      local on_attach = function(_, bufnr)
        -- Custom `:Format` command
        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format the current buffer' })
      end
      require('lspconfig.ui.windows').default_options.border = 'single'
      mason_config.setup_handlers {
        function(server)
          require('lspconfig')[server].setup {
            capabilities = capabilities,
            settings = servers[server],
            on_attach = on_attach,
          }
        end,
      }
      -- add filetype for angularls
      require('lspconfig').angularls.setup {
        filetypes= { 'typescript', 'html', 'typescriptreact', 'typescript.tsx', 'angular.html' }
      }
    end,
  },
  { -- Lua LSP for Neovim config
    'folke/neodev.nvim',
    config = true,
  },
  { -- LSP status
    'j-hui/fidget.nvim',
    event = 'BufRead',
    tag = 'legacy', -- FIXME: fidget is being rewritten (update when it's ready)
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
