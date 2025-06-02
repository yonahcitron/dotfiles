-- lua/plugins/iron.lua
-- Fully self‑contained Iron + keymap configuration
-- Uses Which‑Key “new spec” indirectly: every mapping is created with a `desc`,
-- so Which‑Key can discover them automatically.  No explicit `which‑key.register()`
-- calls are needed, avoiding deprecated APIs and health‑check warnings.

return {
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      ---------------------------------------------------------------------------
      -- Iron setup -------------------------------------------------------------
      ---------------------------------------------------------------------------
      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = { command = { "zsh" } },
            python = {
              command = { "python3" },
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
            },
          },
          repl_filetype = function(_, ft)
            return ft
          end,
          repl_open_cmd = view.bottom(40),
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      })

      ---------------------------------------------------------------------------
      -- Keymaps (all carry `desc`, so Which‑Key picks them up automatically) ---
      ---------------------------------------------------------------------------
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- Top‑level REPL actions under <space>r
      map("n", "<space>rr", "<cmd>IronRepl<cr>", vim.tbl_extend("force", opts, { desc = "Toggle REPL" }))
      map("n", "<space>rR", "<cmd>IronRestart<cr>", vim.tbl_extend("force", opts, { desc = "Restart REPL" }))
      map("n", "<space>rf", "<cmd>IronFocus<cr>", vim.tbl_extend("force", opts, { desc = "Focus REPL" }))
      map("n", "<space>rh", "<cmd>IronHide<cr>", vim.tbl_extend("force", opts, { desc = "Hide REPL" }))

      -- Send (nested under <space>rs…)
      map("n", "<space>rs<space>", "<cmd>IronInterrupt<cr>", vim.tbl_extend("force", opts, { desc = "Interrupt" }))
      map("n", "<space>rsb", "<cmd>IronSendCodeBlock<cr>", vim.tbl_extend("force", opts, { desc = "Send code block" }))
      map("n", "<space>rsc", "<cmd>IronClear<cr>", vim.tbl_extend("force", opts, { desc = "Clear REPL" }))
      map("n", "<space>rsf", "<cmd>IronSendFile<cr>", vim.tbl_extend("force", opts, { desc = "Send file" }))
      map("n", "<space>rsl", "<cmd>IronSendLine<cr>", vim.tbl_extend("force", opts, { desc = "Send line" }))
      map("n", "<space>rsm", "<cmd>IronMark<cr>", vim.tbl_extend("force", opts, { desc = "Set mark" }))
      map(
        "n",
        "<space>rsn",
        "<cmd>IronSendCodeBlockAndMove<cr>",
        vim.tbl_extend("force", opts, { desc = "Send block & move" })
      )
      map("n", "<space>rsp", "<cmd>IronSendParagraph<cr>", vim.tbl_extend("force", opts, { desc = "Send paragraph" }))
      map("n", "<space>rsq", "<cmd>IronExit<cr>", vim.tbl_extend("force", opts, { desc = "Exit REPL" }))
      map("n", "<space>rss", "<cmd>IronCR<cr>", vim.tbl_extend("force", opts, { desc = "Carriage return" }))
      map(
        "n",
        "<space>rsu",
        "<cmd>IronSendUntilCursor<cr>",
        vim.tbl_extend("force", opts, { desc = "Send until cursor" })
      )

      -- Code‑block navigation under <leader>b
      map(
        "n",
        "<leader>b[",
        "<cmd>lua vim.fn.search('^# %%', 'bW')<CR>",
        vim.tbl_extend("force", opts, { desc = "Previous code block" })
      )
      map(
        "n",
        "<leader>b]",
        "<cmd>lua vim.fn.search('^# %%', 'W')<CR>",
        vim.tbl_extend("force", opts, { desc = "Next code block" })
      )
    end,
  },
}
