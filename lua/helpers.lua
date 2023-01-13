local helpers = {}

helpers.nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { noremap = true, silent = true, desc = desc })
end
helpers.vmap = function(keys, func, desc)
  vim.keymap.set('v', keys, func, { noremap = true, silent = true, desc = desc })
end

return helpers
