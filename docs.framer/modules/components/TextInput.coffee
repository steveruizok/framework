Theme = require "components/Theme"
theme = undefined

MODEL = 'textInput'

class exports.TextInput extends Layer
	constructor: (options = {}) ->
		theme = Theme.theme
		@__constructor = true
		@__instancing = true

		# TODO
		# * Scroll to Input when on a mobile device (with screen keyboard)

		# ---------------
		# Options

		_.defaults options,
			name: 'TextInput'
			width: 260

			password: false
			placeholder: "Placeholder"
			disabled: false
			clip: true
			value: ''
			leftIcon: null
			rightIcon: null
			animationOptions:
				time: .15

		if options.label then throw "Make a Label instance separately!"
		delete options.label

		_.assign options,
			height: theme[MODEL].default.height ? 48

		@customOptions =
			color: options.color
			backgroundColor: options.backgroundColor

		super options

		_.assign @,
			placeholder: options.placeholder

		# ---------------
		# Layers

		@textLayer = new Body2
			name: '.'
			parent: @
			color: @color
			y: Align.center()
			width: @width
			padding: theme[MODEL].default.padding ? 12
			backgroundColor: 'none'
			fontFamily: theme[MODEL].default.fontFamily ? "Helvetica"
			fontSize: options.fontSize ? theme[MODEL].default.fontSize ? 13
			textAlign: options.textAlign ? theme[MODEL].default.textAlign ? "left"
			textTransform: options.textTransform ? theme[MODEL].default.textTransform ? "none"
			text: @placeholder

		Utils.linkProperties @, @textLayer, "color"

		# Icons

		@leftIconLayer = new Icon
			name: "Left Icon"
			parent: @
			x: 12
			y: Align.center()
			icon: "none"
			visible: false

		@rightIconLayer = new Icon
			name: "Right Icon"
			parent: @
			x: Align.right(-12)
			y: Align.center()
			icon: "none"
			visible: false

		Utils.constrain(@leftIconLayer, 'left')
		Utils.constrain(@rightIconLayer, 'right')
		Utils.linkProperties @, @leftIconLayer, "color"
		Utils.linkProperties @, @rightIconLayer, "color"
		
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
			backgroundColor: 'rgba(0,0,0,0)'
			textAlign: options.textAlign ? theme[MODEL].default.textAlign ? "left"
			textTransform: options.textTransform ? theme[MODEL].default.textTransform ? "none"
			fontFamily: options.fontFamily ? theme.typography.Body2.fontFamily ? "Helvetica"
			fontSize: Utils.px(options.fontSize ? theme.typography.Body2.fontSize ? 13)
			fontWeight: options.fontWeight ? theme[MODEL].default.fontWeight ? theme.typography.Body2.fontWeight ? 500
			
		# must be set before theme changes

		Utils.linkProperties @, @_input.style, "color"
		Utils.linkProperties @, @_input.style, "backgroundColor"

		@_setTheme('default')

		# ---------------
		# Definitions

		delete @__constructor

		#				Property	Initial value 		Callback 		Validation	Error
		Utils.define @, 'theme', 	'default', 			@_setTheme, 	_.isString, 'TextInput.theme must be a string.'
		Utils.define @, 'hovered', 	false, 				@_showHovered, 	_.isBoolean, 'TextInput.hovered must be a boolean.'
		Utils.define @, 'focused', 	false,				@_showFocused, 	_.isBoolean, 'TextInput.focused must be a boolean.'
		Utils.define @, 'disabled',	options.disabled,	@_showDisabled,	_.isBoolean, 'TextInput.disabled must be a boolean.'
		Utils.define @, 'password',	options.password,	@_setPassword,	_.isBoolean, 'TextInput.password must be a boolean.'
		Utils.define @, 'leftIcon',	options.leftIcon,	@_setIcons,		_.isString,	 'TextInput.leftIcon must be a string.'
		Utils.define @, 'rightIcon',options.rightIcon,	@_setIcons,		_.isString,	 'TextInput.rightIcon must be a string.'
		
		delete @__instancing

		# ---------------
		# Events
		
		# @onMouseOver => @hovered = true
		# @onMouseOut => @hovered = false
		
		@_input.oninput = @_setValue
		@_input.onblur = => 
			@app.focused = null
			@focused = false
		@_input.onfocus = => 
			@app.focused = @_input
			@focused = true

		_.assign @,
			value: options.value

		# ---------------
		# Cleanup
		
		child.name = '.' for child in @children unless options.showSublayers

	# ---------------
	# Private Functions
	
	_setPassword: (bool) =>
		if bool
			@_input.setAttribute "type", "password"
			return

		@_input.setAttribute "type", "text"
	

	_setValue: () =>
		value = @_input.value
		@emit "change:value", value, @


	_setTheme: (value) =>
		@animateStop()
		props = _.defaults _.clone(@customOptions), theme[MODEL][value]
		if @__instancing then @props = props else @animate props


	_setIcons: =>
		defaultPadding = theme["textInput"].default.padding ? 12
		padding =
			top: defaultPadding
			left: defaultPadding
			right: defaultPadding
			bottom: defaultPadding

		newPadding = _.clone(padding)

		_.assign @leftIconLayer, 
			visible: @leftIcon?
			icon: @leftIcon

		if @leftIcon? then newPadding.left = defaultPadding + 36
		
		_.assign @rightIconLayer, 
			visible: @rightIcon?
			icon: @rightIcon

		if @rightIcon? then newPadding.right = defaultPadding + 36


		@textLayer.padding = newPadding
		_.assign @_input.style,
			width: Utils.px(@width - (newPadding.right + newPadding.left))
			paddingRight: Utils.px(newPadding.right)
			paddingLeft: Utils.px(newPadding.left)


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
	# Public Functions
	
	forceBlur: => 
		@_input?.blur()

	# ---------------
	# Special Definitions

	@define "value",
		get: -> return @_input.value
		set: (value) ->
			return if @__constructor
			
			@_input.value = value ? ""
			@textLayer.visible = @value is ""
			@emit "change:value", value, @
