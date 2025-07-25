-- vim.g.maplocalleader = "," -- This NEEDS to be loaded BEFORE lazy.
require("config.lazy") -- loading this file bootstraps lazy.nvim, LazyVim and my plugins they manage
-- vim.wo.relativenumber = false -- This would have to be loaded later on to work... I think tokyonight is what triggers it on again

vim.opt.termguicolors = true
vim.opt.wrap = true

vim.g.python3_host_prod = "/Users/Yonah.Citron/.pyenv/shims/python"

-- Get into terminal normal mode just by hitting esc
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

-- Automatically reload files when they change on disk - needed for things like gemini cli to be able to apply changes to the buffer in real time
vim.o.autoread = true

-- By default, have annoying warnings off. Can toggle with the keymap in keymap.
vim.diagnostic.enable(false)

-- Trigger checktime on focus gained and buffer enter
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "checktime",
})

-- Add shortcut to close all buffers without exiting nvim, not built-in to lazyvim annoyingly
vim.keymap.set("n", "<leader>ba", "<cmd>bufdo Bdelete<CR>", { desc = "Close All [B]uffers" })
