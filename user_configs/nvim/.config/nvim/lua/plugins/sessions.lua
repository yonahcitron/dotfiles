return {
  "natecraddock/sessions.nvim",
  opts = {
    events = { "VimLeavePre" }, -- Saves session when leaving vim (e.g. with ZQ)
    session_filepath = ".nvim-workspace/session", -- each workspace keeps its own file
  },
}
