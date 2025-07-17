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
        fold = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<CR>',
            node_incremental = '<CR>',
            scope_incremental = '<S-CR>',
            node_decremental = '<BS>',
          },
        },
      })
      vim.opt.foldmethod = 'expr'
      vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.opt.foldlevel = 99
    end,
  },
}
