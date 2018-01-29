{ theme } = require 'components/Theme'

class exports.NewComponent extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options

		@app = options.app

		_.defaults options,
			name: 'New Component'
			animationOptions:
				time: .2

		@customTheme = undefined
		@customOptions = {}

		super options

		# ---------------
		# Layers
		


		# ---------------
		# Events



		# ---------------
		# Definitions
		
		Utils.defineValid @, 'selected', options.selected, _.isBoolean, @showSelected
		Utils.define @, 'theme', 'default', @_setTheme



	# ---------------
	# Private Methods

	_getCustomTheme: (color, backgroundColor) ->
		return {
			default:
				color: black
				borderColor: new Color(backgroundColor).darken(10)
				backgroundColor: backgroundColor
				shadowColor: 'rgba(0,0,0,.16)'
			disabled:
				color: new Color(color).alpha(.15)
				borderColor: new Color(color).alpha(.15)
				backgroundColor: new Color(backgroundColor).alpha(0)
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: black
				borderColor: new Color(backgroundColor).darken(20)
				backgroundColor: new Color(backgroundColor).darken(20)
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: black
				borderColor: new Color(backgroundColor).darken(20)
				backgroundColor: new Color(backgroundColor).darken(10)
				shadowColor: 'rgba(0,0,0,.16)'
			}

	_setTheme: (value) =>
		@animateStop()
		props = @customTheme?[value] ? _.defaults(
			_.clone(@customOptions), 
			theme.TEMPLATE[@palette][value]
			)

		if @__instancing then @props = props else @animate props



	# ---------------
	# Public Methods


	# ---------------
	# Special Definitions