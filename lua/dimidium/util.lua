local M = {}

---Split "#rrggbb" into its three 0-255 channels.
---@param hex string
---@return integer r, integer g, integer b
local function to_rgb(hex)
  hex = hex:gsub('#', '')
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

---Alpha-composite `front` over `back`.
---@param front string "#rrggbb"
---@param back string "#rrggbb"
---@param alpha number 0.0 = fully `back`, 1.0 = fully `front`
---@return string hex
function M.blend(front, back, alpha)
  local fr, fg, fb = to_rgb(front)
  local br, bg, bb = to_rgb(back)
  local function ch(f, b)
    return math.floor(f * alpha + b * (1 - alpha) + 0.5)
  end
  return string.format('#%02x%02x%02x', ch(fr, br), ch(fg, bg), ch(fb, bb))
end

---Relative luminance per WCAG 2.x.
---@param hex string
---@return number
function M.luminance(hex)
  local rgb = { to_rgb(hex) }
  local lin = {}
  for i, c in ipairs(rgb) do
    c = c / 255
    lin[i] = c <= 0.04045 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
  end
  return 0.2126 * lin[1] + 0.7152 * lin[2] + 0.0722 * lin[3]
end

---WCAG contrast ratio between two colors (1.0 .. 21.0).
---@param a string
---@param b string
---@return number
function M.contrast(a, b)
  local la, lb = M.luminance(a), M.luminance(b)
  local hi, lo = math.max(la, lb), math.min(la, lb)
  return (hi + 0.05) / (lo + 0.05)
end

return M
