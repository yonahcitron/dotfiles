require("config.lazy") -- loading this file bootstraps lazy.nvim, LazyVim and my plugins they manage
vim.wo.relativenumber = false
vim.opt.wrap = true

-- Get into terminal normal mode just by hitting esc
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

-- Automatically reload files when they change on disk - needed for things like gemini cli to be able to apply changes to the buffer in real time
vim.o.autoread = true

-- Trigger checktime on focus gained and buffer enter
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "checktime",
})

-- ##########################################
-- ########## Gemini cli buffer #############
-- ##########################################

-- A global table to store terminal buffers, keyed by workspace path.
if not _G.gemini_terminals then
  _G.gemini_terminals = {}
end

-- Create a single, clearable autocommand group for our terminal management.
local gemini_term_group = vim.api.nvim_create_augroup("GeminiTerm", { clear = true })

-- Use a TermClose autocommand to clean up our state when the terminal shell *process* actually exits.
vim.api.nvim_create_autocmd("TermClose", {
  group = gemini_term_group,
  pattern = "*",
  callback = function(args)
    -- Check if the closed terminal is one we are managing.
    for path, bufnr in pairs(_G.gemini_terminals) do
      if bufnr == args.buf then
        -- The closed terminal was a gemini terminal. Reset its state.
        _G.gemini_terminals[path] = nil
        vim.notify(
          "Gemini terminal for workspace '" .. path .. "' has been reset.",
          vim.log.levels.INFO,
          { title = "Terminal" }
        )
        break
      end
    end
  end,
})

-- Function to toggle a vertical terminal for Gemini, aware of workspaces.
local function toggle_gemini_terminal()
  local workspace_path = vim.fn.getcwd()
  local term_bufnr = _G.gemini_terminals[workspace_path]
  local win_id = -1

  -- Check if a terminal buffer is recorded for this workspace and if it's currently visible.
  if term_bufnr and vim.api.nvim_buf_is_valid(term_bufnr) then
    win_id = vim.fn.bufwinid(term_bufnr)
  else
    -- Clean up any invalid buffer entry
    _G.gemini_terminals[workspace_path] = nil
  end

  -- Case 1: The terminal window is currently visible. We should close it.
  if win_id ~= -1 then
    vim.api.nvim_win_close(win_id, false)
  else
    -- Case 2: The terminal window is not visible.
    -- We now check if we have a valid, hidden buffer to reuse.
    if term_bufnr and vim.api.nvim_buf_is_valid(term_bufnr) then
      -- Sub-case 2a: A valid terminal buffer already exists but is hidden. Re-open it.
      vim.cmd("vsplit")
      vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.33))
      vim.api.nvim_set_current_buf(term_bufnr) -- Re-assign the existing buffer to the new window
      vim.cmd("startinsert") -- Go into insert mode
    else
      -- Sub-case 2b: No valid terminal buffer exists. Create a new one.
      vim.cmd("vsplit")
      vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.33))
      vim.cmd("terminal gemini") -- This is the only time 'gemini' is run
      _G.gemini_terminals[workspace_path] = vim.api.nvim_get_current_buf()
      vim.cmd("startinsert")
    end
  end
end

-- Map <Leader>' as it's more reliable than <C-'> across terminals
vim.keymap.set("n", "<Leader>'", toggle_gemini_terminal, {
  noremap = true,
  silent = true,
  desc = "Toggle Gemini vertical terminal (Workspaces)",
})
