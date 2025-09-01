local helpers = require('helpers')
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
      telescope.setup({
        defaults = {
          ---@diagnostic disable-next-line: unused-local
          path_display = function(opts, path)
            local tail = require('telescope.utils').path_tail(path);
            local p = string.sub(path, 1, -(#tail + 1))
            local padding = vim.api.nvim_win_get_width(0) - (#tail + #p) - 3
            if padding < 0 then
              padding = 0
            end
            return tail .. string.rep(' ', padding) .. p
          end,
        },
        pickers = {
          lsp_references = { show_line = false },
          lsp_definitions = { show_line = false },
          lsp_document_symbols = { symbol_width = 0, symbol_type_width = 0 },
          lsp_dynamic_workspace_symbols = { symbol_width = 0, symbol_type_width = 0 },
          lsp_workspace_symbols = { symbol_width = 0, symbol_type_width = 0 },
        },
      })
      pcall(telescope.load_extension, 'fzf')

      -- keymaps
      local nmap = helpers.nmap
      local builtin = require 'telescope.builtin'
      nmap('<leader>?', function() builtin.help_tags(helpers.dropdown(false)) end, 'Search :help tags')
      nmap('<leader>/b', function() builtin.buffers(helpers.dropdown(false)) end, 'Search open buffers')
      nmap('<leader>/f', function() builtin.find_files(helpers.dropdown(false)) end, 'Search files')
      nmap('<leader>/h', function()
        builtin.find_files(vim.tbl_extend('force', helpers.dropdown(false), {
          hidden = true,
          no_ignore = true,
        }))
      end, 'Search files (incl. hidden/ignored)')
      nmap('<leader>//', function() builtin.current_buffer_fuzzy_find(helpers.dropdown(true)) end, 'Search in current buffer')
      nmap('<leader>/g', function() builtin.live_grep(helpers.dropdown(true)) end, 'Search grep')
      nmap('<leader>/e', function() builtin.diagnostics(helpers.dropdown(true)) end, 'Search workspace diagnostics')
      nmap('<leader>/w', function() builtin.grep_string(helpers.dropdown(true)) end, 'Search word')
      nmap('gd', function() builtin.lsp_definitions(helpers.dropdown(true)) end, '[g]oto [d]efinition')
      nmap('<leader>/r', function() builtin.lsp_references(helpers.dropdown(true)) end, 'Search references')
      nmap('<leader>/sd', function() builtin.lsp_document_symbols(helpers.dropdown(true)) end, 'Search document symbols')
      nmap('<leader>/sw', function() builtin.lsp_dynamic_workspace_symbols(helpers.dropdown(true)) end, 'Search workspace symbols')
      nmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
      nmap('<leader>.', vim.lsp.buf.code_action, '[c]ode[a]ction')
      nmap('K', vim.lsp.buf.hover, 'Hover documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')
    end
  },
  { -- help telescope order its results
    'nvim-telescope/telescope-fzf-native.nvim',
    cond = vim.fn.executable 'make' == 1 or vim.fn.executable 'cmake' == 1,
    build = function()
      if vim.fn.executable 'make' == 1 then
        return 'make'
      elseif vim.fn.executable 'cmake' == 1 then
        return 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
      end
    end,
  },
}
