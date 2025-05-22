-- lua/custom/fzf-workspaces.lua
local fzf = require("fzf-lua") -- must be "fzf-lua"
local workspaces = require("workspaces")

return function()
  local lines = {}

  -- 1. create one string per workspace
  for _, ws in ipairs(workspaces.get()) do
    lines[#lines + 1] = ws.name .. "\t" .. ws.path -- <TAB> separates the columns
  end

  -- 2. run the picker
  fzf.fzf_exec(lines, {
    prompt = "Workspaces❯ ",
    fzf_opts = { ["--with-nth"] = "1", ["--delimiter"] = "\t" },

    actions = {
      ["default"] = function(selected)
        -- selected[1] is the full line; take everything before the first tab
        local name = selected[1]:match("^[^\t]+")
        workspaces.open(name)
      end,
    },

    previewer = "builtin", -- optional: shows the path column
  })
end
