# dimidium palette

Extracted from `lua/dimidium/palette.lua`. Derived surfaces were resolved by
running `require('dimidium.palette')` headless, so these are the computed values.
Contrast ratios are against `Background #141414`.

## Core + ANSI 16

```
Foreground     	186, 183, 182	#BAB7B6
Background     	 20,  20,  20	#141414
Black          	  0,   0,   0	#000000
Red            	207,  73,  76	#CF494C
Green          	 96, 180,  66	#60B442
Yellow         	219, 156,  17	#DB9C11
Blue           	  5, 117, 216	#0575D8
Magenta        	175,  94, 210	#AF5ED2
Cyan           	 29, 182, 187	#1DB6BB
White          	186, 183, 182	#BAB7B6
Bright Black   	129, 126, 126	#817E7E
Bright Red     	255, 100,  59	#FF643B
Bright Green   	 55, 229, 123	#37E57B
Bright Yellow  	252, 205,  26	#FCCD1A
Bright Blue    	104, 141, 253	#688DFD
Bright Magenta 	237, 111, 233	#ED6FE9
Bright Cyan    	 50, 224, 251	#32E0FB
Bright White   	222, 227, 228	#DEE3E4
```

These 16 are the canonical ANSI set -- byte-identical to upstream, and what gets
pushed to `g:terminal_color_*`.

## Syntax accents (editor palette)

Two differ from ANSI on purpose, to clear WCAG AA 4.5:1 against `#141414`:

```
Red (syntax)   	217,  93,  96	#D95D60   (ANSI #CF494C -> too dark, 4.13:1)
Green (syntax) 	 96, 180,  66	#60B442   (= ANSI, 7.11:1)
Yellow (syntax)	219, 156,  17	#DB9C11   (= ANSI, 7.70:1)
Blue (Link)    	  82, 134, 221	#5286DD   (ANSI #0575D8 -> too dark, 3.99:1)
Magenta (syntax)175,  94, 210	#AF5ED2   (= ANSI, 4.70:1)
Cyan (syntax)  	 29, 182, 187	#1DB6BB   (= ANSI, 7.42:1)
Selection src  	141, 184, 229	#8DB8E5   (Visual bg mixed from this)
```

## Muted grays (CAM16 ramp, bg -> fg)

```
gray1   	 37,  36,  36	#252424   (1.19:1)
gray2   	 53,  52,  51	#353433   (1.48:1)
gray3   	 68,  67,  67	#444343   (1.87:1)
gray4   	 84,  82,  82	#545252   (2.37:1)
gray5   	100,  98,  97	#646261   (3.04:1)
gray6   	116, 114, 113	#747271   (3.85:1)
gray7   	132, 130, 129	#848281   (4.82:1)
gray8   	150, 147, 146	#969392   (6.04:1)
gray9   	168, 164, 164	#A8A4A4   (7.47:1)
gray10  	186, 183, 182	#BAB7B6   (= fg, 9.24:1)
```

## Derived surfaces

```
bg_float    	25,  25,  25	#191919
bg_dim      	11,  11,  11	#0B0B0B
bg_sel      	42,  50,  58	#2A323A
bg_sel_dim  	32,  36,  41	#202429
diff_add    	34,  49,  28	#22311C
diff_delete 	52,  32,  32	#342020
diff_change 	18,  33,  45	#12212D
diff_text   	36,  50,  72	#243248
```

## Notes

- Everything from `bg_float` down is blend-derived (via `util.blend`) from `bg`,
  so editing `bg` propagates to them.
- `none = 'NONE'` is also in the palette table but is not a real color.
