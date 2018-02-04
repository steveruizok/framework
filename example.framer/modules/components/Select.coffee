{ theme } = require 'components/Theme'

MODEL = "select"
OPTION_MODEL = "option"

class exports.Select extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options
		
		@app = options.app

		_.defaults options,
			name: 'Select'
			height: 48
			clip: false
			animationOptions:
				time: .2
				colorModel: 'husl'

			options: ['Rafael', 'Michelangelo', 'Donatello', 'Leonardo']
			selectedIndex: 0
			disabled: false

		@customTheme = undefined
		@customOptions = {}

		super options

		_.assign @,
			options: options.options
			optionElements: []
			optionLayers: []

		# ---------------
		# Layers

		# SelectedContent

		@textLayer = new Body2
			name: '.'
			parent: @
			width: @width
			x: 12
			y: Align.center()
			text: @options[options.selectedIndex]
		
		# Input
		
		@_input = document.createElement 'select'
		@_element.appendChild @_input

		_.assign @_input.style,
			width: Utils.px(@width)
			height: Utils.px(@height)
			'-webkit-appearance': 'none'

		last = 0

		# option layer container
		@optionContainer = new Layer
			name: '.'
			parent: @
			width: @width
			y: @height
			visible: false
			clip: true
			animationOptions:
				time: .2

		@optionContainer.props = @customTheme?["default"] ? _.defaults(
			_.clone(@customOptions), 
			theme[MODEL]["default"]
			)

		# create option layers
		@optionLayers = _.map options.options, (option, i) =>
			opLayer = new Option
				name: '.'
				handler: @
				parent: @optionContainer
				y: last
				element: @optionElements[i]
				index: i
				value: option

			last += opLayer.height - 1

			return opLayer

		_.assign @optionContainer,
			minHeight: 1
			maxHeight: last

		# create icon layer
		@iconLayer = new Icon
			name: '.'
			parent: @
			x: Align.right(-8)
			y: Align.center
			icon: 'menu-down'

		# must be set before theme changes

		Utils.linkProperties @, @textLayer, "color"
		Utils.linkProperties @, @iconLayer, "color"

		@_setTheme('default')

		# ---------------
		# Definitions

		@__instancing = true

		Utils.defineValid @, 'opened', false, _.isBoolean, "Select.opened must be a boolean (true or false).", @_setOpened
		Utils.defineValid @, 'theme', 'default', _.isString, 'Select.theme must be a string.', @_setTheme
		Utils.defineValid @, 'hovered', false, _.isBoolean, 'Select.hovered must be a boolean.', @_showHovered
		Utils.defineValid @, 'focused', false, _.isBoolean, 'Select.focused must be a boolean.',  @_showFocused
		Utils.defineValid @, 'disabled', options.disabled, _.isBoolean, 'Select.disabled must be a boolean.',  @_showDisabled
		Utils.defineValid @, 'selectedIndex', options.selectedIndex, _.isNumber, "Select.selectedIndex must be a number.", @_setSelected

		delete @__instancing

		# ---------------
		# Events
		
		@onMouseEnter => @hovered = true
		@onMouseLeave => @hovered = false
		@_input.oninput = @_setValue
		@_input.onblur = => @focused = false; @opened = false
		@_input.onfocus = => @focused = true; @opened = true

	# ---------------
	# Private Methods

	_setOpened: (bool) =>
		if bool
			# opened is true
			_.assign @optionContainer,
				parent: null
				y: @screenFrame.y + @height + 2
				x: @screenFrame.x
				visible: true

			@optionContainer.animate
				height: @optionContainer.maxHeight
			return

		# opened is false

		@optionContainer.once Events.AnimationEnd, =>
			_.assign @optionContainer,
				parent: @
				y: 0
				x: 0
				visible: false

		@optionContainer.animate
			height: @optionContainer.minHeight

	_setSelected: (selectedIndex) =>
		if -1 > selectedIndex > @optionLayers.length
			throw 'Selected.selectedIndex must be more an -1 or less than its number of options.'
		
		@_setValue(@optionLayers[selectedIndex].value)

	_setValue: (value) =>
		@textLayer.text = value
		@emit "change:value", value, @

	# generic

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
			@theme = "focused"
			return

		# focused is false
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
	# Public Methods


	# ---------------
	# Special Definitions

	@define "value",
		get: -> return @textLayer.text


class Option extends Layer
	constructor: (options = {}) ->

		_.defaults options, _.merge(
			theme[OPTION_MODEL].default, {
				name: '.'
				animationOptions:
					time: .2
				}
			)

		super options

		_.assign @,
			handler: options.handler
			element: options.element
			index: options.index
			value: options.value
		
		# ---------------
		# Layers

		@textLayer = new Body2
			x: 12
			y: 8
			text: @value

		_.assign @,
			height: @textLayer.maxY + 8
			width: @parent.width

		@textLayer.parent = @
		
		# ---------------
		# Definitions
		
		Utils.defineValid @, 'theme', 'default', _.isString, 'Select.theme must be a string.', @_setTheme
		Utils.defineValid @, 'hovered', false, _.isBoolean, 'Select.hovered must be a boolean.', @_showHovered
		
		# ---------------
		# Events

		@onMouseEnter => @hovered = true
		@onMouseLeave => @hovered = false
		
		@onTap (event) =>
			return if Math.abs(event.offset.x > 12) or Math.abs(event.offset.y > 12)
			@handler.selectedIndex = @index
	
	# ---------------
	# Private Methods

	_setTheme: (value) =>
		@animateStop()
		props = theme[OPTION_MODEL][value]

		if @__instancing then @props = props else @animate props

	_showHovered: (bool) =>
		if bool # hovered is true
			@theme = "hovered"
			return

		# hovered is false
		@theme = "default"