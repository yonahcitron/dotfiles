return {
  "benlubas/molten-nvim",
  version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
  build = ":UpdateRemotePlugins",
  init = function()
    vim.g.molten_output_win_max_height = 10000
    vim.g.molten_output_show_more = true
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_text_max_lines = 10000
    vim.g.molten_auto_open_output = false
    vim.keymap.set("n", "<leader>mi", ":MoltenInit<cr>", { desc = "Initialize Molten" })
    vim.keymap.set("n", "<leader>me", ":MoltenEvaluateLine<cr>", { desc = "Evaluate line" })
    vim.keymap.set("v", "<leader>me", ":<C-u>MoltenEvaluateVisual<cr>", { desc = "Evaluate visual" })
    vim.keymap.set("n", "<leader>mc", ":MoltenEvaluateCell<cr>", { desc = "Evaluate cell" })
    vim.keymap.set("n", "<leader>mo", ":noautocmd MoltenEnterOutput<CR>", { desc = "Enter Molten Output" })
  end,
}
