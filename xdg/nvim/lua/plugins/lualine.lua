return {
  -- Override lualine to use your preferred theme
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "dracula",
      },
    },
  },
}
