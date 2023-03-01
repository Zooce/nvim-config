return {
  { -- show git status marks
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    config = true,
  },
  { -- show available keymaps
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require('which-key').setup{}
    end,
  },
  {
    'jesseleite/nvim-noirbuddy',
    dependencies = { 'tjdevries/colorbuddy.nvim' },
    enabled = false,
    lazy = false,
    priority = 1000,
    config = true,
  },
  { -- colorscheme
    'ellisonleao/gruvbox.nvim',
    enabled = true,
    lazy = false,
    priority = 1000, -- be one of the first to load
    config = function()
      local palette = require 'gruvbox.palette'
      local searchColors = {
        bg = palette.bright_orange,
        fg = palette.dark0_hard,
      }
      require('gruvbox').setup {
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
    event = 'VeryLazy',
    enabled = function()
      return vim.loop.os_uname().sysname ~= 'Windows_NT'
    end,
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<C-\>]],
        direction = 'float',
      }
    end,
  },
  { -- status line
    'nvim-lualine/lualine.nvim',
    lazy = false,
    priority = 999,
    config = function()
      -- local noir = require('noirbuddy.plugins.lualine')
      require('lualine').setup {
        options = {
          -- theme = noir.theme,
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
  { -- show indent guides
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufRead',
    config = function()
      require('indent_blankline').setup {
        show_current_context = true,
      }
    end,
  },
  { -- auto detect indentation
    'tpope/vim-sleuth',
    event = 'BufReadPre',
  },
  -- TODO: consider https://github.com/folke/noice.nvim
}

-- vim: ts=2 sts=2 sw=2 et
