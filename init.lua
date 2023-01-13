-- Install Packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- Basic options
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<space>', '<nop>', { silent = true })

vim.o.clipboard = 'unnamedplus'
vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 6
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.backup = false
vim.o.writebackup = false
vim.o.hidden = true
vim.o.mouse = 'a'
vim.o.wrap = false
vim.o.updatetime = 250
vim.o.timeoutlen = 250
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.wo.signcolumn = 'yes'

-- General keymaps
local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { noremap = true, silent = true, desc = desc })
end
nmap('<C-h>', '<C-w>h', 'Move left to the next window')
nmap('<C-j>', '<C-w>j', 'Move down to the next window')
nmap('<C-k>', '<C-w>k', 'Move up to the next window')
nmap('<C-l>', '<C-w>l', 'Move right to the next window')
nmap('<S-ScrollWheelUp>', '5z<Left>', 'Horizontal scroll left')
nmap('<S-ScrollWheelDown>', '5z<Right>', 'Horizontal scroll right')
nmap('<A-j>', ':m .+1<CR>==', 'Move line down')
nmap('<A-k>', ':m .-2<CR>==', 'Move line up')
nmap('[d', vim.diagnostic.goto_prev, 'Goto previous [d]iagnostic')
nmap(']d', vim.diagnostic.goto_next, 'Goto next [d]iagnostic')
nmap('<leader>e', vim.diagnostic.open_float, 'Open diagnostics float')

local vmap = function(keys, func, desc)
  vim.keymap.set('v', keys, func, { noremap = true, silent = true, desc = desc })
end
vmap('<', '<gv', 'Stay in indent mode after left indent')
vmap('>', '>gv', 'Stay in indent mode after right indent')

local xmap = function(keys, func, desc)
  vim.keymap.set('x', keys, func, { noremap = true, silent = true, desc = desc })
end

vim.keymap.set({ 'v', 'x' }, '<A-j>', ":m '>+1<CR>gv=gv'", { noremap = true, silent = true, desc = 'Move selection down' })
vim.keymap.set({ 'v', 'x' }, '<A-k>', ":m '<-2<CR>gv=gv'", { noremap = true, silent = true, desc = 'Move selection up' })

local packer = require('packer')

-- Tell Packer to open in a float (becaues it looks cool)
packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end
  },
}

-- Tell Packer what plugins we want
packer.startup(function(use)
  -- Packer itself
  use 'wbthomason/packer.nvim'

  -- LSP
  use 'neovim/nvim-lspconfig'

  use { -- Helpful LSP installer
    'williamboman/mason.nvim',
    requires = { 'williamboman/mason-lspconfig.nvim' },
    config = function()
      require('mason').setup {}
    end,
  }

  use { -- LSP status indicator
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup {}
    end,
  }

  use { -- Additional lua conig stuff ??
    'folke/neodev.nvim',
    config = function()
      require('neodev').setup {}
    end,
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  }

  use { -- Language syntax awareness
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional syntax awareness
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  use { -- Terminal
    'akinsho/toggleterm.nvim',
    tag = 'v2.*',
    config = function()
      require('toggleterm').setup {
        open_mapping = [[<C-\>]],
        direction = 'float',
      }
      -- Windows can be weird (try this for example)
      -- vim.o.shell = 'C:/Program Files/Git/git-bash.exe'
      -- vim.o.shellcmdflag = '--login -i -c'
      -- vim.o.shellxquote = ''
    end,
  }

  -- Git stuff
  use 'lewis6991/gitsigns.nvim'

  use { -- Fuzzy finder
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
      'nvim-lua/plenary.nvim',
    },
  }

  use { -- Make fuzzy finder even faster (if possible)
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    cond = vim.fn.executable 'make' == 1,
  }

  use { -- Colorscheme
    'ellisonleao/gruvbox.nvim',
    config = function()
      require('gruvbox').setup {
        italic = false,
      }
      vim.o.termguicolors = true
      vim.cmd [[colorscheme gruvbox]]
    end,
  }

  use { -- Nicer status line
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = 'gruvbox',
          component_separators = '|',
          section_separators = '',
        },
      }
    end,
  }

  use { -- Syntax aware commenting
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {}
    end,
  }

  use { -- Show leading + active indent guides
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        show_trailing_blankline_indent = false,
      }
      vim.o.list = true
    end,
  }

  if is_bootstrap then
    require('packer').sync()
  end
end)

if is_bootstrap then
  print 'Bootstrapping...when Packer completes, restart nvim'
  return
end

-- Do the more complex plugin setup down here

-- telescope stuff
require('telescope').setup {}
pcall(require('telescope').load_extension, 'fzf')
local builtin = require 'telescope.builtin'
nmap('<leader>?', builtin.oldfiles, '[?] Find recently opened files')
nmap('<leader><space>', builtin.buffers, '[ ] Find existing buffers')
nmap('<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, '[/] Fuzzy search in current buffer')
nmap('<leader>sf', builtin.find_files, '[s]earch [f]iles')
nmap('<leader>sh', builtin.help_tags, '[s]earch [h]elp')
nmap('<leader>sw', builtin.grep_string, '[s]earch [w]ord')
nmap('<leader>sg', builtin.live_grep, '[s]earch [g]rep')
nmap('<leader>sd', builtin.diagnostics, '[s]earch [d]iagnostics')

-- tree-sitter stuff
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'javascript', 'typescript', 'help', 'vim' },
  highlight = { enable = true },
  indent = { enable = true },
  -- TODO: incremental_selection = { ... }
  -- TODO: textobjects = { ... }
}

-- LSP stuff
local on_attach = function(_, bufnr)
  local lnmap = function(keys, func, desc)
    desc = 'LSP: ' .. desc
    nmap(keys, func, desc)
  end

  -- keymaps for LSP attached buffers (Telescope gives us extra goodies)
  local telescope = require 'telescope.builtin'
  lnmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
  lnmap('<leader>ca', vim.lsp.buf.code_action, '[c]ode[a]ction')
  lnmap('gd', telescope.lsp_definitions, '[g]oto [d]efinition')
  lnmap('gr', telescope.lsp_references, '[g]oto [r]eferences')
  lnmap('<leader>ds', telescope.lsp_document_symbols, '[d]ocument [s]ymbols')
  lnmap('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')
  lnmap('K', vim.lsp.buf.hover, 'Hover documentation')
  lnmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')

  -- Custom `:Format` command
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format the current buffer' })
end

local servers = {
  pyright = {},
  rust_analyzer = {},
  sumneko_lua = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Mason LSP configuration
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local mason = require 'mason-lspconfig'
mason.setup {
  ensure_installed = vim.tbl_keys(servers),
}
mason.setup_handlers {
  function(server)
    require('lspconfig')[server].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server],
    }
  end,
}

-- Autocomplete configuration
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  completion = { completeopt = 'menuone,noinsert,noselect' },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<Esc>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand {}
      else
        fallback()
      end
    end, { 'i' }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- vim: ts=2 sts=2 sw=2 et
