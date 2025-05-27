-- Add some which-key hints for my custom high level-defeaults.
-- The 'o' one provides handy shortcuts to open single files.
return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    -- make sure spec is an array
    opts.spec = opts.spec or {}

    -- 1) add the top-level group for <leader>o
    table.insert(opts.spec, { "<leader>o", group = "Open File" })

    -- 2) add your actual mapping under that prefix
    table.insert(opts.spec, {
      "<leader>ot",
      "<cmd>edit ~/repos/vault/todo.md<CR>",
      desc = "Main todo.md in Obsidian Vault",
    })
  end,
}
