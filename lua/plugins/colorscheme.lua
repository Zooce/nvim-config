return {
  -- get indomitable.nvim
  -- TODO: make this compatible with switching themes on Omarchy
  { "Zooce/indomitable.nvim" },

  -- override LazyVim colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "indomitable",
    },
  },
}
