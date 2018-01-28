# Button
{ theme } = require "components/Theme"

class exports.Button extends Layer
	constructor: (options = {}) ->
		@app = options.app
		
		_.defaults options,
			width: 0
			height: 48
			borderRadius: 4
			borderWidth: 1
			shadowY: 2
			shadowBlur: 6
			animationOptions:
				time: .125
			shadowColor: 'rgba(0,0,0,.16)'
			text: 'Get Started'
			dark: false
			secondary: false
			disabled: false
			icon: undefined
			select: => null
			theme: 'default'
			animationOptions:
				time: .2

		# light primary
		if !options.dark and !options.secondary
			@palette = 'light_primary'
		else if !options.dark and options.secondary
			@palette = 'light_secondary'
		else if options.dark and !options.secondary
			@palette = 'dark_primary'
		else if options.dark and options.secondary
			@palette = 'dark_secondary'

		parent = options.parent
		delete options.parent

		super options
			
		@textLayer = new H5
			textAlign: 'center'
			color: @palette.color
			text: options.text

		# Show icon?

		if options.icon?
			
			@iconLayer = new Icon
				parent: @
				width: 24
				height: 24
				color: @palette.color
				icon: options.icon
				
			@textLayer.x = @iconLayer.maxX + 8
			
			if width
				@width = width
				contentWidth = @iconLayer.width + 8 + @textLayer.width
				@iconLayer.x = (width - contentWidth / 2)
				@textLayer.x = @iconLayer.maxX + 8
			else
				Utils.contain(@, {top: 16, bottom: 11, left: 20, right: 28})

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
	

		@on "change:color", => 
			@textLayer.color = @color
			@iconLayer?.color = @color


		# Definitions

		Utils.define @, 'theme', 'default', @_setTheme
		Utils.define @, 'dark', options.dark
		Utils.define @, 'secondary', options.secondary
		Utils.define @, 'disabled', options.disabled, @_showDisabled
		Utils.define @, 'hovered', false, @_showHovered
		Utils.define @, 'select', options.select


		# Events

		@onMouseEnter => @hovered = true
		@onMouseLeave => @hovered = false

		@onTouchStart => @_showTouching(true)
		@onTouchEnd => @_showTouching(false)

		@onTap @_showTapped
		@onPan @_panOffTouch

		for child in @children
			if !options.showNames
				child.name = '.'

	# private

	_setTheme: (value) =>
		@animate theme.button[@palette][value]

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

	_doSelect: =>
		return if @disabled

		@select()

	_panOffTouch: (event) => 
		return if @_isTouching is false
		return if @disabled

		if Math.abs(event.offset.x) > @width/2 or
		Math.abs(event.offset.y) > @height/2
			@theme = "default"

	_showTapped: =>
		return if @disabled
		return if @_isTouching is true

		@theme = "touched"
		Utils.delay .15, => @theme = "default"


	_showTouching: (isTouching, silent = false) =>
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

		unless silent then @_doSelect()

	# public

	onSelect: (callback) => @select = callback
