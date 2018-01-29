# set up colors

exports.colors = colors =
	black: '#252729'
	gray: '#c1c1c2'
	yellow: '#ffd16d'
	white: '#FFF'
	blue: '#5399c3'
	red: '#d96161'
	green: '#599FA0'
	purple: '#5499c3'
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


# add shades to window (don't change this)

for color, value of colors
	window[color] = value
	for mod, func of mods
		newColor = func(new Color(value))
		colors[color + mod] = newColor
		window[color + mod] = newColor
	