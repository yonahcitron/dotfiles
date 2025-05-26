-- Add some which-key hints for my custom high level-defeaults.
-- The 'o' one provides handy shortcuts to open single files.
return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    -- add a group label for <leader>o
    opts.defaults["<leader>o"] = { name = "Open File" }
  end,
}
