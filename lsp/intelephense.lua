-- installed with `bun install -g intelephense`
-- NOTE: I'm actually faking `node` with `exec bun "$@"` which intelephense requires...see `bin` in my dotfiles
return {
    cmd = { "intelephense", "--stdio" },
    filetypes = { "php", "blade" },
    root_markers = {
        "composer.json",
        ".git",
    },
    workspace_required = true,
    before_init = function(_, _)
        vim.notify_once("Starting Intelephense LSP...")
    end,
    on_attach = function(_, _)
        vim.notify_once("Intelephense LSP attached")
    end,
}

