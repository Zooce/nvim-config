-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Custom `:Hitest` command
vim.api.nvim_create_user_command("Hitest", function(_)
  vim.cmd.ru([[syntax/hitest.vim]])
end, { desc = "Run $VIMRUNTIME/syntax/hitest.vim" })
