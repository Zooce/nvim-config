local helpers = require 'helpers'

vim.keymap.set({ 'n', 'v' }, '<space>', '<nop>', { silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- credit to https://www.reddit.com/r/neovim/comments/1335pfc/comment/jiaagyi/?utm_source=share&utm_medium=web2x&context=3
local function close_float()
  local inactive_wins = vim.fn.filter(vim.api.nvim_list_wins(), function(_, v)
    return vim.api.nvim_win_get_config(v).relative ~= ''
      and v ~= vim.api.nvim_get_current_win()
  end)
  for _, win in ipairs(inactive_wins) do
    pcall(vim.api.nvim_win_close, win, false)
  end
end
helpers.nmap('<M-j>', ':m .+1<CR>==', 'Move line down')
helpers.nmap('<M-k>', ':m .-2<CR>==', 'Move line up')
helpers.nmap('[e', vim.diagnostic.goto_prev, 'Goto previous diagnostic')
helpers.nmap(']e', vim.diagnostic.goto_next, 'Goto next diagnostic')
helpers.nmap('<leader>q', vim.diagnostic.setloclist, 'Place diagnostics in the location list')
helpers.nmap('<leader>e', vim.diagnostic.open_float, 'Open diagnostics float')
helpers.nmap('<Esc>', close_float, 'Close inactive floats')
helpers.nmap('<leader><del>', ':%s/\\s\\+$//e<CR>', 'Remove trailing whitespace')
helpers.nmap('<leader>gl', '^vg_', 'Visual select current line content')
helpers.nmap('<leader>i', ':Inspect<CR>', 'Inspect at cursor')
helpers.nmap('<leader>wv', ':vsplit<CR>', 'Split window vertically')
helpers.nmap('<leader>ws', ':split<CR>', 'Split window horizontally')
helpers.nmap('<leader>wo', ':only<CR>', 'Only show the current window')

helpers.vmap('p', '"_dP', 'Keep clipboard after pasting over a selection')
helpers.vmap('<', '<gv', 'Stay in indent mode after left indent')
helpers.vmap('>', '>gv', 'Stay in indent mode after right indent')

helpers.keymap({ 'v', 'x' }, '<M-j>', ":m '>+1<CR>gv=gv", 'Move selection down')
helpers.keymap({ 'v', 'x' }, '<M-k>', ":m '<-2<CR>gv=gv", 'Move selection up')
helpers.keymap({ 'v', 'x' }, '<leader>s', ':sort<CR>', 'Sort lines')

helpers.keymap({ 'n', 'v' }, '<S-ScrollWheelUp>', '5z<Left>', 'Horizontal scroll left')
helpers.keymap({ 'n', 'v' }, '<S-ScrollWheelDown>', '5z<Right>', 'Horizontal scroll right')

-- vim: ts=2 sts=2 sw=2 et
