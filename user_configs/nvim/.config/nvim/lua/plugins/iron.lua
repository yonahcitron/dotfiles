return {
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      ---------------------------------------------------------------------------
      -- 1) iron.nvim setup ------------------------------------------------------
      ---------------------------------------------------------------------------
      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = { command = { "zsh" } },
            python = {
              command = { "ipython", "--simple-prompt", "--no-autoindent" },
              format = common.bracketed_paste, -- Default is "bracketed_paste_python". See https://github.com/Vigemus/iron.nvim/issues/378
              block_dividers = { "# %%", "#%%", "# COMMAND ----------" },
            },
          },
          repl_filetype = function(_, ft)
            return ft
          end,
          repl_open_cmd = view.right(60),
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      })

      ---------------------------------------------------------------------------
      -- 2) Keymaps --------------------------------------------------------------
      ---------------------------------------------------------------------------
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- ── Top‐level REPL controls under <space>r ───────────────────────────────
      -- Toggle REPL open/close (IronRepl Ex‐command)
      map("n", "<space>rr", "<cmd>IronRepl<cr>", vim.tbl_extend("force", opts, { desc = "Toggle REPL (IronRepl)" }))
      -- Restart the REPL
      map(
        "n",
        "<space>rR",
        "<cmd>IronRestart<cr>",
        vim.tbl_extend("force", opts, { desc = "Restart REPL (IronRestart)" })
      )
      -- Focus the REPL window
      map("n", "<space>rf", "<cmd>IronFocus<cr>", { desc = "Focus REPL (IronFocus)" })
      vim.tbl_extend("force", opts, { desc = "Focus REPL " })
      -- Hide/close the REPL (Ex‐command :IronHide)
      map("n", "<space>rh", "<cmd>IronHide<cr>", vim.tbl_extend("force", opts, { desc = "Hide REPL " }))

      -- ── Send/Interrupt mappings under <space>rs… ─────────────────────────────
      -- Interrupt REPL
      map("n", "<space>rs<space>", function()
        iron.interrupt_repl()
      end, vim.tbl_extend("force", opts, { desc = "Interrupt REPL " }))
      -- Send current code block
      map("n", "<space>rsb", function()
        iron.send_code_block()
      end, vim.tbl_extend("force", opts, { desc = "Send code block " }))
      -- Clear the REPL buffer
      map("n", "<space>rsc", function()
        iron.clear_repl()
      end, vim.tbl_extend("force", opts, { desc = "Clear REPL " }))
      -- Send entire file
      map("n", "<space>rsf", function()
        iron.send_file()
      end, vim.tbl_extend("force", opts, { desc = "Send entire file " }))
      -- Send current line
      map("n", "<space>rsl", function()
        iron.send_line()
      end, vim.tbl_extend("force", opts, { desc = "Send line " }))
      -- Set a mark for a region (for use by send_until_cursor, etc.)
      map("n", "<space>rsm", function()
        iron.mark()
      end, vim.tbl_extend("force", opts, { desc = "Set mark (mark)" }))
      -- Send code block and move the cursor to the next block
      map("n", "<space>rsn", function()
        iron.send_code_block_and_move()
      end, vim.tbl_extend("force", opts, { desc = "Send block & move " }))
      -- Send the current paragraph
      map("n", "<space>rsp", function()
        iron.send_paragraph()
      end, vim.tbl_extend("force", opts, { desc = "Send paragraph " }))
      -- Exit REPL
      map("n", "<space>rsq", function()
        iron.exit_repl()
      end, vim.tbl_extend("force", opts, { desc = "Exit REPL " }))
      -- Carriage return in the REPL
      map("n", "<space>rss", function()
        iron.cr()
      end, vim.tbl_extend("force", opts, { desc = "Carriage return (cr)" }))
      -- Send everything from mark to cursor
      map("n", "<space>rsu", function()
        iron.send_until_cursor()
      end, vim.tbl_extend("force", opts, { desc = "Send until cursor " }))

      -- ── Code‐block navigation under <leader>b ────────────────────────────────
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
