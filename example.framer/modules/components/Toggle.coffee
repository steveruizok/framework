Theme = require "components/Theme"
theme = undefined

MODEL = 'segment'

class exports.Toggle extends Layer
	constructor: (options = {}) ->
		theme = Theme.theme

		# ---------------
		# Options

		_.defaults options,
			name: 'Toggle'
			height: 48
			clip: true
			animationOptions:
				time: .2
				colorModel: 'husl'

			options: ["Off", "On"]
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

		_.assign @,
			options: options.options
			buttons: []
			icon: options.icon

		@buttons = @options[0..1].map (option, i) =>
			button = new Button
				name: '.'
				parent: @
				x: 0
				y: 0
				color: options.color
				text: if @icon then '' else option
				icon: if @icon then option
				backgroundColor: options.backgroundColor

			radius = switch i
				when 0 then "#{Utils.px(button.borderRadius)} 0px 0px #{Utils.px(button.borderRadius)}"
				when @options.length - 1 then "0px #{Utils.px(button.borderRadius)} #{Utils.px(button.borderRadius)} 0px"
				else "0px 0px 0px 0px"
			
			button._element.childNodes[0].style['border-radius'] = radius

			return button

		# set positions

		maxW = _.maxBy(@children, 'width').width

		for layer in @children
			layer.width = maxW
			layer.x = (last?.maxX ? 1) - 1
			last = layer

			customTheme = @customTheme

			do (layer) =>
				layer._setTheme = (value) ->
					@animateStop()

					if @palette is 'active' and customTheme?
						props = customTheme[value]
					else props = theme[MODEL][@palette][value]

					if @__instancing then @props = props else @animate props

				layer.onSelect => @toggled = _.indexOf(@children, layer) is 1

		_.assign @,
			backgroundColor: null
			height: _.maxBy(@children, 'maxY')?.maxY 
			width: last.maxX

		# ---------------
		# Events



		# ---------------
		# Definitions


		delete @__constructor

		Utils.define @, 'activeLayer', null, @_showActive

		delete @__instancing

		isOk = (value) -> _.isBoolean(value) or _.isUndefined(value)
		Utils.define @, 'toggled', options.toggled, @_setToggled, isOk, 'Toggle.toggled must be a boolean (true or false) or undefined.'


	# ---------------
	# Private Methods

	_getCustomTheme: (color, backgroundColor) ->
		return {
			default:
				color: color
				borderColor: new Color(backgroundColor).darken(10)
				backgroundColor: backgroundColor
				shadowColor: 'rgba(0,0,0,0)'
			disabled:
				color: new Color(color).alpha(.15)
				borderColor: new Color(color).alpha(.15)
				backgroundColor: new Color(backgroundColor).alpha(0)
				shadowColor: 'rgba(0,0,0,0)'
			touched:
				color: color
				borderColor: new Color(backgroundColor).darken(20)
				backgroundColor: new Color(backgroundColor).darken(20)
				shadowColor: 'rgba(0,0,0,0)'
			hovered:
				color: color
				borderColor: new Color(backgroundColor).darken(20)
				backgroundColor: new Color(backgroundColor).darken(10)
				shadowColor: 'rgba(0,0,0,0)'
			}

	_setToggled: (bool) =>
		if bool is null
			@active = -1
			return

		@active = if bool then 1 else 0

	_showActive: (button) =>
		if not button
			for button in @buttons
				button.animateStop()
				button.palette = "default"
				button.theme = "default"
				button.animate(theme[MODEL].default.default)
			return

		button.bringToFront()
		button.animateStop()
		button.palette = "active"
		button.theme = "default"
		button.animate @customTheme?.default ? theme[MODEL].active.default

		for sib in button.siblings
			sib.animateStop()
			sib.palette = "default"
			sib.theme = "default"
			sib.animate(theme[MODEL].default.default)


	# ---------------
	# Public Methods


	# ---------------
	# Special Definitions

	@define "value", ->
		get: -> return @toggled
		set: (value) -> @toggled = value

	@define "active",
		get: -> return @_active
		set: (num) ->
			return if @__constructor
			return if num is @_active

			if not _.isNumber(num)
				throw "Toggle.active must be a number (the index of the active layer)."

			if num >= 0 and not @children[num]
				throw "Index is out of range (no layer found at Toggle.children[#{num}])."

			@_active = num

			@activeLayer = @children[num]

			@emit "change:active", num, @options[num], @children[num]


