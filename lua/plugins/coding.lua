return {
  { -- comment toggling
    'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = true,
    event = 'BufRead',
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'BufRead',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('ts_context_commentstring').setup{};
      vim.g.skip_ts_context_commentstring_module = true;
    end,
  },
  { -- surround
    'tpope/vim-surround',
    event = 'BufRead',
    dependencies = { 'tpope/vim-repeat' },
  },
  { -- language awareness
    'nvim-treesitter/nvim-treesitter',
    event = 'BufRead',
    build = function()
      require('nvim-treesitter.install').update({ with_sync = true })()
    end,
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      -- learned this from https://github.com/nvim-lua/kickstart.nvim
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup({
        sync_install = false,
        auto_install = true,
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
        ensure_installed = {
          'angular',
          'bash',
          'c', 'comment', 'cpp', 'css',
          'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore',
          'html', 'http',
          'java', 'javascript', 'jsdoc', 'json', 'json5', 'jsonc',
          'lua',
          'markdown', 'markdown_inline',
          'python',
          'ron', 'rust',
          'scss', 'sql', 'svelte',
          'toml', 'tsx', 'typescript',
          'vim',
          'yaml',
          'zig',
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
      })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
