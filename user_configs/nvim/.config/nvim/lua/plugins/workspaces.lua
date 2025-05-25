-- I've configured workspaces.nvim to auto-save per workspace if it detect the relevant marker file, see hooks.
local autosave = require("auto-save")
return {
  "natecraddock/workspaces.nvim",
  opts = {
    hooks = {
      open = {
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
      },
    },
  },
}
