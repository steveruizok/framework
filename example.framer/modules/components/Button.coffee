{ theme } = require "components/Theme"
MODEL = 'button'

class exports.Button extends Layer
	constructor: (options = {}) ->

		@app = options.app

		# ---------------
		# Options
		
		_.defaults options,
			x: 0
			y: 0
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

		@content = new Layer
			name: "Content"
			parent: @
			width: 999
			height: @height
			backgroundColor: null
			
		@textLayer = new H5
			name: 'TextLayer'
			parent: @content
			y: Align.center()
			textAlign: 'center'
			color: @palette.color
			text: options.text ? ''

		Utils.linkProperties @, @textLayer, "color"


		if options.icon? # show our icon...
			
			@iconLayer = new Icon
				name: 'Icon'
				parent: @content
				y: Align.center()
				width: 24
				height: 24
				color: @palette.color
				icon: options.icon
			
			Utils.linkProperties @, @iconLayer, "color"
			
			if @textLayer.text.length > 0
				_.assign @textLayer,
					x: @iconLayer.maxX + 8
					padding: {right: 4}

			@content.width = _.maxBy(@content.children, 'maxX').maxX

			if options.width
				@content.x = Align.center()
			else
				@content.x = 20
				@width = @content.width + 40
			
			@on "change:width", =>
				@content.x = Align.center()

			

		else # if there's no icon...

			if options.width
				@content.width = @width
				@content.x = 0
				@textLayer.point = Align.center()
			else
				@content.width = @textLayer.width
				@content.x = 22
				@width = @content.width + 44

			@on "change:width", =>
				@content.x = 0
				@content.width = @width
				@textLayer.point = Align.center()


		# Fix position, now that we have our size

		@props =
			parent: parent
			x: options.x ? 0
			y: options.y ? 0

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


		if Utils.isMobile()
			@onTap @_doSelect

		else

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
		
		if isTouching
			# show touching
			@_isTouching = true
			@theme = "touched"
			return
		
		# show not touching
		return if not @_isTouching
		@_isTouching = false
		@theme = "default"

		unless silent then @_doSelect(event)

	# ---------------
	# Public Methods
	
	onSelect: (callback) => @select = callback
