local M = {}

M.keymap = function(modes, keys, func, desc)
  vim.keymap.set(modes, keys, func, { noremap = true, silent = true, desc = desc })
end
M.nmap = function(keys, func, desc)
  M.keymap('n', keys, func, desc)
end
M.vmap = function(keys, func, desc)
  M.keymap('v', keys, func, desc)
end
M.xmap = function(keys, func, desc)
  M.keymap('x', keys, func, desc)
end
M.omap = function(keys, func, desc)
  M.keymap('o', keys, func, desc)
end

M.dropdown = function(preview)
  return require('telescope.themes').get_dropdown({
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
      prompt = {'─', '│', ' ', '│', '┌', '┐', '│', '│'},
      results = {'─', '│', '─', '│', '├', '┤', '┘', '└'},
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
    },
    previewer = preview,
    layout_config = { width = 0.7, height = 0.6 },
  })
end

return M

-- vim: ts=2 sts=2 sw=2 et
