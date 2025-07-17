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

-- Always use htmlangular for Angular component templates
local htmlangular_group = vim.api.nvim_create_augroup('HtmlAngular', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = htmlangular_group,
  pattern = '*.component.html',
  callback = function()
    vim.bo.filetype = 'htmlangular'
  end,
})
