local util = require 'dimidium.util'

-- The canonical dimidium palette, verbatim from the upstream spec.
-- These 16 values are what gets pushed to `g:terminal_color_*`, so they must
-- stay byte-identical to the reference table -- do not "fix" them here.
-- https://github.com/dofuuz/dimidium
local ansi = {
  black = '#000000',
  red = '#cf494c',
  green = '#60b442',
  yellow = '#db9c11',
  blue = '#0575d8',
  magenta = '#af5ed2',
  cyan = '#1db6bb',
  white = '#bab7b6',
  bright_black = '#817e7e',
  bright_red = '#ff643b',
  bright_green = '#37e57b',
  bright_yellow = '#fccd1a',
  bright_blue = '#688dfd',
  bright_magenta = '#ed6fe9',
  bright_cyan = '#32e0fb',
  bright_white = '#dee3e4',
}

local bg = '#141414'
local fg = '#bab7b6'

-- Upstream's two extra colors (dofuuz/dimidium#2). `link` doubles as the
-- editor's blue because the ANSI blue is too dark to read as body text;
-- `selection_src` is the hue the Visual background is mixed from.
local link = '#5286dd'
local selection_src = '#8db8e5'

local M = {}

M.ansi = ansi

---@class DimidiumPalette
M.colors = {
  bg = bg,
  fg = fg,
  none = 'NONE',

  -- Syntax colors. Two deliberately differ from the ANSI values above so that
  -- ordinary code clears WCAG AA (4.5:1) against #141414:
  --   ansi.red  #cf494c -> 4.13:1   red  #d95d60 -> 4.99:1
  --   ansi.blue #0575d8 -> 3.99:1   blue #5286dd -> 5.10:1  (upstream "Link")
  -- The rest of the ANSI set already passes and is used unchanged.
  red = '#d95d60',
  green = ansi.green, -- 7.11:1
  yellow = ansi.yellow, -- 7.70:1
  blue = link, -- 5.10:1
  magenta = ansi.magenta, -- 4.70:1
  cyan = ansi.cyan, -- 7.42:1

  bred = ansi.bright_red, -- 6.26:1
  bgreen = ansi.bright_green, -- 11.10:1
  byellow = ansi.bright_yellow, -- 12.18:1
  bblue = ansi.bright_blue, -- 5.98:1
  bmagenta = ansi.bright_magenta, -- 7.06:1
  bcyan = ansi.bright_cyan, -- 11.57:1
  bwhite = ansi.bright_white, -- 14.22:1

  -- Neutral ramp, CAM16-interpolated between bg and fg.
  -- gray1..gray4 are background-weight, gray5..gray7 are dim text,
  -- gray8..gray10 are readable text (gray8 = 6.04:1).
  gray1 = '#252424',
  gray2 = '#353433',
  gray3 = '#444343',
  gray4 = '#545252',
  gray5 = '#646261',
  gray6 = '#747271',
  gray7 = '#848281',
  gray8 = '#969392',
  gray9 = '#a8a4a4',
  gray10 = '#bab7b6',
}

local c = M.colors

-- Derived surfaces. Computed rather than hand-picked so that a change to `bg`
-- or to a syntax color propagates instead of silently drifting out of sync.
c.bg_float = util.blend(fg, bg, 0.03) -- #191919
c.bg_dim = util.blend(ansi.black, bg, 0.45) -- inactive windows
c.bg_sel = util.blend(selection_src, bg, 0.18) -- #2a323a, keeps red/blue >2.9:1
c.bg_sel_dim = util.blend(selection_src, bg, 0.10)

-- Diff surfaces: enough tint to name the change, dark enough that syntax
-- highlighting on top of them stays legible (fg keeps ~7:1 on all four).
c.diff_add = util.blend(c.green, bg, 0.18)
c.diff_delete = util.blend(c.red, bg, 0.16)
c.diff_change = util.blend(ansi.blue, bg, 0.13)
c.diff_text = util.blend(c.blue, bg, 0.26)

return M
