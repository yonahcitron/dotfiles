return {
  "ibhagwan/fzf-lua",
  opts = {
    files = {
      fd_opts = "--color=never --type f --hidden --no-ignore --exclude .git --exclude .cache --exclude .build",
    },
  },
  keys = {
    {
      "<leader>fw",
      function()
        require("custom.fzf-workspaces")()
      end,
    },
  },
}
