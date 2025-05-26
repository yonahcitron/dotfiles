return {
  "folke/noice.nvim",
  opts = {
    views = {
      notify = {
        render = "wrapped-default",
        size = {
          max_width = 120,
          max_height = function()
            return math.floor(vim.o.lines * 0.50)
          end,
        },
      },
    },
  },
}
