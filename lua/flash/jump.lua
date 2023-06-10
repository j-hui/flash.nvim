local M = {}

---@param match Flash.Match
---@param state Flash.State
---@return Flash.Match?
function M.jump(match, state)
  if state.config.jump.jumplist then
    vim.cmd("normal! m'")
  end
  if match.win ~= vim.api.nvim_get_current_win() then
    vim.api.nvim_set_current_win(match.win)
  end

  if state.config.jump.pos == "start" then
    -- jump to start
    vim.api.nvim_win_set_cursor(match.win, match.from)
  elseif state.config.jump.pos == "end" then
    -- jump to end
    vim.api.nvim_win_set_cursor(match.win, match.to)
  else
    -- select
    if vim.fn.mode() == "v" then
      vim.cmd("normal! v")
    end
    vim.api.nvim_win_set_cursor(match.win, match.from)
    vim.cmd("normal! v")
    vim.api.nvim_win_set_cursor(match.win, match.to)
  end
end

---@param state Flash.State
function M.on_jump(state)
  -- fix or restore the search register
  local sf = vim.v.searchforward
  if state.config.jump.register then
    vim.fn.setreg("/", state.pattern)
  end
  vim.v.searchforward = sf

  -- add the real search pattern to the history
  if state.config.jump.history then
    vim.fn.histadd("search", state.pattern)
  end

  -- clear the highlight
  if state.config.jump.nohlsearch then
    vim.cmd.nohlsearch()
  end
end

return M
