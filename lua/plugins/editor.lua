return {
  { -- show git status marks
    'lewis6991/gitsigns.nvim',
    config = true,
    event = 'BufRead',
  },
  { -- show available keymaps
    'folke/which-key.nvim',
    config = true,
    event = 'VeryLazy',
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
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<C-\>]],
        direction = 'float',
      }
      -- EXPERIMENTAL: try to get this working on Windows
      if vim.loop.os_uname().sysname == 'Windows_NT' then
        -- might also need to set `vim.o.shell = '<path to shell>'`
        -- and `vim.o.shellcmdflag = '<shell args like --login -i -c>'`
        vim.o.shellxquote = ''
      end
    end,
    event = 'VeryLazy',
  },
  { -- status line
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
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
  { -- show indent guides
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        show_current_context = true,
      }
    end,
    event = 'BufRead',
  },
  { -- auto detect indentation
    'tpope/vim-sleuth',
    event = 'BufRead',
  },
  -- TODO: consider https://github.com/folke/noice.nvim
}

-- vim: ts=2 sts=2 sw=2 et
