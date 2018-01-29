{ theme } = require 'components/Theme'

class exports.TextInput extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options

		@app = options.app

		_.defaults options,
			name: 'TextInput'
			width: 260
			theme: 'default'
			hovered: false
			focused: false
			placeholder: "Placeholder"
			animationOptions:
				time: .15

		if options.label then throw "Make a Label instance separately!"
		delete options.label

		_.assign options,
			height: 48

		@customOptions =
			color: options.color
			backgroundColor: options.backgroundColor
		
		super options

		# ---------------
		# Layers
		
		# Input
		
		@_input = document.createElement 'input'
		@_element.appendChild @_input

		_.assign @_input,
			placeholder: options.placeholder
			value: options.value ? null

		for attr in ["autocorrect", "autocomplete", "autocapitalize", "spellcheck"]
			@_input.setAttribute attr, "off"

		_.assign @_input.style,
			width: Utils.px(@width - 24)
			height: Utils.px(@height)
			backgroundColor: white
			fontFamily: 'Helvetica'
			fontSize: Utils.px(13)
			padding: "0 #{Utils.px(12)}"

		# must be set before theme changes

		Utils.linkProperties @, @_input, "color"

		@_setTheme('default')

		# ---------------
		# Definitions

		@__instancing = true

		Utils.defineValid @, 'theme', options.theme, _.isString, 'TextInput.theme must be a string.', @_setTheme
		Utils.defineValid @, 'hovered', options.hovered, _.isBoolean, 'TextInput.hovered must be a boolean.', @_showHovered
		Utils.defineValid @, 'focused', options.focused, _.isBoolean, 'TextInput.focused must be a boolean.',  @_showFocused

		delete @__instancing

		# ---------------
		# Events
		
		@onMouseEnter => @hovered = true
		@onMouseLeave => @hovered = false
		@_input.oninput = @_setValue
		@_input.onblur = => @focused = false
		@_input.onfocus = => @focused = true

	# ---------------
	# Private Functions
	
	_setValue: () =>
		value = @_input.value
		@emit "change:value", value, @

	_setTheme: (value) =>
		@animateStop()
		props = _.defaults _.clone(@customOptions), theme.textInput[value]
		if @__instancing then @props = props else @animate props

	
	_showHovered: (bool) =>
		return if @focused

		if bool # hovered is true
			@theme = "hovered"
			return

		# hovered is false
		@theme = "default"
	
	_showFocused: (bool) =>
		if bool # focused is true
			@theme = "focused"
			return

		# focused is false
		@theme = "default"

	# ---------------
	# Special Definitions

	@define "value",
		get: -> return @_input.value
		set: (value) ->
			@_input.value = value
			@emit "change:value", value, @
