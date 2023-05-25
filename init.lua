-- [[ Bootstrap lazy.nvim ]]
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('config.options')
require('config.keymaps')
require('config.autocmds')

vim.diagnostic.config({
  virtual_text = false,
  float = {
    border = 'rounded',
  }
})

-- [[ Start lazy.nvim ]]
require('lazy').setup({
  spec = {
    { import = 'plugins' }, -- load all plugin modules from `lua/plugins'
  },
  checker = {
    enabled = true, -- automatically check for plugin updates
    notify = false, -- no need to notify
  },
  change_detection = { enabled = false },
  -- TODO: consider disabling some rtp plugins (see https://github.com/LazyVim/starter/blob/main/lua/config/lazy.lua)
})

-- vim: ts=2 sts=2 sw=2 et
