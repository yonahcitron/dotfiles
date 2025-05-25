-- Configure auto-save.nvim but keep it disabled by default
-- I've configured workspaces.nvim to auto-save per workspace if it detect the relevant marker file.
return {
  "pocco81/auto-save.nvim",
  opts = {
    enabled = false,
    events = { "InsertLeave", "BufLeave", "FocusLost" },
    write_all_buffers = false,
    debounce_delay = 200,
    condition = function(buf)
      return vim.bo[buf].modifiable
    end,
  },
}
