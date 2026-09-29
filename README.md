# dimidium.nvim

A Neovim port of [dimidium](https://github.com/dofuuz/dimidium) by dofuuz — *"a
terminal color scheme crafted with science"*.

The 16 ANSI values are reproduced exactly and pushed to `g:terminal_color_*`, so
`:terminal` matches your real terminal. The editor palette adjusts two of them
(and derives every UI surface from them) so that ordinary code clears WCAG AA
against the `#141414` background.

## Requirements

- Neovim >= 0.9 (treesitter `@` captures, `nvim_set_hl`)
- `termguicolors`

## Installation

[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  '<your-github-username>/dimidium.nvim',
  lazy = false,
  priority = 1000,
  ---@type DimidiumOpts
  opts = {},
  config = function(_, opts)
    require('dimidium').setup(opts)
    vim.cmd.colorscheme 'dimidium'
  end,
}
```

Or without a plugin manager, `:colorscheme dimidium`.

## Configuration

`setup()` is optional. Defaults:

```lua
require('dimidium').setup {
  transparent = false,      -- use the terminal background
  dim_inactive = false,     -- darken unfocused windows
  terminal_colors = true,   -- publish the ANSI palette to g:terminal_color_*
  styles = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    types = { bold = true },
    booleans = {},
    variables = {},
  },
  --- Mutate the palette before highlights are built.
  on_colors = function(colors) end,
  --- Mutate the highlight table before it is applied.
  on_highlights = function(highlights, colors) end,
}
```

Pass `{}` for a style to clear it, e.g. `styles = { comments = {} }` turns off
italic comments.

### Overriding highlights

```lua
require('dimidium').setup {
  on_highlights = function(hl, c)
    hl.Comment = { fg = c.gray6 }
    hl['@variable.member'] = { fg = c.cyan }
  end,
}
```

### lualine

```lua
require('lualine').setup { options = { theme = 'dimidium' } }
```

## Palette

The canonical 16 colors, available as `require('dimidium.palette').ansi`:

| Name           | Hex       | Name           | Hex       |
| -------------- | --------- | -------------- | --------- |
| Black          | `#000000` | Bright Black   | `#817e7e` |
| Red            | `#cf494c` | Bright Red     | `#ff643b` |
| Green          | `#60b442` | Bright Green   | `#37e57b` |
| Yellow         | `#db9c11` | Bright Yellow  | `#fccd1a` |
| Blue           | `#0575d8` | Bright Blue    | `#688dfd` |
| Magenta        | `#af5ed2` | Bright Magenta | `#ed6fe9` |
| Cyan           | `#1db6bb` | Bright Cyan    | `#32e0fb` |
| White          | `#bab7b6` | Bright White   | `#dee3e4` |

Foreground `#bab7b6`, background `#141414`.

### Deviations from the terminal palette

Two syntax colors differ from their ANSI counterparts, because the originals
fall below the 4.5:1 body-text threshold on `#141414`:

| Role   | ANSI                | Editor              |
| ------ | ------------------- | ------------------- |
| red    | `#cf494c` — 4.13:1  | `#d95d60` — 4.99:1  |
| blue   | `#0575d8` — 3.99:1  | `#5286dd` — 5.10:1  |

`#5286dd` is upstream's own *Link* color, from
[dofuuz/dimidium#2](https://github.com/dofuuz/dimidium/issues/2). The remaining
colors already pass and are used unchanged. `:terminal` always gets the exact
ANSI values regardless.

The `Visual` background is mixed from upstream's *Selection BG* (`#8db8e5`) at
18% over the background, which keeps selected code legible — the naive choice of
a lighter selection drops red and blue to roughly 2.1:1.

## Palette introspection

```vim
:lua vim.print(require('dimidium').report())
```

Lists every palette color with its WCAG contrast ratio against the background,
worst first. Useful when tweaking colors via `on_colors`.

## Supported plugins

blink.cmp · gitsigns.nvim · snacks.nvim (picker, notifier, dashboard, indent,
scratch, profiler) · oil.nvim · which-key.nvim · todo-comments.nvim ·
indent-blankline.nvim · nvim-dap / nvim-dap-ui · render-markdown.nvim ·
mini.nvim (icons, statusline, starter, surround, indentscope) ·
nvim-treesitter-context · telescope.nvim · nvim-notify · lazy.nvim · mason.nvim

## Structure

```
colors/dimidium.lua           entry point for :colorscheme
lua/dimidium/init.lua         setup(), load(), terminal(), report()
lua/dimidium/config.lua       options and defaults
lua/dimidium/palette.lua      ANSI set + semantic colors + derived surfaces
lua/dimidium/highlights.lua   builds the highlight table
lua/dimidium/util.lua         color blending and WCAG contrast
lua/lualine/themes/dimidium.lua
```

`highlights.get(opts)` returns the table rather than applying it, so
`on_highlights` can rewrite anything before it reaches `nvim_set_hl`.

## Credits

- [dofuuz/dimidium](https://github.com/dofuuz/dimidium) — the original palette.

## License

MIT for the port; the palette itself is zlib-licensed by dofuuz. See
[LICENSE](LICENSE).
