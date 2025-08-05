-- ================================================================================
-- OPTIONS
-- ================================================================================

-- cursor
vim.opt.cursorline = true -- highlight the current line
vim.opt.cursorcolumn = true -- highlight the current column

-- gutter
vim.opt.signcolumn = "yes"

-- files and buffers
vim.opt.fileencoding = "utf-8"
vim.opt.wrap = false -- override with language-specific auto-commands)
vim.opt.list = true  -- show tabs and trailing spaces
vim.opt.listchars = { tab = "> ", trail = "·" }
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- theme
vim.opt.termguicolors = true

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.path:append("**") -- search in sub-directories

-- whitespace (override with language-specific auto-commands)
vim.opt.expandtab = true -- spaces instead of tabs
vim.opt.shiftwidth = 4 -- 4 spaces by default
vim.opt.softtabstop = 4 -- 4 spaces by default for <TAB> in INSERT mode
vim.opt.tabstop = 4 -- ...just keep them all the same
vim.opt.smartindent = true

-- splits
vim.opt.splitright = true -- make vertical splits to the right
vim.opt.splitbelow = true -- make horizontal splits to the bottom

-- mouse
vim.opt.mouse = "a" -- enable mouse in all modes

-- auto-complete
-- show completion menu even when there's only one option
-- don't auto-select or insert any option
vim.opt.completeopt = "menuone,noselect"
-- vim.opt.updatetime = 300 -- faster auto-complete popup (I think ?? check back later)
vim.opt.shortmess:append("c") -- don't show useless `ins-completion-menu` messages

-- keymaps
vim.opt.timeoutlen = 4000 -- give me more time to type my keymaps

-- clipboard
vim.opt.clipboard = "unnamedplus" -- use system clipboard

-- status line
vim.opt.laststatus = 3 -- one global status line TO RULE THEM ALL

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ================================================================================
-- KEYMAPS
-- ================================================================================

-- navigation
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set("n", "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("i", "<Down>", "<C-o>gj")
vim.keymap.set("i", "<Up>", "<C-o>gk")
vim.keymap.set("n", "<C-j>", "5j5<C-e>")
vim.keymap.set("n", "<C-k>", "5k5<C-y>")

-- windows and buffers
vim.keymap.set("n", "<Leader>wv", ":vsplit<CR>")
vim.keymap.set("n", "<Leader>ws", ":split<CR>")
vim.keymap.set("n", "<Leader>wo", ":only<CR>")
vim.keymap.set("n", "<Leader>wq", ":quit<CR>")
vim.keymap.set("n", "<Leader>w=", ":wincmd =<CR>")
vim.keymap.set("n", "<Leader>wh", "<C-w>h")
vim.keymap.set("n", "<Leader>wj", "<C-w>j")
vim.keymap.set("n", "<Leader>wk", "<C-w>k")
vim.keymap.set("n", "<Leader>wl", "<C-w>l")
-- credit: https://github.com/folke/snacks.nvim/blob/bc0630e43be5699bb94dadc302c0d21615421d93/lua/snacks/bufdelete.lua
local function bufdel()
    local buf = vim.api.nvim_get_current_buf()
    -- try to save if there are modifications
    if vim.bo.modified then
        local ok, choice = pcall(vim.fn.confirm, ("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
        if not ok or choice == 0 or choice == 3 then -- 0 for <Esc>/<C-c> and 3 for Cancel
            return
        end
        if choice == 1 then
            vim.cmd.write()
        end
    end
    -- load up the "previous" buffer before deleting the current buffer
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.api.nvim_win_call(win, function()
            if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
                return
            end
            -- try alternate buffer first
            local alt = vim.fn.bufnr("#")
            if alt ~= buf and vim.fn.buflisted(alt) == 1 then
                vim.api.nvim_win_set_buf(win, alt)
                return
            end
            -- try previous buffer next
            local has_prev = pcall(vim.cmd, "bprevious")
            if has_prev and buf ~= vim.api.nvim_win_get_buf(win) then
                return
            end
            -- no buffers, so create a new one
            local new_buf = vim.api.nvim_create_buf(true, false)
            vim.api.nvim_win_set_buf(win, new_buf)
        end)
    end
    if vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.cmd, "bdelete! " .. buf)
    end
end
vim.keymap.set("n", "<Leader>bd", bufdel)

-- macros
vim.keymap.set("n", "<F1>", "q")
vim.keymap.set("n", "q", "<Nop>")

-- paste
local function smartpaste()
    return vim.fn.col(".") == vim.fn.col("$") - 1 and '"_dp' or '"_dP'
end
vim.keymap.set({ "v", "x" }, "p", smartpaste, { expr = true })

-- indenting
-- stay in VISUAL mode and keep the selection when indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- selections
vim.keymap.set("x", "il", "g_o^") -- `vil` = select inside line
vim.keymap.set("o", "il", ":<C-u>normal vil<CR>") -- "inside line" for operators, e.g, `dil` = delete inside line
vim.keymap.set({ "v", "x" }, "<Leader>s", ":sort<CR>") -- sort selected lines

-- mouse scrolling
vim.keymap.set({ "n", "v" }, "<S-ScrollWheelUp>", "5z<Left>")
vim.keymap.set({ "n", "v" }, "<S-ScrollWheelDown>", "5z<Right>")

-- auto-complete
vim.keymap.set("c", "<Up>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<Up>"
end, { expr = true })
vim.keymap.set("c", "<Down>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<Down>"
end, { expr = true })
vim.keymap.set("c", "<Right>", function()
    return vim.fn.pumvisible() == 1 and "<C-y>" or "<Right>"
end, { expr = true })
vim.keymap.set("c", "<Left>", function()
    return vim.fn.pumvisible() == 1 and "<C-e>" or "<Left>"
end, { expr = true })
-- vim.keymap.srue })

