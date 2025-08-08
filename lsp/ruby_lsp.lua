return {
    name = "ruby_lsp",
    cmd = { "ruby-lsp" },
    filetypes = { "ruby", "eruby" },
    root_markers = { "Gemfile", ".git" },
    before_init = function(_, _)
        vim.notify_once("Starting Ruby LSP...")
    end,
    on_attach = function(_, _)
        vim.notify_once("Ruby LSP attached")
    end,
}
