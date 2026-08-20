return {
  -- Configure LazyVim to use catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },

  -- Add your catppuccin config
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      -- Your catppuccin options go here
      flavour = "mocha", -- Options: latte, frappe, macchiato, mocha
    },
  },
}
