-- [[ keys.lua ]]

local helpers = require 'helpers'

-- Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<space>', '<nop>', { silent = true })

helpers.nmap('<C-h>', '<C-w>h', 'Move left to the next window')
helpers.nmap('<C-j>', '<C-w>j', 'Move down to the next window')
helpers.nmap('<C-k>', '<C-w>k', 'Move up to the next window')
helpers.nmap('<C-l>', '<C-w>l', 'Move right to the next window')
helpers.nmap('<S-ScrollWheelUp>', '5z<Left>', 'Horizontal scroll left')
helpers.nmap('<S-ScrollWheelDown>', '5z<Right>', 'Horizontal scroll right')
helpers.nmap('<A-j>', ':m .+1<CR>==', 'Move line down')
helpers.nmap('<A-k>', ':m .-2<CR>==', 'Move line up')
helpers.nmap('[d', vim.diagnostic.goto_prev, 'Goto previous [d]iagnostic')
helpers.nmap(']d', vim.diagnostic.goto_next, 'Goto next [d]iagnostic')
helpers.nmap('<leader>e', vim.diagnostic.open_float, 'Open diagnostics float')

helpers.vmap('<', '<gv', 'Stay in indent mode after left indent')
helpers.vmap('>', '>gv', 'Stay in indent mode after right indent')

vim.keymap.set({ 'v', 'x' }, '<A-j>', ":m '>+1<CR>gv=gv'", { noremap = true, silent = true, desc = 'Move selection down' })
vim.keymap.set({ 'v', 'x' }, '<A-k>', ":m '<-2<CR>gv=gv'", { noremap = true, silent = true, desc = 'Move selection up' })