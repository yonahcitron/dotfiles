return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    -- Only keep the useful sources
    opts.sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" }, -- Optional: for snippet completion
      { name = "path" }, -- For file path suggestions
      -- { name = "buffer" },     -- 👈 Disabled: too noisy
    }
  end,
}
