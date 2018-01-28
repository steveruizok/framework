{ theme } = require 'components/Theme'

theme.textInput =
	default:
		color: gray40
		borderColor: gray40
		backgroundColor: white
		shadowBlur: 0
		shadowColor: 'rgba(0,0,0,.16)'
		borderWidth: 1
		borderRadius: 2
	hovered:
		color: gray
		borderColor: gray
		backgroundColor: white
		shadowBlur: 0
		shadowColor: 'rgba(0,0,0,.16)'
	focused:
		color: black
		borderColor: black20
		backgroundColor: white
		shadowBlur: 6
		shadowColor: 'rgba(0,0,0,.16)'


class exports.TextInput extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options

		@app = options.app

		_.defaults options,
			name: 'TextInput'
			width: 260
			theme: 'default'
			placeholder: "Placeholder"
			animationOptions:
				time: .15

		if options.label then throw "Make a Label instance separately!"
		delete options.label

		_.assign options,
			height: 48
		
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


		# ---------------
		# Definitions

		Utils.define @, 'theme', 'default', @_setTheme
		Utils.define @, 'hovered', options.hovered, @showHovered
		Utils.define @, 'focused', options.focused, @showFocused

		@theme = options.theme

		# ---------------
		# Events
		
		Utils.linkProperties @, @_input, "color"
		
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
		 @animate theme.textInput[value]


	# ---------------
	# Public Functions
	
	showHovered: (bool) =>
		return if @focused

		if bool # hovered is true
			@theme = "hovered"
			return

		# hovered is false
		@theme = "default"
	
	showFocused: (bool) =>
		if bool # focused is true
			@theme = "focused"
			return

		# focused is false
		@theme = "default"

	@define "value",
		get: -> return @_input.value
		set: (value) ->
			@_input.value = value
			@emit "change:value", value, @
