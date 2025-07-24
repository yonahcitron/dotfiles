--- @class VirtualTextSpinner.SpinnerOpts
--- @field spinner_text string Text to display before the spinner
--- @field spinner_frames string[] Spinner frames to use for the spinner
--- @field hl_group string Highlight group for the spinner
--- @field repeat_interval number Interval in milliseconds to update the spinner
--- @field extmark vim.api.keyset.set_extmark Extmark options passed to nvim_buf_set_extmark
local spinner_opts = {
  spinner_text = "  Processing",
  spinner_frames = { "⣷", "⣯", "⣟", "⡿", "⢿", "⣻", "⣽", "⣾" },
  hl_group = "DiagnosticVirtualTextWarn",
  repeat_interval = 100,
  extmark = {
    virt_text_pos = "inline",
    priority = 1000,
  },
}

--- @class VirtualTextSpinner
--- @field bufnr number The buffer number where the spinner is displayed
--- @field ns_id number The namespace ID for the extmark
--- @field line_num number The line number where the spinner is displayed
--- @field current_index number Current index in the spinner frames array
--- @field timer uv.uv_timer_t | nil Timer used to update spinner animation
--- @field opts VirtualTextSpinner.SpinnerOpts Configuration options for the spinner
local VirtualTextSpinner = {
  bufnr = 0,
  ns_id = 0,
  line_num = 0,
  current_index = 1,
  timer = nil,
  opts = spinner_opts,
}

--- @class VirtualTextSpinner.Opts
--- @field bufnr number Buffer number to display the spinner in
--- @field ns_id number Namespace ID for the extmark
--- @field line_num number Line number to display the spinner on (1-indexed)
--- @field width? number Width of the spinner
--- @field opts? VirtualTextSpinner.SpinnerOpts Optional configuration options

--- Creates a new VirtualTextSpinner instance
--- @param opts VirtualTextSpinner.Opts Options for the spinner
--- @return VirtualTextSpinner self New spinner instance
function VirtualTextSpinner.new(opts)
  local width = opts.width or 0
  local spinner_opts = vim.tbl_deep_extend("force", spinner_opts, opts.opts or {})
  local width_center = width - spinner_opts.spinner_text:len()
  local col = width_center > 0 and math.floor(width_center / 2) or 0
  return setmetatable({
    bufnr = opts.bufnr,
    ns_id = opts.ns_id,
    line_num = opts.line_num - 1,
    current_index = 1,
    timer = vim.uv.new_timer(),
    opts = vim.tbl_deep_extend("force", spinner_opts, { extmark = { virt_text_win_col = col } }),
  }, { __index = VirtualTextSpinner })
end

--- Gets the virtual text content for the spinner
--- @return table[]
function VirtualTextSpinner:get_virtual_text()
  return { { self.opts.spinner_text .. " " .. self.opts.spinner_frames[self.current_index] .. " ", self.opts.hl_group } }
end

--- @private
--- @return number id of the extmark
function VirtualTextSpinner:set_extmark()
  return vim.api.nvim_buf_set_extmark(self.bufnr, self.ns_id, self.line_num, 0, self.opts.extmark)
end

--- Starts the spinner animation
--- Creates the extmark and starts the timer to update the spinner frames
function VirtualTextSpinner:start()
  self.opts.extmark.virt_text = self:get_virtual_text()
  self.opts.extmark.id = self:set_extmark()
  self.timer:start(
    0,
    self.opts.repeat_interval,
    vim.schedule_wrap(function()
      self.current_index = self.current_index % #self.opts.spinner_frames + 1
      self.opts.extmark.virt_text = self:get_virtual_text()
      self:set_extmark()
    end)
  )
end

--- Stops the spinner animation
--- Cleans up the timer and removes the extmark
function VirtualTextSpinner:stop()
  if self.timer then
    self.timer:stop()
    self.timer:close()
    self.timer = nil
  end
  if self.opts.extmark then
    vim.schedule(function()
      vim.api.nvim_buf_del_extmark(self.bufnr, self.ns_id, self.opts.extmark.id)
    end)
  end
end

return VirtualTextSpinner
