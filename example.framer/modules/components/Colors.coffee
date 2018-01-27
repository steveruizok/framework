exports.color = colors =
	black: '#000'
	white: '#FFF'

	blue: '#0085be'
	lightBlue: '#77dcfb'
	mediumBlue: '#00aadc'
	darkBlue: '#005082'

	gray: '#87a5bc'
	brightGray: '#f4f6f8'
	lightGray: '#c8d7e1'
	lighterGray: '#e9eff3'
	highGray: '#a8becf'
	lowGray: '#668eaa'
	darkGray: '#4e748d'
	darkerGray: '#3e586d'
	deepGray: '#2f4452'

	fireOrange: '#d54d21'
	jazzyOrange: '#f0811d'

	valid: '#4ab866'
	warning: '#f0b849'
	error: '#d94f4f'
	
# Colors
for k,v of colors
	window[k] = v