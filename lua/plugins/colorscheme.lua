return {
  -- my custom colorscheme
  { "Zooce/indomitable.nvim" },

  -- tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "indomitable",
    },
  },
}
