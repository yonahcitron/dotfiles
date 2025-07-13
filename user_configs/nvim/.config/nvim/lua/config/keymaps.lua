-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- Remap key to enter Normal Mode

vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "kj", "<Esc>", { noremap = true, silent = true })

-- Disable default mappings
vim.g.tmux_navigator_no_mappings = 1

-- Normal-mode pane navigation
vim.keymap.set("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", { silent = true })
vim.keymap.set("n", "<C-\\>", "<Cmd>TmuxNavigatePrevious<CR>", { silent = true })

-- CodeCompanion
vim.keymap.set({ "n", "v" }, "<Leader>cd", "<cmd>CodeCompanionActions<cr>", { -- "Codecompanion Do"
  noremap = true,
  silent = true,
  desc = "Code Companion: Show actions",
})

vim.keymap.set({ "n", "v" }, "<Leader>a", "<cmd>CodeCompanionChat Toggle<cr>", {
  noremap = true,
  silent = true,
  desc = "Code Companion: Toggle chat",
})

vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", {
  noremap = true,
  silent = true,
  desc = "Code Companion: Add to chat",
})
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

-- Swap `:` and `;` keys to make entering Command Mode easier
-- Also swaps command to repeat the last 'f', 't', 'F' & 'T' command.
-- vim.api.nvim_set_keymap("n", ";", ":", { noremap = true })
-- vim.api.nvim_set_keymap("n", ":", ";", { noremap = true })
