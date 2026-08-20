return {
  -- Override the default neo-tree config
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      -- Add your custom options here
      window = {
        position = "left",
      },
      -- Keep your default mapping (enabled below)
    },
    keys = {
      -- Remove the default neo-tree mappings that LazyVim sets
      { "<leader>fe", false },
      { "<leader>fE", false },
      { "<leader>e", false },
      { "<leader>E", false },

      -- Add your custom keymappings
      { "<leader>n", "<cmd>Neotree filesystem reveal left<cr>", desc = "Open file explorer" },
      { "<leader>c", "<cmd>Neotree close<cr>", desc = "Close file explorer" },
    },
  },
}
