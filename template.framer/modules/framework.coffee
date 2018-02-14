require 'moreutils'

require 'components/Colors'
require 'components/Theme'
require 'components/Typography'


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

			@header.on "change:height", => @_setWindowFrame
		
			if @chrome is 'safari'
				@footer = new Footer 
					app: @

				@footer.on "change:height", => @_setWindowFrame


		@_setWindowFrame()

		# definitions
		Utils.defineValid @, 'loading', false, _.isBoolean, "App.loading must be a boolean (true or false).", @_showLoading

		# when transition starts, update the header
		@onTransitionStart @_updateHeader

		# when transition ends, reset the previous view
		@onTransitionEnd @_updatePrevious

		Screen.on Events.EdgeSwipeLeftEnd, @showPrevious
	
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

		prev._unloadView(@, next, prev)

	_safariTransition: (nav, layerA, layerB, overlay) ->
		options = {time: 0, delay: .15}
		transition =
			layerA:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: 0 - layerA?.width / 2, y: 0}
			layerB:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: layerB.width, y: 0}

	__show: (nav, layerA, layerB, overlay) ->
		options = {curve: "spring(300, 35, 0)"}
		transition =
			layerA:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: 0 - layerA?.width / 2, y: 0}
			layerB:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: layerB.width, y: 0}

	_setWindowFrame: =>
		@_windowFrame = {
			y: (@header?.maxY ? @y)
			x: @x
			height: @height - (@footer?.height ? 0) - (@header?.height - 0)
			width: @width
			size: {
				height: @height - (@footer?.height ? 0) - (@header?.height - 0)
				width: @width
			}
		}

		@emit "change:windowFrame", @_windowFrame, @

	_showLoading: (bool) =>

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



	# show next view
	showNext: (layer, loadingTime, options={}) ->
		@_initial ?= layer

		now = _.now()

		transition = switch @chrome
			when "safari"
				loadingTime ?= _.random(.5, .75)
				@_safariTransition
			else
				@__show

		# transition = @__show

		@_updateNext(@current, layer)

		# if loading time specified...
		if loadingTime?
			@loading = true
			Utils.delay loadingTime, =>
				@loading = false
				@transition(layer, transition, options)
			return

		# otherwise, show next
		@transition(layer, transition, options)

	@define "windowFrame",
		get: -> return @_windowFrame