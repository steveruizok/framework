Theme = require "components/Theme"
theme = undefined

class exports.Separator extends Layer
	constructor: (options = {}) ->
		theme = Theme.theme
		
		_.defaults options,
			name: 'Separator'
			width: Screen.width
			height: 16
			backgroundColor: '#eee'
			clip: true
			shadowY: -1
			shadowColor: 'rgba(0,0,0,.41)'
	
		super options