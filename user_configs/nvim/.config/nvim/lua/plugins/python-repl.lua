return {
  "geg2102/nvim-python-repl",
  dependencies = "nvim-treesitter",
  ft = { "python", "lua", "scala" },
  config = function()
    -- Call the setup, passing opts to it.
    require("nvim-python-repl").setup({
      execute_on_send = false,
      vsplit = true,
    })

    -- Set custom keybindings.
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
    -- vim.keymap.set("n", "<Leader>rs", function()
    --   require("nvim-python-repl").toggle_vertical()
    -- end, { desc = "Create REPL in vertical or horizontal split" })
    vim.keymap.set("n", "<Leader>rw", function()
      require("nvim-python-repl").open_repl()
    end, { desc = "Opens the REPL in a window split" })
    vim.keymap.set("n", "<Leader>rd", function() -- 'databricks'
      -- Go to line 3
      vim.api.nvim_win_set_cursor(0, { 4, 0 })
      -- Start visual mode
      vim.cmd("normal! V")
      -- Go to the last line
      vim.cmd("normal! G")
      -- Send visual selection to REPL
      require("nvim-python-repl").send_visual_to_repl()
      -- Exit visual mode properly
      vim.cmd("normal! \\<Esc>")
    end, { desc = "Databricks notebook: send all, minus header" })

    vim.keymap.set("n", "<Leader>rc", function() -- 'run cell'
      local bufnr = vim.api.nvim_get_current_buf()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local cur_line = cursor[1]
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

      -- Find previous marker
      local start_line = 1
      for i = cur_line - 1, 1, -1 do
        if lines[i]:match("^# COMMAND %-+$") then
          start_line = i + 1
          break
        end
      end

      -- Find next marker
      local end_line = #lines
      for i = cur_line + 1, #lines do
        if lines[i]:match("^# COMMAND %-+$") then
          end_line = i - 1
          break
        end
      end

      -- Visually select the range
      vim.api.nvim_win_set_cursor(0, { start_line, 0 })
      vim.cmd("normal! V")
      vim.api.nvim_win_set_cursor(0, { end_line, 0 })

      -- Send visual selection to REPL
      require("nvim-python-repl").send_visual_to_repl()
      -- Exit visual mode properly and restore cursor position
      vim.cmd("normal! \\<Esc>")
      vim.api.nvim_win_set_cursor(0, cursor)
    end, { desc = "Send section between # COMMAND ---------- markers to REPL" })
  end,

  vim.keymap.set("n", "<Leader>rn", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cur_line = cursor[1]
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Find previous marker
    local start_line = 1
    for i = cur_line - 1, 1, -1 do
      if lines[i]:match("^# COMMAND %-+$") then
        start_line = i + 1
        break
      end
    end

    -- Find next marker
    local end_line = #lines
    local next_marker = nil
    for i = cur_line + 1, #lines do
      if lines[i]:match("^# COMMAND %-+$") then
        end_line = i - 1
        next_marker = i
        break
      end
    end

    -- Visually select the range
    vim.api.nvim_win_set_cursor(0, { start_line, 0 })
    vim.cmd("normal! V")
    vim.api.nvim_win_set_cursor(0, { end_line, 0 })

    -- Send visual selection to REPL
    require("nvim-python-repl").send_visual_to_repl()
    -- Exit visual mode properly
    vim.cmd("normal! \\<Esc>")

    -- Move cursor to line after next marker (if exists)
    if next_marker and next_marker < #lines then
      vim.api.nvim_win_set_cursor(0, { next_marker + 1, 0 })
    end
  end, { desc = "Send cell and move to next cell" }),
}
