-- Highlight yanked text -- credit to https://github.com/nvim-lua/kickstart.nvim
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Custom `:Hitest` command
vim.api.nvim_create_user_command('Hitest', function(_)
  vim.cmd.ru [[syntax/hitest.vim]]
end, { desc = 'Run $VIMRUNTIME/syntax/hitest.vim' })

-- Custom Angular command for https://github.com/divandenberg/tree-sitter-angular language
vim.filetype.add({
  pattern = {
    ['.*%.component%.html'] = 'angular.html',
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'angular.html',
  callback = function ()
    vim.treesitter.language.register('angular', 'angular.html')
  end
})

-- vim: ts=2 sts=2 sw=2 et
