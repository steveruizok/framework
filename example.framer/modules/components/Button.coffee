{ theme } = require "components/Theme"
MODEL = 'button'

class exports.Button extends Layer
	constructor: (options = {}) ->

		@app = options.app

		# ---------------
		# Options
		
		_.defaults options,
			width: 0
			height: 48
			text: 'Get Started'
			animationOptions:
				time: .2
				colorModel: 'husl'

			dark: false
			secondary: false
			disabled: false
			icon: undefined
			select: => null

		# light primary
		if !options.dark and !options.secondary
			@palette = 'light_primary'
		else if !options.dark and options.secondary
			@palette = 'light_secondary'
		else if options.dark and !options.secondary
			@palette = 'dark_primary'
		else if options.dark and options.secondary
			@palette = 'dark_secondary'

		@customTheme = if options.backgroundColor? and options.color? then @_getCustomTheme(options.color, options.backgroundColor) else undefined
		
		@customOptions =
			color: options.color
			backgroundColor: options.backgroundColor

		parent = options.parent
		delete options.parent

		super options

		# ---------------
		# Layers
			
		@textLayer = new H5
			name: '.'
			textAlign: 'center'
			color: @palette.color
			text: options.text ? ''

		Utils.linkProperties @, @textLayer, "color"

		# Show icon?

		if options.icon?
			
			@iconLayer = new Icon
				parent: @
				name: '.'
				width: 24
				height: 24
				y: Align.center()
				color: @palette.color
				icon: options.icon
			
			Utils.linkProperties @, @iconLayer, "color"

			contentWidth = @iconLayer.width
			if options.text?.length > 0 then contentWidth += 8 + @textLayer.width

			if options.width
				@width = options.width
				@iconLayer.x = (@width - contentWidth / 2)
				@textLayer.x = @iconLayer.maxX + 8
			else
				@iconLayer.x = 20
				@textLayer.x = @iconLayer.maxX + 8
				@width = contentWidth + 40

			_.assign @textLayer,
				parent: @
				y: Align.center()

		else

			unless options.width
				@width = @textLayer.width + 40

			_.assign @textLayer,
				parent: @
				x: Align.center()
				y: Align.center()

			@on "change:width", =>
				_.assign @textLayer,
					x: Align.center()
					y: Align.center()
		
		# Fix position

		_.assign @,
			x: options.x
			y: options.y

		_.assign @,
			parent: parent
			x: options.x
			y: options.y

		@_setTheme('default')

		# ---------------
		# Definitions

		@__instancing = true

		Utils.defineValid @, 'theme', 'default', _.isString, "Button.theme must be a string.", (value) => @_setTheme(value)
		Utils.defineValid @, 'dark', options.dark, _.isBoolean, "Button.dark must be a boolean (true or false).", 
		Utils.defineValid @, 'secondary', options.secondary, _.isBoolean, "Button.secondary must be a boolean (true or false).", 
		Utils.defineValid @, 'disabled', options.disabled, _.isBoolean, "Button.disabled must be a boolean (true or false).", @_showDisabled
		Utils.defineValid @, 'hovered', false, _.isBoolean, "Button.hovered must be a boolean (true or false).", @_showHovered
		Utils.defineValid @, 'select', options.select, _.isFunction, "Button.select must be a function."

		delete @__instancing


		# ---------------
		# Events
		
		@onMouseOver => @hovered = true
		@onMouseOut => @hovered = false

		@onTouchStart (event) => @_showTouching(true, null, event)
		@onTouchEnd (event) => @_showTouching(false, null, event)

		@onTap @_showTapped
		@onPan @_panOffTouch

		for child in @children
			if !options.showNames
				child.name = '.'

	# ---------------
	# Private Methods

	_getCustomTheme: (color, backgroundColor) ->
		color = new Color(color)
		bg = new Color(backgroundColor)

		customTheme =
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
		
		return customTheme

	_setTheme: (value) =>
		@animateStop()
		props = @customTheme?[value] ? _.defaults(_.clone(@customOptions), theme[MODEL][@palette][value])
		if @__instancing then @props = props else @animate props

	_showHovered: (bool) =>
		return if @disabled

		if bool
			# show hovered
			@theme = 'hovered'
			return

		# show not hovered
		@theme = 'default'

	_showDisabled: (bool) =>
		if bool
			# show disabled
			@theme = 'disabled'
			@ignoreEvents = true
			return

		# show not disabled
		@theme = 'default'
		@ignoreEvents = false

	_doSelect: (event) =>
		return if @disabled

		try @select(event, @)
		@emit "select", @

	_panOffTouch: (event) => 
		return if @_isTouching is false
		return if @disabled
		return if @theme is "default"

		if Math.abs(event.offset.x) > @width/2 or
		Math.abs(event.offset.y) > @height/2
			@theme = "default"

	_showTapped: =>
		return if @disabled
		return if @_isTouching is true

		@theme = "touched"
		Utils.delay .1, => @theme = "default"


	_showTouching: (isTouching, silent = false, event) =>
		return if @disabled
		@animateStop()
		
		if isTouching
			# show touching
			@_isTouching = true
			@theme = "touched"
			return
		
		# show not touching
		@_isTouching = false
		@theme = "default"

		unless silent then @_doSelect(event)

	# ---------------
	# Public Methods
	
	onSelect: (callback) => @select = callback
