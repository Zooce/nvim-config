return {
    { -- LSP management and configuration
        'williamboman/mason.nvim',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lsp',
            'nvim-telescope/telescope.nvim',
            'folke/neodev.nvim',
        },
        config = function()
            require('mason').setup {
                ui = { border = 'rounded' },
            }

            -- put other LSP servers you want here
            local servers = {
                pyright = {},
                rust_analyzer = {},
                sumneko_lua = { -- see https://github.com/sumneko/lua-language-server/wiki/Settings
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
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
                local lnmap = function(k, f, d)
                    require('helpers').nmap(k, f, 'LSP: ' .. d)
                end

                -- keymaps for LSP attached buffers (Telescope gives us extra goodies)
                local telescope = require 'telescope.builtin'
                lnmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
                lnmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode[a]ction')
                lnmap('gd', telescope.lsp_definitions, '[g]oto [d]efinition')
                lnmap('gr', telescope.lsp_references, '[g]oto [r]eferences')
                lnmap('<leader>/d', telescope.lsp_document_symbols, 'Search document symbols')
                lnmap('<leader>/w', telescope.lsp_dynamic_workspace_symbols, 'Search workspace symbols')
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
    { -- Lua LSP for Neovim config
        'folke/neodev.nvim',
        config = true,
    },
    { -- LSP status
        'j-hui/fidget.nvim',
        config = true,
    },
}
