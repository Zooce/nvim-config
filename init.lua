-- [[ Bootstrap lazy.nvim ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
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
  ui = { border = 'single' },
  -- TODO: consider disabling some rtp plugins (see https://github.com/LazyVim/starter/blob/main/lua/config/lazy.lua)
})
