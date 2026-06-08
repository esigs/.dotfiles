local actions = {
  h = "vertical resize -5",
  l = "vertical resize +5",
  j = "resize +3",
  k = "resize -3",
  H = "vertical resize -20",
  L = "vertical resize +20",
  J = "resize +10",
  K = "resize -10",
}

return function()
  while true do
    vim.api.nvim_echo({ { "-- RESIZE -- (hjkl/HJKL, any other key exits)", "ModeMsg" } }, false, {})
    vim.cmd("redraw")
    local ok, ch = pcall(vim.fn.getcharstr)
    if not ok then break end
    local cmd = actions[ch]
    if not cmd then break end
    vim.cmd(cmd)
  end
  vim.api.nvim_echo({ { "", "" } }, false, {})
end
