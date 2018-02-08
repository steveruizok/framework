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


exports.app = undefined

class window.App extends FlowComponent
	constructor: (options = {}) ->

		_.defaults options,
			backgroundColor: white
			title: 'www.framework.com'
			chrome: 'ios'

		if not options.safari
			options.title = ''

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
			views: []

		# layers

		@loadingLayer = new Layer 
			name: '.'
			size: 48
			backgroundColor: grey
			borderRadius: 16
			opacity: .8

		Utils.bind @loadingLayer, ->
			@iconLayer = new SVGLayer
				parent: @
				size: 32
				point: Align.center(-1)
				svg: """<svg version="1.1" id="loader-1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
					width="#{Utils.px(32)}" height="#{Utils.px(32)}" viewBox="0 0 50 50" style="enable-background:new 0 0 50 50;" xml:space="preserve">
						<path fill="#000" d="M25.251,6.461c-10.318,0-18.683,8.365-18.683,18.683h4.068c0-8.071,6.543-14.615,14.615-14.615V6.461z">
							<animateTransform attributeType="xml"
								attributeName="transform"
								type="rotate"
								from="0 25 25"
								to="360 25 25"
								dur="0.6s"
								repeatCount="indefinite"/>
						</path>
					</svg>"""
				fill: white


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

		try next.load(@, next, prev)
		
	
	# Reset the previous View after transitioning
	_updatePrevious: (prev, next) =>
		return if not prev

		try prev.unload(@, next, prev)

	__show: (nav, layerA, layerB, overlay) ->
		options = {curve: "spring(300, 35, 0)"}
		transition =
			layerA:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: 0 - layerA?.width / 2, y: 0}
			layerB:
				show: {options: options, x: 0, y: 0}
				hide: {options: options, x: layerB.width, y: 0}

	_showLoading: (bool) =>
		if bool
			# show loading
			_.assign @loadingLayer,
				point: Align.center()
				visible: true

			@loadingLayer.bringToFront()
			@ignoreEvents = true
			return

		# show not disabled
		@loadingLayer.visible = false
		@loadingLayer.sendToBack()
		@ignoreEvents = false

	# show next view
	showNext: (layer, options={}) ->
		@_initial ?= layer

		now = _.now()

		@_updateNext(@current, layer)

		if _.now() - now > 100
			@loading = true
			Utils.delay 1.15, => 
				@loading = false
				@transition(layer, @__show, options)
			return

		@transition(layer, @__show, options)