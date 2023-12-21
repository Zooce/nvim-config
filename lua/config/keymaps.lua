-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- credit to https://www.reddit.com/r/neovim/comments/1335pfc/comment/jiaagyi/?utm_source=share&utm_medium=web2x&context=3
local function close_float()
  local inactive_wins = vim.fn.filter(vim.api.nvim_list_wins(), function(_, v)
    return vim.api.nvim_win_get_config(v).relative ~= "" and v ~= vim.api.nvim_get_current_win()
  end)
  for _, win in ipairs(inactive_wins) do
    pcall(vim.api.nvim_win_close, win, false)
  end
end
vim.keymap.set({ "n" }, "<Esc>", close_float, { noremap = true, silent = true, desc = "Close inactive floats" })
