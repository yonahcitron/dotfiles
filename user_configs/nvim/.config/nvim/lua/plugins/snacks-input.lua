-- Taken from here, maybe look around at some of his other configs for inspo: https://github.com/lucobellic/nvim-config/blob/main/lua/plugins/snacks/snacks-input.lua

---@module 'snacks.input'

return {
  "folke/snacks.nvim",
  opts = {
    ---@type table<string, snacks.win.Config>
    styles = {
      cursor_input = {
        backdrop = false,
        position = "float",
        border = "rounded",
        title_pos = "left",
        height = 1,
        noautocmd = true,
        relative = "editor",
        -- Calculate position relative to cursor
        row = function()
          local cursor = vim.api.nvim_win_get_cursor(0)
          local row = cursor[1] - 1 -- Convert to 0-based
          local win_height = vim.api.nvim_win_get_height(0)
          local screen_row = vim.fn.winline() - 1 -- Current cursor screen line (0-based)

          -- Position 3 lines above cursor, but ensure it's visible
          local target_row = screen_row - 3
          if target_row < 0 then
            target_row = screen_row + 2 -- Position below if not enough space above
          end

          return target_row
        end,
        col = function()
          local cursor = vim.api.nvim_win_get_cursor(0)
          local col = cursor[2] -- Current cursor column
          local win_width = vim.api.nvim_win_get_width(0)

          -- Ensure the input box doesn't go off-screen
          local input_width = 60 -- Default input width
          if col + input_width > win_width then
            col = win_width - input_width
          end

          return math.max(0, col)
        end,
        width = 60,
        wo = {
          winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
          cursorline = false,
        },
        bo = {
          filetype = "snacks_input",
          buftype = "prompt",
        },
        --- buffer local variables
        b = {
          completion = false, -- disable blink completions in input
        },
        keys = {
          n_esc = { "<esc>", { "cmp_close", "cancel" }, mode = "n", expr = true },
          i_esc = { "<esc>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
          i_cr = { "<cr>", { "cmp_accept", "confirm" }, mode = "i", expr = true },
          i_tab = { "<tab>", { "cmp_select_next", "cmp", "fallback" }, mode = "i", expr = true },
          i_ctrl_w = { "<c-w>", "<c-s-w>", mode = "i", expr = true },
          i_up = { "<up>", { "hist_up" }, mode = { "i", "n" } },
          i_down = { "<down>", { "hist_down" }, mode = { "i", "n" } },
          q = "cancel",
        },
      },
    },
    input = {
      enabled = true,
      win = {
        style = "cursor_input",
      },
    },
  },
}
