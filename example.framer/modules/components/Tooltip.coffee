{ theme } = require 'components/Theme'

MODEL = "tooltip"

class exports.Tooltip extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options
		
		@app = options.app

		_.defaults options,
			name: 'Tooltip'
			animationOptions:
				time: .2
				colorModel: 'husl'

			text: 'Tooltip'
			direction: 'below'

		@customTheme = undefined
		@customOptions = {}

		super options

		_.assign @,
			text: options.text 
			direction: options.direction

		# ---------------
		# Layers
		
		@diamond = new Layer
			parent: @
			size: 12
			rotation: 45

		Utils.linkProperties @, @diamond, 'backgroundColor'

		@textLayer = new Body2
			color: white
			padding: {top: 15, bottom: 15, left: 15, right: 15}
			text: @text

		if @textLayer.width < 150
			_.assign @textLayer, 
				width: 150
				textAlign: 'center'

		@size = @textLayer.size
		@textLayer.parent = @
		
		# ---------------
		# Events



		# ---------------
		# Definitions
	
		Utils.define @, 'theme', 'default', @_setTheme
		Utils.define @, 'direction', options.direction, @_showDirection, _.isString, "Tooltip.direction must be a string."
		

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

	_showDirection: (string) ->
		switch string
			when "above"
				@diamond.props =
					x: Align.center
					y: Align.bottom(6)
					rotationY: 40
					rotationX: 0
			when "below"
				@diamond.props =
					x: Align.center
					y: -6
					rotationY: 40
					rotationX: 0
			when "right"
				@diamond.props =
					x: -6
					y: Align.center()
					rotationY: 0
					rotationX: 40
			when "left"
				@diamond.props =
					x: Align.right(6)
					y: Align.center()
					rotationY: 0
					rotationX: 40
			else
				throw 'Tooltip.direction must be either "above", "right", "below", or "left".'


	# ---------------
	# Public Methods


	# ---------------
	# Special Definitions