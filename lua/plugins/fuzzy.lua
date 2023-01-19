return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzf-native.nvim',
        },
        config = function()
            local telescope = require 'telescope'
            telescope.setup {}
            pcall(telescope.load_extension, 'fzf')

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
        end
    },
    { -- help telescope order its results
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = vim.fn.executable 'make' == 1,
    },
}
