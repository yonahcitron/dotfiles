-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

vim.keymap.del("n", ",")
vim.keymap.del("v", ",")
vim.g.maplocalleader = ","
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

-- Toggle LSP diagnostic warnings to stop it cluttering
vim.keymap.set("n", "<leader>dw", function() -- "diagnostic warnings"
  local enable_status = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enable_status)
end, { noremap = true, silent = true, desc = "Toggle LSP virtual text" })

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

vim.keymap.set("n", "<Leader>rr", function()
  require("nvim-python-repl").send_statement_definition()
end, { desc = "Send semantic unit to REPL" })
vim.keymap.set("v", "<Leader>rr", function()
  require("nvim-python-repl").send_visual_to_repl()
end, { desc = "Send visual selection to REPL" })
vim.keymap.set("n", "<Leader>rb", function()
  require("nvim-python-repl").send_buffer_to_repl()
end, { desc = "Send entire buffer to REPL" })
vim.keymap.set("n", "<Leader>rt", function()
  require("nvim-python-repl").toggle_execute()
end, { desc = "Automatically execute command in REPL after sent" })
vim.keymap.set("n", "<Leader>rs", function()
  require("nvim-python-repl").toggle_vertical()
end, { desc = "Create REPL in vertical or horizontal split" })
vim.keymap.set("n", "<Leader>rw", function()
  require("nvim-python-repl").open_repl()
end, { desc = "Opens the REPL in a window split" })

-- Swap `:` and `;` keys to make entering Command Mode easier
-- Also swaps command to repeat the last 'f', 't', 'F' & 'T' command.
-- vim.api.nvim_set_keymap("n", ";", ":", { noremap = true })
-- vim.api.nvim_set_keymap("n", ":", ";", { noremap = true })