-- terminal
local term_win = nil
local term_buf = nil
-- NOTE it can't be `local` since we're setting up a keybinding to call itself
function toggle_term()
    -- if we've already got a terminal window open....fucking hide it NOW
    if term_win and vim.api.nvim_win_is_valid(term_win) then
        vim.api.nvim_win_hide(term_win)
        term_win = nil
        return
    end
    -- no terminal window open so let's open one
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        style = "minimal",
        border = "single",
    }
    if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
        term_buf = vim.api.nvim_create_buf(false, true)
        term_win = vim.api.nvim_open_win(term_buf, true, win_opts)
        vim.fn.termopen(vim.o.shell)
    else
        term_win = vim.api.nvim_open_win(term_buf, true, win_opts)
    end
    vim.cmd("startinsert")
    vim.api.nvim_buf_set_keymap(term_buf, "t", "<C-\\>", "<Cmd>lua toggle_term()<CR>", {})
    -- in case we leave the terminal buffer some other way, then auto-close that bitch
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = term_buf,
        callback = function()
            if term_win and vim.api.nvim_win_is_valid(term_win) then
                vim.api.nvim_win_hide(term_win)
                term_win = nil
            end
        end,
        once = true,
    })
end
vim.keymap.set("n", "<C-\\>", toggle_term)

-- trim trailing whitespace
vim.keymap.set("n", "<Leader><Del>", ":%s/\\s\\+$//e<CR>")

-- close inactive floats (like LSP hover docs)
local function close_float()
    local inactive_wins = vim.fn.filter(
        vim.api.nvim_list_wins(),
        function(_, w)
            return vim.api.nvim_win_get_config(w).relative ~= ""
                and w ~= vim.api.nvim_get_current_win()
        end
    )
    for _, win in ipairs(inactive_wins) do
        pcall(vim.api.nvim_win_close, win, false)
    end
end
vim.keymap.set("n", "<Esc>", close_float)

-- finder
local finder = require("finder")
vim.keymap.set("n", "<Leader>/f", function() finder.open("files") end)
vim.keymap.set("n", "<Leader>/g", function() finder.open("grep") end)

-- lsp
vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "single" }) end)
vim.keymap.set("n", "]e", function() vim.diagnostic.jump({ count = 1 }) end)
vim.keymap.set("n", "[e", function() vim.diagnostic.jump({ count = -1 }) end)
vim.keymap.set("n", "<leader>e", function() vim.diagnostic.open_float({ border = "single" }) end)

-- ================================================================================
-- AUTO COMMANDS
-- ================================================================================

-- highlight yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- ================================================================================
-- LSP
-- ================================================================================

local servers = {
    "luals",
    "zls",
}
vim.lsp.enable(servers)
