-- TODO: https://dev.to/je12emy/setting-up-neovim-for-laravel-development-4pii
-- installed `phpactor` with `yay -S phpactor`
return {
    cmd = { "phpactor", "language-server" },
    filetypes = { "php", "blade" },
    root_markers = {
        ".git",
        "composer.json",
        ".phpactor.json",
        ".phpactor.yml",
    },
    workspace_required = true,
    before_init = function(_, _)
        vim.notify_once("Starting PHP Actor LSP...")
    end,
    on_attach = function(_, _)
        vim.notify_once("PHP Actor LSP attached")
    end,
}
