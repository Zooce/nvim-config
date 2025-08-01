-- credit to https://www.reddit.com/r/neovim/comments/1335pfc/comment/jiaagyi/?utm_source=share&utm_medium=web2x&context=3
local function close_float()
  local inactive_wins = vim.fn.filter(vim.api.nvim_list_wins(), function(_, v)
    return vim.api.nvim_win_get_config(v).relative ~= ""
      and v ~= vim.api.nvim_get_current_win()
  end)
  for _, win in ipairs(inactive_wins) do
    pcall(vim.api.nvim_win_close, win, false)
  end
end

local function prev()
  vim.diagnostic.jump({ count = -1 })
end
local function next()
  vim.diagnostic.jump({ count = 1 })
end

vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("i", "<Down>", "<C-o>gj", { noremap = true, silent = true });
vim.keymap.set("i", "<Up>", "<C-o>gk", { noremap = true, silent = true });
vim.keymap.set("n", "<M-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("n", "<M-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set("n", "[e", prev, { noremap = true, silent = true, desc = "Goto previous diagnostic" })
vim.keymap.set("n", "]e", next, { noremap = true, silent = true, desc = "Goto next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { noremap = true, silent = true, desc = "Place diagnostics in the location list" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Open diagnostics float" })
vim.keymap.set("n", "<Esc>", close_float, { noremap = true, silent = true, desc = "Close inactive floats" })
vim.keymap.set("n", "<leader><del>", ":%s/\\s\\+$//e<CR>", { noremap = true, silent = true, desc = "Remove trailing whitespace" })
vim.keymap.set("n", "<leader>i", ":Inspect<CR>", { noremap = true, silent = true, desc = "Inspect at cursor" })
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { noremap = true, silent = true, desc = "Split window vertically" })
vim.keymap.set("n", "<leader>ws", ":split<CR>", { noremap = true, silent = true, desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>wo", ":only<CR>", { noremap = true, silent = true, desc = "Only show current window" })
vim.keymap.set("n", "<leader>wq", ":quit<CR>", { noremap = true, silent = true, desc = "Quit current window" })
vim.keymap.set("n", "<leader>w=", ":wincmd =<CR>", { noremap = true, silent = true, desc = "Equal window sizes" })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true, silent = true, desc = "Goto window left" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true, silent = true, desc = "Goto window down" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true, silent = true, desc = "Goto window up" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true, silent = true, desc = "Goto window right" })
vim.keymap.set("n", "<F1>", "q", { noremap = true, silent = true })
vim.keymap.set("n", "q", "<nop>", { noremap = true, silent = true })

-- pasting
vim.keymap.set({ "v", "x" }, "p", function() return vim.fn.col(".") == vim.fn.col("$") - 1 and '"_dp' or '"_dP' end, { expr = true })

vim.keymap.set("v", "<", "<gv", { desc = "Stay in indent mode after left indent", noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Stay in indent mode after right indent", noremap = true, silent = true })

vim.keymap.set("x", "il", "g_o^", { desc = "[i]nside [l]ine", noremap = true, silent = true })
vim.keymap.set("o", "il", ":<C-u>normal vil<CR>", { desc = "[i]nside [l]ine", noremap = true, silent = true })
vim.keymap.set("x", "al", "$o0", { desc = "[a]round [l]ine", noremap = true, silent = true })
vim.keymap.set("o", "al", ":<C-u>normal val", { desc = "[a]round [l]ine", noremap = true, silent = true })

vim.keymap.set({ "v", "x" }, "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down", noremap = true, silent = true })
vim.keymap.set({ "v", "x" }, "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up", noremap = true, silent = true })
vim.keymap.set({ "v", "x" }, "<leader>s", ":sort<CR>", { desc = "Sort lines", noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<space>", "<nop>", { silent = true })
vim.keymap.set({ "n", "v" }, "<S-ScrollWheelUp>", "5z<Left>", { desc = "Horizontal scroll left", noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<S-ScrollWheelDown>", "5z<Right>", { desc = "Horizontal scroll right", noremap = true, silent = true })
