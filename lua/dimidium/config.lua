local M = {}

---@class DimidiumStyles
---@field comments table
---@field keywords table
---@field functions table
---@field types table
---@field booleans table
---@field variables table

---@class DimidiumOpts
M.defaults = {
  --- Make Normal/NormalNC/SignColumn/etc. use the terminal background.
  transparent = false,
  --- Darken windows that don't have focus.
  dim_inactive = false,
  --- Publish the 16 ANSI colors to `g:terminal_color_*` for `:terminal`.
  terminal_colors = true,
  --- Per-role attributes, merged into the relevant groups. `{}` disables.
  ---@type DimidiumStyles
  styles = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    types = { bold = true },
    booleans = {},
    variables = {},
  },
  --- Mutate the palette before highlights are built.
  ---@type fun(colors: DimidiumPalette)
  on_colors = function(_) end,
  --- Mutate the highlight table before it is applied.
  ---@type fun(highlights: table<string, vim.api.keyset.highlight>, colors: DimidiumPalette)
  on_highlights = function(_, _) end,
}

---@type DimidiumOpts
M.options = vim.deepcopy(M.defaults)

---@param opts DimidiumOpts?
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.options, opts or {})
  -- `tbl_deep_extend` merges tables, so `styles.comments = {}` would otherwise
  -- be a no-op instead of clearing the italics.
  for role, style in pairs((opts or {}).styles or {}) do
    if next(style) == nil then
      M.options.styles[role] = {}
    end
  end
  return M.options
end

return M
