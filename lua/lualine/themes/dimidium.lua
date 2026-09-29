local c = require('dimidium.palette').colors

local function mode(color)
  return { fg = c.bg, bg = color, gui = 'bold' }
end

return {
  normal = {
    a = mode(c.blue),
    b = { fg = c.fg, bg = c.gray2 },
    c = { fg = c.gray8, bg = c.gray1 },
  },
  insert = { a = mode(c.green) },
  visual = { a = mode(c.magenta) },
  replace = { a = mode(c.red) },
  command = { a = mode(c.yellow) },
  terminal = { a = mode(c.cyan) },
  inactive = {
    a = { fg = c.gray6, bg = c.gray1, gui = 'bold' },
    b = { fg = c.gray6, bg = c.gray1 },
    c = { fg = c.gray6, bg = c.gray1 },
  },
}
