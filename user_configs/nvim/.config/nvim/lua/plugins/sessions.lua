return {
  "natecraddock/sessions.nvim",
  opts = {
    events = { "VimLeavePre" }, -- Saves session when leaving vim (e.g. with ZQ)
    session_filepath = ".nvim/session", -- each workspace keeps its own file
  },
}
