{ theme } = require 'components/Theme'

class exports.Toggle extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options

		@app = options.app

		_.defaults options,
			name: 'Toggle'
			height: 48
			borderRadius: 4
			shadowY: 2
			shadowBlur: 6
			shadowColor: 'rgba(0,0,0,.16)'
			clip: true
			animationOptions:
				time: .2

			options: ['Off', 'On']
			icon: false
			toggled: false

		@customTheme = if options.backgroundColor and options.color then @_getCustomTheme(options.color, options.backgroundColor) else undefined
		@customOptions = {}

		@options = options.options
		@icon = options.icon

		@__instancing = true
		@__constructor = true

		super options

		# ---------------
		# Layers
		
		@leftButton = new Button
			parent: @
			x: 0
			y: 0
			color: options.color
			text: if options.icon then '' else options.options[0]
			icon: if options.icon then options.options[0]
			backgroundColor: options.backgroundColor

		@leftButton._element.childNodes[0].style['border-radius'] = "#{Utils.px(4)} 0px 0px #{Utils.px(4)}"

		@rightButton = new Button
			parent: @
			x: 0
			y: 0
			color: options.color
			text: if options.icon then '' else options.options[1]
			icon: if options.icon then options.options[1]
			backgroundColor: options.backgroundColor

		@rightButton._element.childNodes[0].style['border-radius'] = "0 #{Utils.px(4)} #{Utils.px(4)} 0"

		# set positions

		maxW = _.maxBy([@leftButton, @rightButton], 'width').width

		for layer in [@leftButton, @rightButton]
			layer.width = maxW
			layer.x = (last?.maxX ? 1) - 1
			last = layer

			customTheme = @customTheme

			do (layer) =>
				layer._setTheme = (value) ->
					@animateStop()

					if @palette is 'toggled' and customTheme?
						props = customTheme[value]
					else props = theme.toggle[@palette][value]

					if @__instancing then @props = props else @animate props

				layer.onSelect => @toggled = _.indexOf(@children, layer)

		_.assign @,
			backgroundColor: null
			height: _.maxBy(@children, 'maxY')?.maxY 
			width: last.maxX

		# ---------------
		# Events



		# ---------------
		# Definitions


		delete @__constructor

		Utils.define @, 'toggledLayer', null, @_showToggled

		@toggled = if options.toggled then 1 else 0

		delete @__instancing

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

	_showToggled: (button) =>
		return if not button

		button.bringToFront()
		button.animateStop()
		button.palette = "toggled"
		button.theme = "default"
		button.animate @customTheme?.default ? theme.toggle.toggled.default

		for sib in button.siblings
			sib.animateStop()
			sib.palette = "default"
			sib.theme = "default"
			sib.animate(theme.toggle.default.default)


	# ---------------
	# Public Methods


	# ---------------
	# Special Definitions

	@define "toggled",
		get: -> return @_toggled
		set: (num) ->
			return if @__constructor
			return if num is @_toggled

			if not _.isNumber(num)
				throw "Toggle.toggled must be a number (the index of the toggled layer)."

			if not @children[num]
				throw "Index is out of range (no layer found at Toggle.children[#{num}])."

			@_toggled = num

			@toggledLayer = @children[num]

			@emit "change:toggled", num, @options[num], @children[num]


