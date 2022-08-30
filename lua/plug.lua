-- [[ plugins.lua ]]

-- bootstrap
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end

-- reload plugins when saving this file
-- vim.cmd([[
--    augroup packer_user_config
--        autocmd!
--        autocmd BufWritePost plug.lua source <afile> | PackerCompile
--    augroup end
-- ]])

-- make sure we'll cool (thanks https://github.com/LunarVim/Neovim-from-scratch)
local ok, packer = pcall(require, 'packer')
if not ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require('packer.util').float({ border = 'rounded' })
		end,
	},
})

return packer.startup(function(use)
    -- [[ Plugins ]]

    -- packer
    use 'wbthomason/packer.nvim'

    -- common (required by other plugins)
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'
    use 'mfussenegger/nvim-dap'

    -- file explorer
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', opt = true },
        tag = 'nightly', -- optional, updated every week. (see issue #1193)
        config = function()
            require('nvim-tree').setup()
        end,
    }

    -- status line
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup()
        end,
    }

    -- treesitter (useful for other plugins to calculate things)
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate' -- this will fail on the first install
    }

    -- commenting
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
    }

    -- telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} },
        config = function()
            require('telescope').setup()

        end,
    }

    -- which key
    use {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup({
                window = {
                    border = 'single',
                },
            })
        end,
    }

    -- colorscheme
    use {
        'ellisonleao/gruvbox.nvim',
        config = function()
            require('gruvbox').setup({
                italic = false,
            })
            vim.cmd('colorscheme gruvbox')
        end,
    }

    -- lsp
    use {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end
    }
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use 'simrat39/rust-tools.nvim'

    -- completion (see setup/cmp.lua)
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-path'

    -- snippets (required by completion)
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    -- rust crates
    use {
        'saecki/crates.nvim',
        event = { 'BufRead Cargo.toml' }, -- trigger when we open a Crates.toml file
        requires = { { 'nvim-lua/plenary.nvim' } },
        config = function()
            require('crates').setup()
        end,
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
