return {
  "Olical/conjure",
  init = function()
    vim.g["conjure#client#python#stdio#command"] = "uv run python3 -iq"
  end,
}
