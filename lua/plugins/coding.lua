return {
    { -- comment toggling
        'numToStr/Comment.nvim',
        config = true,
    },
    { -- language awareness
        'nvim-treesitter/nvim-treesitter',
        build = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
        dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
        config = function()
            -- learned this from kickstart.nvim (TODO: put the github URL here)
            require('nvim-treesitter.configs').setup {
                -- ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'javascript', 'typescript', 'help', 'vim', 'zig' },
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<CR>',
                        node_incremental = '<CR>',
                        scope_incremental = '<S-CR>',
                        node_decremental = '<BS>',
                    },
                },
                -- textobjects = {
                --     select = {
                --         enable = true,
                --         lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                --         keymaps = {
                --             -- You can use the capture groups defined in textobjects.scm
                --             ['aa'] = '@parameter.outer',
                --             ['ia'] = '@parameter.inner',
                --             ['af'] = '@function.outer',
                --             ['if'] = '@function.inner',
                --             ['ac'] = '@class.outer',
                --             ['ic'] = '@class.inner',
                --         },
                --     },
                --     move = {
                --         enable = true,
                --         set_jumps = true, -- whether to set jumps in the jumplist
                --         goto_next_start = {
                --             [']m'] = '@function.outer',
                --             [']]'] = '@class.outer',
                --         },
                --         goto_next_end = {
                --             [']M'] = '@function.outer',
                --             [']['] = '@class.outer',
                --         },
                --         goto_previous_start = {
                --             ['[m'] = '@function.outer',
                --             ['[['] = '@class.outer',
                --         },
                --         goto_previous_end = {
                --             ['[M'] = '@function.outer',
                --             ['[]'] = '@class.outer',
                --         },
                --     },
                --     swap = {
                --         enable = true,
                --         swap_next = {
                --             ['<leader>a'] = '@parameter.inner',
                --         },
                --         swap_previous = {
                --             ['<leader>A'] = '@parameter.inner',
                --         },
                --     },
                -- },
            }
        end,
    },
}
