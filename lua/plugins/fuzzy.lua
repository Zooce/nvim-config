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
            nmap('<leader>?', builtin.help_tags, 'Search :help tags')
            nmap('<leader>/b', builtin.buffers, 'Search open buffers')
            nmap('<leader>//', function()
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, 'Search in current buffer')
            nmap('<leader>/f', builtin.find_files, 'Search files')
            nmap('<leader>/g', builtin.live_grep, 'Search grep')
            nmap('<leader>/e', builtin.diagnostics, 'Search diagnostics')
        end
    },
    { -- help telescope order its results
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = vim.fn.executable 'make' == 1,
    },
}

-- vim: ts=2 sts=2 sw=2 et
