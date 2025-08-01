local helpers = require "helpers"

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
helpers.nmap("<M-j>", ":m .+1<CR>==", "Move line down")
helpers.nmap("<M-k>", ":m .-2<CR>==", "Move line up")
helpers.nmap("[e", prev, "Goto previous diagnostic")
helpers.nmap("]e", next, "Goto next diagnostic")
helpers.nmap("<leader>q", vim.diagnostic.setloclist, "Place diagnostics in the location list")
helpers.nmap("<leader>e", vim.diagnostic.open_float, "Open diagnostics float")
helpers.nmap("<Esc>", close_float, "Close inactive floats")
helpers.nmap("<leader><del>", ":%s/\\s\\+$//e<CR>", "Remove trailing whitespace")
helpers.nmap("<leader>i", ":Inspect<CR>", "Inspect at cursor")
helpers.nmap("<leader>wv", ":vsplit<CR>", "Split window vertically")
helpers.nmap("<leader>ws", ":split<CR>", "Split window horizontally")
helpers.nmap("<leader>wo", ":only<CR>", "Only show current window")
helpers.nmap("<leader>wq", ":quit<CR>", "Quit current window")
helpers.nmap("<leader>w=", ":wincmd =<CR>", "Equal window sizes")
vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true, silent = true, desc = "Goto window left" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true, silent = true, desc = "Goto window down" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true, silent = true, desc = "Goto window up" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true, silent = true, desc = "Goto window right" })
helpers.nmap("<F1>", "q")
helpers.nmap("q", "<nop>")

helpers.vmap("p", '"_dP', "Keep clipboard after pasting over a selection")
vim.keymap.set("x", "p", function() return vim.fn.col(".") == vim.fn.col("$") - 1 and '"_dp' or '"_dP' end, { expr = true })
helpers.vmap("<", "<gv", "Stay in indent mode after left indent")
helpers.vmap(">", ">gv", "Stay in indent mode after right indent")

helpers.xmap("il", "g_o^", "[i]nside [l]ine")
helpers.omap("il", ":<C-u>normal vil<CR>", "[i]nside [l]ine")
helpers.xmap("al", "$o0", "[a]round [l]ine")
helpers.omap("al", ":<C-u>normal val", "[a]round [l]ine")

helpers.keymap({ "v", "x" }, "<M-j>", ":m '>+1<CR>gv=gv", "Move selection down")
helpers.keymap({ "v", "x" }, "<M-k>", ":m '<-2<CR>gv=gv", "Move selection up")
helpers.keymap({ "v", "x" }, "<leader>s", ":sort<CR>", "Sort lines")

vim.keymap.set({ "n", "v" }, "<space>", "<nop>", { silent = true })
helpers.keymap({ "n", "v" }, "<S-ScrollWheelUp>", "5z<Left>", "Horizontal scroll left")
helpers.keymap({ "n", "v" }, "<S-ScrollWheelDown>", "5z<Right>", "Horizontal scroll right")
