-- set up single borders for lsp
vim.lsp.handlers['textDocument/hover'] = function(_, result)
  vim.lsp.util.open_floating_preview(result.contents, result.contents.kind, { border = 'single' })
end
vim.lsp.handlers['textDocument/signatureHelp'] = function(_, result)
  vim.lsp.util.open_floating_preview(result.contents, result.contents.kind, { border = 'single' })
end
vim.diagnostic.config{
  float = { border = 'single' },
}

-- enable LSPs
-- configs located in .config/nvim/lsp/*.lua
-- vim.lsp.enable('lua_ls');

return {
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {},
    dependencies = {
      { -- Mason for easier LSPs installation
        'mason-org/mason.nvim',
        opts = {
          ui = {
            border = 'single',
          },
        },
      },
      'neovim/nvim-lspconfig',
    },
    config = true,
  },
  { -- Lua LSP for Neovim config
    'folke/lazydev.nvim',
    ft = 'lua',
    config = true,
  },
}
