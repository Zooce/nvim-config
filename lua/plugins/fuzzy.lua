return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      local dropdown = function(preview)
        return require('telescope.themes').get_dropdown({
          borderchars = {
            { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
            prompt = {'─', '│', ' ', '│', '┌', '┐', '│', '│'},
            results = {'─', '│', '─', '│', '├', '┤', '┘', '└'},
            preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
          },
          preview = preview,
          layout_config = { width = 0.7, height = 0.6 },
        })
      end
      local telescope = require 'telescope'
      telescope.setup{
        defaults = dropdown(false)
      }
      pcall(telescope.load_extension, 'fzf')

      -- keymaps
      local nmap = require('helpers').nmap
      local builtin = require 'telescope.builtin'
      nmap('<leader>?', builtin.help_tags, 'Search :help tags')
      nmap('<leader>/b', builtin.buffers, 'Search open buffers')
      nmap('<leader>/f', builtin.find_files, 'Search files')
      nmap('<leader>/h', function()
        builtin.find_files(vim.tbl_extend('force', dropdown(false), {
          hidden = true,
          no_ignore = true,
        }))
      end, 'Search files (incl. hidden/ignored)')
      nmap('<leader>//', function() builtin.current_buffer_fuzzy_find(dropdown(true)) end, 'Search in current buffer')
      nmap('<leader>/g', function() builtin.live_grep(dropdown(true)) end, 'Search grep')
      nmap('<leader>/e', function() builtin.diagnostics(dropdown(true)) end, 'Search diagnostics')
      nmap('<leader>/w', function() builtin.grep_string(dropdown(true)) end, 'Search word')
    end
  },
  { -- help telescope order its results
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = vim.fn.executable 'make' == 1,
  },
}

-- vim: ts=2 sts=2 sw=2 et
