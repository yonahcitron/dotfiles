-- I've configured workspaces.nvim to auto-save per workspace if it detect the relevant marker file, see hooks.
local autosave = require("auto-save")
return {
  "natecraddock/workspaces.nvim",
  opts = {
    hooks = {
      open = {
        -- 1. Use workspace marker file to devide whether to enable auto-save or not
        function(name, path)
          local marker = path .. "/.nvim-workspace/.autosave"
          if vim.fn.filereadable(marker) == 1 then
            autosave.on()
            vim.notify("workspace:" .. name .. "\n" .. "autosave:" .. "enabled")
          else
            autosave.off()
            vim.notify("workspace:" .. name .. "\n" .. "autosave:" .. "disabled")
          end
        end,
        "SessionsLoad",
        "SessionsSave",
      },
      open_pre = {
        -- final-save & stop autosave for the workspace you’re leaving
        "SessionsStop", -- saves and stops recording for the current session. In sessions.lua config file, it's also configured to save the session in the cwd upon leaving nvim.
        function()
          -- Delete all buffers except any terminal buffers
          vim.cmd([[
            silent! bufdo if &buftype !=# 'terminal' | bdelete | endif
          ]])
        end,
      },
    },
  },
}
