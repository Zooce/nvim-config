return {
  { -- show git status marks
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    config = function()
      require('gitsigns').setup{
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = 'Goto previous change' })
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = 'Goto next change' })
        end
      }
    end,
  },
  { -- show available keymaps
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require('which-key').setup{
        window = { border = 'single' },
      }
    end,
  },
  { -- colorscheme
    'Zooce/indomitable.nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      require('indomitable')
      vim.cmd [[colorscheme indomitable]]
    end,
  },
  -- { -- colorscheme
  --   'ellisonleao/gruvbox.nvim',
  --   enabled = false,
  --   lazy = false,
  --   priority = 1000, -- be one of the first to load
  --   config = function()
  --     local palette = require 'gruvbox.palette'
  --     local searchColors = {
  --       bg = palette.bright_orange,
  --       fg = palette.dark0_hard,
  --     }
  --     require('gruvbox').setup {
  --       bold = false,
  --       italic = {
  --         strings = false,
  --         comments = false,
  --         operators = false,
  --         folds = false,
  --       },
  --       inverse = false,
  --       overrides = {
  --         IncSearch = searchColors,
  --         Search = searchColors,
  --       },
  --     }
  --     vim.o.background = 'dark' -- use 'light' for the light version
  --     vim.cmd [[colorscheme gruvbox]]
  --   end,
  -- },
  { -- terminal
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<C-\>]],
        direction = 'float',
      }
      -- FIXME: on Windows this doesn't seem to work with GitBash
    end,
  },
  { -- status line
    'nvim-lualine/lualine.nvim',
    lazy = false,
    priority = 999,
    config = function()
      require('lualine').setup {
        options = {
          theme = require('indomitable.lualine'),
          icons_enabled = false,
          component_separators = '',
          section_separators = '',
          globalstatus = true,
        },
        sections = {
          -- TODO: consider some of the same sections from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/ui.lua
          lualine_b = { 'filename' },
          lualine_c = { 'branch', 'diff', 'diagnostics' },
          lualine_x = {
            'encoding',
            'fileformat',
            'filetype',
            {
              require('lazy.status').updates,
              cond = require('lazy.status').has_updates,
              color = { fg = require('indomitable.palette').changed }, -- was #ff9e64
            },
          },
        },
      }
    end,
  },
  { -- show indent guides
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufRead',
    main = 'ibl',
    opts = {},
    config = true,
  },
  { -- auto detect indentation
    'tpope/vim-sleuth',
    event = 'BufReadPre',
  },
  -- {
  --   'folke/trouble.nvim',
  --   dependencies = { 'nvim-tree/nvim-web-devicons' },
  --   event = 'BufRead',
  --   config = function()
  --     require('trouble').setup {}
  --     local helpers = require('helpers')
  --     helpers.nmap('<leader>xx', '<cmd>TroubleToggle<cr>', 'Toggle Trouble')
  --     helpers.nmap('<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', 'Toggle Trouble (Workspace)')
  --     helpers.nmap('<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', 'Toggle Trouble (Document)')
  --   end,
  -- },
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup {
        user_default_options = { names = false },
      }
    end,
  },
  -- TODO: consider https://github.com/folke/noice.nvim
  -- TODO: considerhttps://github.com/natecraddock/workspaces.nvim 
}

-- vim: ts=2 sts=2 sw=2 et
