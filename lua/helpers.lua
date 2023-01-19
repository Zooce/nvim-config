local M = {}

M.nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { noremap = true, silent = true, desc = desc })
end
M.vmap = function(keys, func, desc)
  vim.keymap.set('v', keys, func, { noremap = true, silent = true, desc = desc })
end

return M
