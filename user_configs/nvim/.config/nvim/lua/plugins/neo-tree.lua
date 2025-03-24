return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false, -- ✅ Show gitignored files
      },
    },
    window = {
      width = 25,
    },
  },
}
