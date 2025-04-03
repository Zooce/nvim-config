return {
  { -- file tree
    'nvim-tree/nvim-tree.lua',
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require('nvim-tree').setup()
    end
  },
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
        win = { border = 'single' },
        icons = { mappings = false },
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
  { -- terminal
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<C-\>]],
        direction = 'float',
      }
      if vim.uv.os_uname().sysname == "Windows_NT" then
        vim.cmd [[let &shell = '"C:/Program Files/Git/bin/bash.exe"']]
        vim.cmd [[let &shellcmdflag = '-s']]
      end
    end,
  },
  { -- status line
    'nvim-lualine/lualine.nvim',
    lazy = false,
    priority = 999,
    config = function()
      require('lualine').setup {
        options = {
          theme = 'indomitable',
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
    config = function()
      require('ibl').setup{
        indent = { char = '▏' },
        scope = { enabled = false },
      }
      local helpers = require('helpers')
      helpers.nmap('<leader>|', ':IBLToggle<CR>', 'Toggle indentation guides');
    end,
  },
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup {
        user_default_options = { names = false },
      }
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
