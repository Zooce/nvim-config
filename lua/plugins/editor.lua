return {
    { -- show git status marks
        'lewis6991/gitsigns.nvim',
        config = true,
    },
    { -- show available keymaps
        'folke/which-key.nvim',
        config = true,
    },
    { -- colorscheme
        'ellisonleao/gruvbox.nvim',
        priority = 1000, -- be one of the first to load
        config = function()
            local palette = require 'gruvbox.palette'
            local searchColors = {
                bg = palette.bright_orange,
                fg = palette.dark0_hard,
            }
            require('gruvbox').setup{
                italic = false,
                inverse = false,
                overrides = {
                    IncSearch = searchColors,
                    Search = searchColors,
                },
            }
            vim.o.background = 'dark' -- use 'light' for the light version
            vim.cmd [[colorscheme gruvbox]]
        end,
    },
    { -- terminal
        'akinsho/toggleterm.nvim',
        config = function()
            require('toggleterm').setup{
                open_mapping = [[<C-\>]],
                direction = 'float',
            }
        end,
    },
    { -- status line
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup{
                options = {
                    icons_enabled = false,
                    component_separators = '.',
                    section_separators = '',
                },
                sections = {
                    -- TODO: consider some of the same sections from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/ui.lua
                    lualine_x = {
                        'encoding',
                        'fileformat',
                        'filetype',
                        {
                            require('lazy.status').updates,
                            cond = require('lazy.status').has_updates,
                            color = { fg = "#ff9e64" },
                        },
                    },
                },
            }
        end,
    },
    -- TODO: consider https://github.com/folke/noice.nvim
}
