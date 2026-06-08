local function load_stylix_palette()
  local path = vim.fn.expand("~/.config/stylix/palette.json")
  if vim.fn.filereadable(path) ~= 1 then return nil end
  local f = io.open(path, "r")
  if not f then return nil end
  local json = f:read("*all")
  f:close()
  return vim.fn.json_decode(json)
end

local function apply_stylix(palette)
  local colors = {}
  for _, k in ipairs({
    "base00", "base01", "base02", "base03", "base04", "base05", "base06", "base07",
    "base08", "base09", "base0A", "base0B", "base0C", "base0D", "base0E", "base0F",
  }) do
    colors[k] = "#" .. palette[k]
  end
  require("base16-colorscheme").setup(colors)
end

return {
  "RRethy/base16-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local palette = load_stylix_palette()
    if palette then apply_stylix(palette) end
  end,
}
