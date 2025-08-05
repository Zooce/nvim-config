return {
    name = "zls",
    cmd = { "zls" },
    filetypes = { "zig" },
    root_markers = {
        "build.zig",
        ".git",
    },
    -- Further information on how to configure ZLS:
    -- https://zigtools.org/zls/configure/
    settings = {
        zls = {
            -- Whether to enable build-on-save diagnostics
            --
            -- Further information about build-on save:
            -- https://zigtools.org/zls/guides/build-on-save/
            -- enable_build_on_save = true,

            -- Neovim already provides basic syntax highlighting
            semantic_tokens = "partial",
        }
    },
    on_attach = function(_, _)
        vim.notify("ZLS LSP attached")
    end,
}
