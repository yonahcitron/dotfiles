return {
  "hkupty/iron.nvim",
  enabled = false,
  -- The `config` function allows you to run any setup code after the plugin is loaded.
  -- This is the ideal place to put your exact configuration file.
  config = function()
    -- Paste your entire configuration block here
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")

    iron.setup({
      config = {
        scratch_repl = false,
        repl_definition = {
          sh = {
            command = { "zsh" },
          },
          python = {
            command = { "python3" },
            format = common.bracketed_paste_python,
            block_dividers = { "# %%", "#%%" },
          },
        },
        repl_filetype = function(bufnr, ft)
          return ft
        end,
        repl_open_cmd = view.right(50),
      },
      keymaps = {
        toggle_repl = "<space>rr",
        restart_repl = "<space>rR",
        send_motion = "<space>sc",
        visual_send = "<space>sc",
        send_file = "<space>sf",
        send_line = "<space>sl",
        send_paragraph = "<space>sp",
        send_until_cursor = "<space>su",
        send_mark = "<space>sm",
        send_code_block = "<space>sb",
        send_code_block_and_move = "<space>sn",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>s<cr>",
        interrupt = "<space>s<space>",
        exit = "<space>sq",
        clear = "<space>cl",
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    })

    -- Your keymaps are also included exactly as they were
    vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
    vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
  end,
}
