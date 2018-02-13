{ theme } = require 'components/Theme'

MODEL = 'textInput'

class exports.TextInput extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options

		@app = options.app

		_.defaults options,
			name: 'TextInput'
			width: 260
			placeholder: "Placeholder"
			disabled: false
			value: ''
			animationOptions:
				time: .15

		if options.label then throw "Make a Label instance separately!"
		delete options.label

		_.assign options,
			height: 48

		@customOptions =
			color: options.color
			backgroundColor: options.backgroundColor
		
		@__constructor = true

		super options

		_.assign @,
			placeholder: options.placeholder

		# ---------------
		# Layers

		@textLayer = new Body1
			name: '.'
			parent: @
			color: @color
			y: Align.center()
			width: @width
			padding: theme[MODEL].default.padding ? 12
			backgroundColor: theme[MODEL].default.backgroundColor ? white
			fontFamily: theme[MODEL].default.fontFamily ? "Helvetica"
			fontSize: options.fontSize ? theme[MODEL].default.fontSize ? 13
			textAlign: options.textAlign ? theme[MODEL].default.textAlign ? "left"
			textTransform: options.textTransform ? theme[MODEL].default.textTransform ? "none"
			text: @placeholder

		Utils.linkProperties @, @textLayer, "color"
		
		# Input
		
		@_input = document.createElement 'input'
		@_element.appendChild @_input

		_.assign @_input,
			# placeholder: options.placeholder
			value: options.value ? null
			className: @name

		for attr in ["autocorrect", "autocomplete", "autocapitalize", "spellcheck"]
			@_input.setAttribute attr, "off"

		_.assign @_input.style,
			width: Utils.px(@width - 24)
			height: Utils.px(@height)
			padding: "0 #{Utils.px(theme[MODEL].default.padding ? 12)}"
			backgroundColor: theme[MODEL].default.backgroundColor ? white
			fontFamily: theme[MODEL].default.fontFamily ? "Helvetica"
			fontSize: options.fontSize ? Utils.px(theme[MODEL].default.fontSize) ? 13
			textAlign: options.textAlign ? theme[MODEL].default.textAlign ? "left"
			textTransform: options.textTransform ? theme[MODEL].default.textTransform ? "none"

		# must be set before theme changes

		Utils.linkProperties @, @_input.style, "color"
		Utils.linkProperties @, @_input.style, "backgroundColor"

		@_setTheme('default')

		# ---------------
		# Definitions
		
		@__instancing = true

		Utils.defineValid @, 'theme', 'default', _.isString, 'TextInput.theme must be a string.', @_setTheme
		Utils.defineValid @, 'hovered', false, _.isBoolean, 'TextInput.hovered must be a boolean.', @_showHovered
		Utils.defineValid @, 'focused', false, _.isBoolean, 'TextInput.focused must be a boolean.',  @_showFocused
		Utils.defineValid @, 'disabled', options.disabled, _.isBoolean, 'TextInput.disabled must be a boolean.',  @_showDisabled
		
		delete @__constructor
		delete @__instancing

		# ---------------
		# Events
		
		@onMouseOver => @hovered = true
		@onMouseOut => @hovered = false
		@_input.oninput = @_setValue
		@_input.onblur = => @focused = false
		@_input.onfocus = => @focused = true

		@value = options.value

	# ---------------
	# Private Functions
	
	_setValue: () =>
		value = @_input.value
		@emit "change:value", value, @

	_setTheme: (value) =>
		@animateStop()
		props = _.defaults _.clone(@customOptions), theme[MODEL][value]
		if @__instancing then @props = props else @animate props

	_showHovered: (bool) =>
		return if @disabled or @focused

		if bool # hovered is true
			@theme = "hovered"
			return

		# hovered is false
		@theme = "default"
	
	_showFocused: (bool) =>
		return if @disabled

		if bool # focused is true
			@textLayer.visible = false
			@theme = "focused"
			return

		# focused is false
		@textLayer.visible = @value is ""
		@theme = "default"

	_showDisabled: (bool) =>
		if bool # disabled is true
			@theme = "disabled"
			@ignoreEvents = true
			@_input.disabled = true
			return

		# focused is false
		@theme = "default"
		@ignoreEvents = false
		@_input.disabled = false


	# ---------------
	# Special Definitions

	@define "value",
		get: -> return @_input.value
		set: (value) ->
			return if @__constructor
			
			@_input.value = value
			@emit "change:value", value, @
