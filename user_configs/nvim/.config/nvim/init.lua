require("config.lazy") -- loading this file bootstraps lazy.nvim, LazyVim and my plugins they manage
vim.wo.relativenumber = false
vim.opt.wrap = true

-- Get into terminal normal mode just by hitting esc
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })
