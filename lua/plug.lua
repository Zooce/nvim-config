-- [[ plugins.lua ]]

-- if we don't have Packer yet, let's get it started
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- This table defines the plugin specs for Packer + config functions for after Packer startup.
-- I'm doing it this way so I can keep the configuration together with the spcification - I don't
-- really like when they are separated.
local plugin_specs = {
    { -- Packer itself
        spec = 'wbthomason/packer.nvim',
    },
    { -- Mason for all LSP management
        spec = {
            'williamboman/mason.nvim',
            requires = {
                'williamboman/mason-lspconfig.nvim',
                'neovim/nvim-lspconfig',
                'hrsh7th/cmp-nvim-lsp',
                'nvim-telescope/telescope.nvim',
                'j-hui/fidget.nvim',
            },
        },
        setup = function()
            require('mason').setup{}

            -- put other LSP servers you want here
            local servers = {
                pyright = {},
                rust_analyzer = {},
                sumneko_lua = {
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
                ensure_installed = vim.tbl_keys(servers)
            }
            mason_config.setup_handlers {
                function(server)
                    require('lspconfig')[server].setup {
                        capabilities = capabilities,
                        settings = servers[server],
                        on_attach = function(_, bufnr)
                            local lnmap = function(k, f, d)
                                require('helpers').nmap(k, f, 'LSP: ' .. d)
                            end

                            -- keymaps for LSP attached buffers (Telescope gives us extra goodies)
                            local telescope = require 'telescope.builtin'
                            lnmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
                            lnmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode[a]ction')
                            lnmap('gd', telescope.lsp_definitions, '[g]oto [d]efinition')
                            lnmap('gr', telescope.lsp_references, '[g]oto [r]eferences')
                            lnmap('<leader>ds', telescope.lsp_document_symbols, '[d]ocument [s]ymbols')
                            lnmap('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')
                            lnmap('K', vim.lsp.buf.hover, 'Hover documentation')
                            lnmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')

                            -- Custom `:Format` command
                            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                                vim.lsp.buf.format()
                            end, { desc = 'Format the current buffer' })
                        end,
                    }
                end
            }

            -- LSP status indicator
            require('fidget').setup{}
        end,
    },
    { -- Autocompletion
        spec = {
            'hrsh7th/nvim-cmp',
            requires = {
                'hrsh7th/cmp-nvim-lsp',
                'L3MON4D3/LuaSnip',
                'saadparwaiz1/cmp_luasnip',
            },
        },
        setup = function()
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-space>'] = cmp.mapping.complete{},
                    ['<CR>'] = cmp.mapping.confirm { select = false },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expandable_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
            }
        end,
    },
    { -- Language syntax awareness
        spec = {
            'nvim-treesitter/nvim-treesitter',
            run = function()
                pcall(require('nvim-treesitter.install').update{ with_sync = true })
            end,
        },
        setup = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'javascript', 'typescript', 'help', 'vim' },
                highlight = { enable = true },
                indent = { enable = true },
            }
        end,
    },
    { -- Additional text objects via treesitter
        spec = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            after = 'nvim-treesitter',
        },
    },
    { -- Fuzzy finder
        spec = {
            'nvim-telescope/telescope.nvim',
            branch = '0.1.x',
            requires = { 'nvim-lua/plenary.nvim' },
        },
        setup = function()
            local telescope = require 'telescope'
            telescope.setup{}
            pcall(telescope.load_extension, 'fzf') -- TODO: require `nvim-telescope/telescope-fzf-native.nvim` ??

            -- keymaps
            local nmap = require('helpers').nmap
            local builtin = require 'telescope.builtin'
            nmap('<leader>?', builtin.oldfiles, '[?] Find recently opened files')
            nmap('<leader><space>', builtin.buffers, '[ ] Find existing buffers')
            nmap('<leader>/', function()
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, '[/] Fuzzy search in current buffer')
            nmap('<leader>sf', builtin.find_files, '[s]earch [f]iles')
            nmap('<leader>sh', builtin.help_tags, '[s]earch [h]elp')
            nmap('<leader>sw', builtin.grep_string, '[s]earch [w]ord')
            nmap('<leader>sg', builtin.live_grep, '[s]earch [g]rep')
            nmap('<leader>sd', builtin.diagnostics, '[s]earch [d]iagnostics')
        end,
    },
    { -- (Try) to make fuzzy finding faster
        spec = {
            'nvim-telescope/telescope-fzf-native.nvim',
            run = 'make',
            cond = vim.fn.executable 'make' == 1,
        },
    },
    { -- Git status indicators
        spec = 'lewis6991/gitsigns.nvim',
        setup = function()
            require 'gitsigns'
        end,
    },
    { -- Status line
        spec = 'nvim-lualine/lualine.nvim',
        setup = function()
            require('lualine').setup {
                options = {
                    icons_enabled = false,
                    component_separators = '|',
                    section_separators = '',
                },
            }
        end
    },
    { -- Comment toggling
        spec = 'numToStr/Comment.nvim',
        setup = function()
            require('Comment').setup{}
        end,
    },
    -- TODOs
    -- tpope/vim-fugitive
}

-- Packer init/startup
local packer = require 'packer'
packer.init {
    display = {
        open_fn = function()
            return require('packer.util').float {}
        end,
    },
}
packer.startup(function(use)
    for _, v in pairs(plugin_specs) do
        use(v.spec)
    end
    if is_bootstrap then
        require('packer').sync()
    end
end)

-- Plugin setup functions
for _, v in pairs(plugin_specs) do
    if v.setup ~= nil then
        v.setup()
    end
end

