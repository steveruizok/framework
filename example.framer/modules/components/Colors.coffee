# set up colors

exports.colors = colors =
	black: '#252729'
	grey: '#c1c1c2'
	yellow: '#ffd16d'
	white: '#FFF'
	blue: '#5399c3'
	red: '#d96161'
	green: '#599FA0'
	beige: '#eae5e0'

# Set up shades

mods =
	'80': (c) -> c.darken(30)
	'70': (c) -> c.darken(20)
	'60': (c) -> c.darken(10)
	'50': (c) -> c.darken(0)
	'40': (c) -> c.lighten(10)
	'30': (c) -> c.lighten(20)
	'20': (c) -> c.lighten(30)

# add shades

for color, value of colors
	window[color] = value
	for mod, func of mods
		newColor = func(new Color(value))
		colors[color + mod] = newColor

# add backgrounds

_.assign colors,
	bg1: '#fcfcf9'
	bg3: '#f8f8f5'
	bg5: '#f4f4f1'

# add values to window

for color, value of colors
	window[color] = value
	