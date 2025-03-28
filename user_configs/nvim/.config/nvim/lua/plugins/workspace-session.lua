return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    options = { "buffers", "curdir", "tabpages", "winsize" }, -- what to save
  },
  config = function(_, opts)
    require("persistence").setup(opts)

    -- Auto-load session on startup if no arguments passed
    if vim.fn.argc() == 0 then
      require("persistence").load()
    end
  end,
}
