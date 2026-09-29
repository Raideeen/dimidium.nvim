--- dimidium.nvim -- a Neovim port of the dimidium terminal palette.
--- https://github.com/dofuuz/dimidium
---
--- Usage:
---   :colorscheme dimidium
--- or, to configure it first:
---   require('dimidium').setup({ transparent = true })
---   vim.cmd.colorscheme 'dimidium'

local config = require 'dimidium.config'

local M = {}

M.palette = require 'dimidium.palette'

---Store options. Does not apply the colorscheme -- call `:colorscheme dimidium`
---(or `M.load()`) afterwards, as is conventional for Neovim themes.
---@param opts DimidiumOpts?
function M.setup(opts)
  config.setup(opts)
  -- Re-apply immediately if we are already the active colorscheme, so that
  -- `setup()` from a lazy `opts`/`config` block takes effect either way.
  if vim.g.colors_name == 'dimidium' then
    M.load()
  end
end

---Apply the colorscheme.
---@param opts DimidiumOpts? one-shot overrides, not persisted
function M.load(opts)
  local o = opts and config.setup(opts) or config.options

  if not vim.o.termguicolors then
    vim.notify('dimidium: needs `termguicolors`; colors will be approximated', vim.log.levels.WARN)
  end

  -- Set 'background' *before* `highlight clear`: changing it re-sources the
  -- current colorscheme, which would otherwise re-enter this function.
  if vim.o.background ~= 'dark' then
    vim.o.background = 'dark'
  end

  vim.cmd 'highlight clear'
  if vim.fn.exists 'syntax_on' == 1 then
    vim.cmd 'syntax reset'
  end
  -- `highlight clear` wipes g:colors_name, so it has to be set after.
  vim.g.colors_name = 'dimidium'

  local highlights, colors = require('dimidium.highlights').get(o)
  for group, spec in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  if o.terminal_colors then
    M.terminal(colors)
  end
end

---Publish the palette to `:terminal`. Uses the canonical ANSI values, not the
---contrast-corrected editor colors, so `:terminal` matches the real terminal.
function M.terminal(_)
  local a = M.palette.ansi
  local order = {
    a.black,
    a.red,
    a.green,
    a.yellow,
    a.blue,
    a.magenta,
    a.cyan,
    a.white,
    a.bright_black,
    a.bright_red,
    a.bright_green,
    a.bright_yellow,
    a.bright_blue,
    a.bright_magenta,
    a.bright_cyan,
    a.bright_white,
  }
  for i, color in ipairs(order) do
    vim.g['terminal_color_' .. (i - 1)] = color
  end
end

---Contrast audit for the palette, as a list of `{ name, hex, ratio }`.
---Handy when tweaking colors: `:lua vim.print(require('dimidium').report())`
---@param bg string? background to measure against (defaults to the theme bg)
function M.report(bg)
  local util = require 'dimidium.util'
  local c = M.palette.colors
  bg = bg or c.bg
  local rows = {}
  for name, hex in pairs(c) do
    if type(hex) == 'string' and hex:match '^#%x%x%x%x%x%x$' then
      table.insert(rows, { name = name, hex = hex, ratio = math.floor(util.contrast(hex, bg) * 100 + 0.5) / 100 })
    end
  end
  table.sort(rows, function(x, y)
    return x.ratio < y.ratio
  end)
  return rows
end

return M
