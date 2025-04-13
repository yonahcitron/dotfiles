-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.wo.relativenumber = false
vim.opt.wrap = true

-- Resize windows with Ctrl + Alt + h/j/k/l
vim.keymap.set("n", "<C-M-h>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-M-l>", ":vertical resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-M-j>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-M-k>", ":resize -2<CR>", { noremap = true, silent = true })
