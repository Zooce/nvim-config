return {
  {
    'saecki/crates.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = true,
    event = 'BufRead Cargo.toml',
  },
}
