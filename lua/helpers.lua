local M = {}

M.keymap = function(modes, keys, func, desc)
  vim.keymap.set(modes, keys, func, { noremap = true, silent = true, desc = desc })
end
M.nmap = function(keys, func, desc)
  M.keymap('n', keys, func, { noremap = true, silent = true, desc = desc })
end
M.vmap = function(keys, func, desc)
  M.keymap('v', keys, func, { noremap = true, silent = true, desc = desc })
end
M.xmap = function(keys, func, desc)
  M.keymap('x', keys, func, { noremap = true, silent = true, desc = desc })
end

return M

-- vim: ts=2 sts=2 sw=2 et
