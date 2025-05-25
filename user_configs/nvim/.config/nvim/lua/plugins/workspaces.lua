-- I've configured workspaces.nvim to auto-save per workspace if it detect the relevant marker file, see hooks.

return {
  "natecraddock/workspaces.nvim",
  opts = {
    hooks = {
      open = {
        function()
          vim.notify("workspace opened!!!")
        end,
      },
    },
  },
}
