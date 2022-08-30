-- [[ opts.lua ]]

local options = {
    -- [[ Context ]]
    colorcolumn = '80',     -- ruler
    cursorline = true,      -- highlight the current line
    number = true,          -- show line numbers
    numberwidth = 5,        -- gutter size
    relativenumber = true,  -- show relative line numbers
    scrolloff = 4,          -- always show at least 4 lines around the cursor
    sidescrolloff = 4,      -- always show at least 4 characters around the cursor
    signcolumn = 'yes',     -- show the sign column
    --showtabline = 2,        -- always show the tab bar

    -- [[ Filetypes ]]
    encoding = 'utf-8',      -- string encoding
    fileencoding = 'utf-8',  -- file encoding

    -- [[ Theme ]]
    syntax = 'on',          -- always enable syntax highlighting
    termguicolors = true,   -- enable terminal colors

    -- [[ Search ]]
    ignorecase = true,      -- ignore case when searching
    smartcase = true,       -- use smart case if search contains captials
    incsearch = true,       -- use incremental search
    hlsearch = false,       -- only highlight search matches while typing the search term
    wildmenu = true,        -- enable command line completion

    -- [[ Whitespace ]]
    expandtab = true,       -- use spaces instead of tabs
    shiftwidth = 4,         -- use 4 spaces for indentation
    smartindent = true,     -- try to indent smartly
    softtabstop = 4,        -- use 4 spaces for tabs in INSERT mode
    tabstop = 4,            -- use 4 spaces for tabs in general

    -- [[ Splits ]]
    splitright = true,      -- place new vertical splits to the right
    splitbelow = true,      -- place new horizontal splits below

    -- [[ Copy and Paste ]]
    clipboard = 'unnamedplus',  -- paste from the system clipboard

    -- [[ Backups ]]
    backup = false,
    hidden = true,
    writebackup = false,

    -- [[ Others ]]
    cmdheight = 2,          -- give more space in the command line
    showmode = false,       -- don't show the mode
    timeoutlen = 300,       -- time before mapped key sequences fire  
    updatetime = 300,       -- shorten the time to show pop-ups under the cursor
    wrap = false,           -- don't wrap text
}


--vim.opt.path:append '**'
vim.opt.shortmess:append 'c'


for k, v in pairs(options) do
    vim.opt[k] = v
end

