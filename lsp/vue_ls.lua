-- installed with `bun i -g @vue/language-server`
return {
    name = "vue_ls",
    cmd = { "vue-language-server", "--stdio" },
    filetypes = {
        "vue",
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact",
        "typescript.tsx",
        "javascript.jsx",
    },
    root_markers = {
        "package.json",
        ".git",
    },
    init_options = {
        vue = {
            hybridMode = false,
        },
        typescript = {
            tsdk = "node_modules/typescript/lib",
        },
    },
    before_init = function(_, _)
        vim.notify_once("Starting Vue LSP...")
    end,
    on_attach = function(_, _)
        vim.notify_once("Vue LSP attached")
    end,
}
