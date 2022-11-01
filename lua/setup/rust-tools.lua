local ok, rt = pcall(require, 'rust-tools')
if not ok then
    print('unable to run rust-tools.lua : rust-tools not available')
    return
end

local ok, lsp = pcall(require, 'cmp_nvim_lsp')
if not ok then
    print('cmp_nvim_lsp not available for rust-tools')
    return
end

local cap = lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())
local opts = {
    -- rust-tools options
    tools = {
        inlay_hints = {
            only_current_line = true,
            show_parameter_hints = false,
            other_hints_prefix = '',
            highlight = 'GruvboxBlue',
        },
    },

    -- nvim-lspconfig options (overrides rust-tools defaults)
    server = {
        capabilities = cap,
        on_attach = function(c, b)
            vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = b })
            vim.keymap.set('n', '<Leader>a', rt.code_action_group.code_action_group, { buffer = b })
            -- Mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local bufopts = { noremap=true, silent=true, buffer=b }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
        end,
        settings = {
            ['rust-analyzer'] = {
                cargo = {
                    fatures = 'all', 
                },
                checkOnSave = {
                    -- default: `cargo check`
                    command = 'clippy',
                },
                -- inlayHints = {
                    -- enable = false,
                    -- lifetimeEllisionHints = {
                    --     enable = true,
                    --     useParameterNames = true,
                    -- },
                -- },
            },
        },
    },
}

require('rust-tools').setup(opts)

