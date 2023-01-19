vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- https://github.com/rust-lang/rust.vim/blob/master/doc/rust.txt
vim.g.rust_recommended_style = 0

local options = {
    -- [[ Context ]]
    cursorline = true, -- highlight the current line
    number = true, -- show line numbers
    relativenumber = true, -- show relative line numbers
    scrolloff = 6, -- always show at least 4 lines around the cursor
    sidescrolloff = 6, -- always show at least 4 characters around the cursor
    signcolumn = 'yes', -- show the sign column (TODO: should this be added to vim.wo ?)

    -- [[ Filetypes ]]
    encoding = 'utf-8', -- string encoding
    fileencoding = 'utf-8', -- file encoding

    -- [[ Theme ]]
    syntax = 'on', -- always enable syntax highlighting
    termguicolors = true, -- enable terminal colors

    -- [[ Search ]]
    ignorecase = true, -- ignore case when searching
    smartcase = true, -- use smart case if search contains captials
    incsearch = true, -- use incremental search
    hlsearch = false, -- only highlight search matches while typing the search term

    -- [[ Whitespace ]]
    expandtab = true, -- use spaces instead of tabs
    shiftwidth = 4, -- use 4 spaces for indentation
    smartindent = true, -- try to indent smartly
    softtabstop = 4, -- use 4 spaces for tabs in INSERT mode
    tabstop = 4, -- use 4 spaces for tabs in general

    -- [[ Splits ]]
    splitright = true, -- place new vertical splits to the right
    splitbelow = true, -- place new horizontal splits below

    -- [[ Copy and Paste ]]
    clipboard = 'unnamedplus', -- paste from the system clipboard

    -- [[ Autocomplete Menus ]]
    -- show completions menus even when there's only one option
    -- don't automatically select or insert completion menu options
    completeopt = 'menuone,noinsert,noselect',

    -- [[ Others ]]
    hidden = true, -- allow hidden buffers (helpful for some plugins)
    showmode = false, -- don't show the mode
    timeoutlen = 250, -- time before mapped key sequences fire
    updatetime = 250, -- shorten the time to show pop-ups under the cursor
    wrap = false, -- don't wrap text
    textwidth = 0, -- don't auto linebreak while typing
    mouse = 'a', -- allow the mouse in any mode

    -- [[ Backups - see `:help backup` ]]
    backup = false,
    writebackup = false,
}

vim.opt.shortmess:append 'c' -- don't show `ins-completion-menu` messages

for k, v in pairs(options) do
    vim.o[k] = v
end
