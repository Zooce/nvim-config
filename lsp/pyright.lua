-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/pyright.lua
-- installed `pyright-langserver` with `bun install -g pyright`
return {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
    },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
            },
        },
    },
    on_attach = function(_, _)
        vim.notify("Pyright LSP attached")
    end,
}
