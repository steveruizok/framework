{ theme } = require 'components/Theme'

MODEL = "component"

class exports.NewComponent extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options
		
		@app = options.app

		_.defaults options,
			name: 'New Component'
			animationOptions:
				time: .2
				colorModel: 'husl'

		@customTheme = undefined
		@customOptions = {}

		super options

		# ---------------
		# Layers
		


		# ---------------
		# Events



		# ---------------
		# Definitions
		
		Utils.define @, 'selected', options.selected, @showSelected, _.isBoolean, 'Selected must be a boolean (true or false).'
		Utils.define @, 'theme', 'default', @_setTheme



	# ---------------
	# Private Methods

	_getCustomTheme: (color, backgroundColor) ->
		color = new Color(color)
		bg = new Color(backgroundColor)

		return {
			default:
				color: color
				borderColor: bg.darken(10)
				backgroundColor: bg
				shadowColor: 'rgba(0,0,0,.16)'
			disabled:
				color: color.alpha(.15)
				borderColor: color.alpha(.15)
				backgroundColor: bg.alpha(0)
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: color
				borderColor: bg.darken(20)
				backgroundColor: bg.darken(20)
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: color
				borderColor: bg.darken(20)
				backgroundColor: bg.darken(10)
				shadowColor: 'rgba(0,0,0,.16)'
			}

	_setTheme: (value) =>
		@animateStop()
		props = @customTheme?[value] ? _.defaults(
			_.clone(@customOptions), 
			theme[MODEL][value]
			)

		if @__instancing then @props = props else @animate props



	# ---------------
	# Public Methods


	# ---------------
	# Special Definitions