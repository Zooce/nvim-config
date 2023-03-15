local helpers = require 'helpers'

vim.keymap.set({ 'n', 'v' }, '<space>', '<nop>', { silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

helpers.nmap('<C-h>', '<C-w>h', 'Move left to the next window')
helpers.nmap('<C-j>', '<C-w>j', 'Move down to the next window')
helpers.nmap('<C-k>', '<C-w>k', 'Move up to the next window')
helpers.nmap('<C-l>', '<C-w>l', 'Move right to the next window')
helpers.nmap('<A-j>', ':m .+1<CR>==', 'Move line down')
helpers.nmap('<A-k>', ':m .-2<CR>==', 'Move line up')
helpers.nmap('[e', vim.diagnostic.goto_prev, 'Goto previous diagnostic')
helpers.nmap(']e', vim.diagnostic.goto_next, 'Goto next diagnostic')
helpers.nmap('<leader>q', vim.diagnostic.setloclist, 'Place diagnostics in the location list')
helpers.nmap('<leader><del>', ':%s/\\s\\+$//e<CR>', 'Remove trailing whitespace')
helpers.nmap('<leader>gl', '^vg_', 'Visual select current line content')

helpers.vmap('p', '"_dP', 'Keep clipboard after pasting over a selection')
helpers.vmap('<', '<gv', 'Stay in indent mode after left indent')
helpers.vmap('>', '>gv', 'Stay in indent mode after right indent')

helpers.keymap({ 'v', 'x' }, '<A-j>', ":m '>+1<CR>gv=gv", 'Move selection down')
helpers.keymap({ 'v', 'x' }, '<A-k>', ":m '<-2<CR>gv=gv", 'Move selection up')

helpers.keymap({ 'n', 'v' }, '<S-ScrollWheelUp>', '5z<Left>', 'Horizontal scroll left')
helpers.keymap({ 'n', 'v' }, '<S-ScrollWheelDown>', '5z<Right>', 'Horizontal scroll right')

if vim.loop.os_uname().sysname == 'Windows_NT' then
  helpers.nmap('<C-\\>', ':terminal<CR>i', 'Open the terminal')
  helpers.keymap('t', '<C-\\>', '<C-\\><C-N>:q', 'Close the terminal')
end
-- vim: ts=2 sts=2 sw=2 et
