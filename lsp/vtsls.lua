return {
    name = "vtsls",
    cmd = { "vtsls", "--stdio" },
    init_options = {
        hostInfo = "neovim",
    },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
    },
    root_markers = {
        "package-lock.json",
        "yarn.lock",
        "pnpm-lock.yaml",
        "bun.lockb",
        "bun.lock",
        ".git",
    },
    settings = {
        vtsls = {
            autoUseWorkspaceTsdk = true,
            tsserver = {
                globalPlugins = {
                    name = "@vue/typescript-plugin",
                    enableForWorkspaceTypeScriptVersions = true,
                    -- if installed globally, add `location`
                },
                -- name = "@vue/typescript-plugin",
                -- location = vim.fn.exepath("vue-language-server"),
                -- languages = { "vue" },
                -- configNamespace = "typescript",
            },
        },
    },
    before_init = function(_, _)
        vim.notify_once("Starting VTLS LSP...")
    end,
    on_attach = function(_, _)
        vim.notify_once("VTLS LSP attached")
    end,
}
