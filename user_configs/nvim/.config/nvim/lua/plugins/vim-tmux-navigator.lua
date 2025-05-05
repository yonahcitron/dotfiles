-- File: ~/.config/nvim/lua/plugins/tmux-navigator.lua
return {
  "christoomey/vim-tmux-navigator",
  event = "VeryLazy",
  config = function()
    vim.g.tmux_navigator_no_mappings = 1

    local map = vim.keymap.set
    map("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", { silent = true })
    map("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", { silent = true })
    map("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", { silent = true })
    map("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", { silent = true })
    map("n", "<C-\\>", "<Cmd>TmuxNavigatePrevious<CR>", { silent = true })
  end,
}
