return {
    name = "omnisharp",
    cmd = {
        "OmniSharp",
        "-z",
        "-hpid", tostring(vim.fn.getpid()),
        "-e", "utf-8",
        "-lsp",
    },
    filetypes = { "cs", "vb" },
    root_markers = {
        "*.sln",
        "*.csproj",
        ".git",
    },
    settings = {
        FormattingOptions = {
            EnableEditorConfigSupport = true,
        },
    },
    before_init = function(_, _)
        vim.notify_once("Starting OmniSharp LSP...")
    end,
    on_attach = function(_, _)
        vim.notify_once("OmniSharp LSP attached")
    end,
}
