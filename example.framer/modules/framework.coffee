require 'moreutils'

require 'components/Colors'
require 'components/Theme'
require 'components/Typography'

# disable hints
Framer.Extras.Hints.disable()

# dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"


{ Button } = require 'components/Button'
{ Radiobox } = require 'components/Radiobox'
{ Checkbox } = require 'components/Checkbox'
{ Footer } = require 'components/Footer'
{ Header } = require 'components/Header'
{ Segment } = require 'components/Segment'
{ Toggle } = require 'components/Toggle'
{ Tooltip } = require 'components/Tooltip'
{ Icon } = require 'components/Icon'
{ Link } = require 'components/Link'
{ Separator } = require 'components/Separator'
{ Select } = require 'components/Select'
{ Stepper } = require 'components/Stepper'
{ TextInput } = require 'components/TextInput'
{ View } = require 'components/View'
{ CarouselComponent } = require 'components/CarouselComponent'
{ PageTransitionComponent } = require 'components/PageTransitionComponent'
{ SortableComponent } = require 'components/SortableComponent'
{ TransitionPage } = require 'components/PageTransitionComponent'

exports.defaultTitle = defaultTitle = "www.framework.com"

exports.app = undefined

class window.App extends FlowComponent
	constructor: (options = {}) ->

		_.defaults options,
			backgroundColor: white
			title: defaultTitle
			chrome: 'ios'
			contentWidth: Screen.width

		# Add general components to window
		for componentName in [
			'Button', 
			'Header', 
			'Radiobox',
			'Checkbox',
			'Toggle',
			'Tooltip',
			'Select',
			'Icon', 
			'Stepper', 
			'Segment',
			'TextInput',
			'Link', 
			'Separator', 
			'TransitionPage', 
			'View', 
			'CarouselComponent', 
			'SortableComponent'
			'PageTransitionComponent'
		]
			c = eval(componentName)
			do (componentName, c) =>
				window[componentName] = (options = {}) =>
					_.assign(options, {app: @})
					return new c(options)

		super options

		exports.app = @

		_.assign @,
			chrome: options.chrome
			_windowFrame: {}
			views: []
			contentWidth: Screen.width

		# Transition
		 
		@_platformTransition = switch @chrome
			when "safari"
				@_safariTransition
			when "ios"
				@_iosTransition
			else
				@_defaultTransition

		# layers

		@loadingLayer = new Layer 
			name: '.'
			size: 48
			backgroundColor: 'rgba(0,0,0,.64)'
			borderRadius: 8
			opacity: .8
			backgroundBlur: 30
			visible: false

		@loadingLayer.sendToBack()

		Utils.bind @loadingLayer, ->
			@iconLayer = new Icon 
				parent: @
				height: 32
				width: 32
				point: Align.center()
				style:
					lineHeight: 1
				color: white
				icon: "loading"

			anim = new Animation @iconLayer,
				rotation: 360
				options:
					curve: "linear"
					looping: true

			anim.start()


		# header

		if @chrome
			# don't show safari bar when opening this project on mobile web
			# ... but this might require a lot of app.header?.etc
			if @chrome is 'safari' and Utils.isSafari()
				@chrome = null

			@header = new Header
				app: @
				safari: @chrome is 'safari'
				title: options.title
		
			if @chrome is 'safari'
				@footer = new Footer 
					app: @

				@onSwipeUpEnd =>
					@header._collapse()
					@footer._collapse()

				@onSwipeDownEnd =>
					@header._expand()
					@footer._expand()

		@header?.on "change:height", @_setWindowFrame
		@footer?.on "change:height", @_setWindowFrame

		@_setWindowFrame()

		# definitions
		Utils.defineValid @, 'loading', false, _.isBoolean, "App.loading must be a boolean (true or false).", @_showLoading

		# when transition starts, update the header
		@onTransitionStart @_updateHeader

		# when transition ends, reset the previous view
		@onTransitionEnd @_updatePrevious

		Screen.on Events.EdgeSwipeLeftEnd, @showPrevious

	# ---------------
	# Private Methods
	
	_updateHeader: (prev, next) =>
		# header changes
		return if not @header

		hasPrevious = prev? and next isnt @_stack[0]?.layer

		# safari changes
		if @header.safari
			@footer.hasPrevious = hasPrevious
			return

		# ios changes
		@header.backIcon.visible = hasPrevious
		@header.backText.visible = hasPrevious
		
		if next.title 
			@header.updateTitle(next.title)

	# Update the next View before transitioning
	_updateNext: (prev, next) =>
		return if not next

		next._loadView(@, next, prev)
		
	
	# Reset the previous View after transitioning
	_updatePrevious: (prev, next) =>
		return if not prev
		prev.sendToBack()
		prev._unloadView(@, next, prev)

	_safariTransition: (nav, layerA, layerB, overlay) =>
		options = {time: 0.01}
		transition =
			layerA:
				show: {options: options, x: Align.center(), brightness: 100, y: @windowFrame.y}
				hide: {options: options, x: Align.center(), brightness: 101, y: @windowFrame.y}
			layerB:
				show: {options: options, x: Align.center(), brightness: 100, y: @windowFrame.y}
				hide: {options: options, x: Align.center(), brightness: 101, y: @windowFrame.y}

	_iosTransition: (nav, layerA, layerB, overlay) =>
		options = {curve: "spring(300, 35, 0)"}
		transition =
			layerA:
				show: {options: options, x: Align.center(), y: @windowFrame.y}
				hide: {options: options, x: 0 - layerA?.width / 2, y: @windowFrame.y}
			layerB:
				show: {options: options, x: Align.center(), y: @windowFrame.y}
				hide: {options: options, x: @width + layerB.width / 2, y: @windowFrame.y}

	_defaultTransition: (nav, layerA, layerB, overlay) =>
		options = {curve: "spring(300, 35, 0)"}
		transition =
			layerA:
				show: {options: options, x: Align.center(), y: @windowFrame.y}
				hide: {options: options, x: 0 - layerA?.width / 2, y: @windowFrame.y}
			layerB:
				show: {options: options, x: Align.center(), y: @windowFrame.y}
				hide: {options: options, x: @width + layerB.width / 2, y: @windowFrame.y}

	_setWindowFrame: =>
		@_windowFrame = {
			y: (@header?.height ? 0)
			x: @x
			maxX: @maxX
			maxY: @height - (@footer?.height ? 0)
			height: @height - (@footer?.height ? 0) - (@header?.height - 0)
			width: @width
			size: {
				height: @height - (@footer?.height ? 0) - (@header?.height - 0)
				width: @width
			}
		}

		@emit "change:windowFrame", @_windowFrame, @

	_showLoading: (bool) =>
		if @chrome is 'safari'
			@header._expand()
			@footer._expand()

		if bool
			# show safari loading
			if @chrome is "safari"
				@header._showLoading(true)
				return

			# show ios loading
			_.assign @loadingLayer,
				point: Align.center()
				visible: true

			@loadingLayer.bringToFront()
			@ignoreEvents = true
			return

		# show safari loading ended
		if @chrome is "safari"
			@header._showLoading(false)
			return

		# show ios loading
		@loadingLayer.visible = false
		@loadingLayer.sendToBack()
		@ignoreEvents = false

	# ---------------
	# Public Methods

	# show next view
	showNext: (layer, loadingTime, options={}) ->
		@_initial ?= layer

		if @chrome is "safari" then loadingTime ?= _.random(.5, .75)

		@_updateNext(@current, layer)

		# if loading time specified...
		if loadingTime?
			@loading = true
			Utils.delay loadingTime, =>
				@loading = false
				@transition(layer, @_platformTransition, options)
			return

		# otherwise, show next
		@transition(layer, @_platformTransition, options)

	showPrevious: (options={}) =>
		return unless @previous
		return if @isTransitioning

		# Maybe people (Jorn, Steve for sure) pass in a layer accidentally
		options = {} if options instanceof(Framer._Layer)
		options = _.defaults({}, options, {count: 1, animate: true})

		if options.count > 1
			count = options.count
			@showPrevious(animate: false, count: 1) for n in [2..count]

		previous = @_stack.pop()
		current = @current
		try current._loadView()
		
		if @chrome is "safari"
			@loading = true
			loadingTime = _.random(.3, .75)
			Utils.delay loadingTime, =>
				@loading = false
				@_runTransition(previous?.transition, "back", options.animate, current, previous.layer)
			return


		@_runTransition(previous?.transition, "back", options.animate, current, previous.layer)

	@define "windowFrame",
		get: -> return @_windowFrame