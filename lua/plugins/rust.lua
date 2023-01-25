return {
    {
        'saecki/crates.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = true,
        event = 'BufRead Cargo.toml',
    },
}

-- vim: ts=2 sts=2 sw=2 et
