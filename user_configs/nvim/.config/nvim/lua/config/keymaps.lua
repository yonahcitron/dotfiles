-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

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

-- Shortcut to resize windows horizontally
local resize_step = 8 -- The number of columns to resize by each time
vim.keymap.set("n", "<C-A-l>", function()
  vim.cmd("vertical resize +" .. resize_step)
end, { desc = "Increase window width" })
vim.keymap.set("n", "<C-A-h>", function()
  vim.cmd("vertical resize -" .. resize_step)
end, { desc = "Decrease window width" })

-- Toggle LSP diagnostic warnings to stop it cluttering
-- vim.keymap.set("n", "<leader>dw", function() -- "diagnostic warnings"
--   local enable_status = vim.diagnostic.is_enabled()
--   vim.diagnostic.enable(not enable_status)
-- end, { noremap = true, silent = true, desc = "Toggle LSP virtual text" })

-- TODO: Move all these plugin-specific stuff into those plugins' own respective plugin config files, within the setup function...
--        I think this file should be for global / neovim related keymaps...

-- App-specfic keymaps
-- TODO: Move these soon to their respective plugin config files!!

-- Grug-Far
-- TODO: Double check this doesn't already exist within the default plugin! Seems weird if it doesn't!
vim.keymap.set("n", "<leader>sf", function() -- "search file"
  require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "grug-far: Search just current file" })

-- Zenmode
vim.keymap.set("n", "<Leader>z", "<cmd>ZenMode<cr>", {
  noremap = true,
  silent = true,
  desc = "Toggle Zen Mode",
})

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
