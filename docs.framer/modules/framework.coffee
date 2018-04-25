require 'components/moreutils'
theme = require 'components/Theme'
colors = require 'components/Colors'
typography = require 'components/Typography'
Keyboard = require 'components/Keyboard'

colors.updateColors()

# disable hints
Framer.Extras.Hints.disable()

# get rid of dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"

# Exports for theme support 
_.assign exports,
	defaultTitle: ""
	app: undefined
	components: [
		'Switch'
		'Alert'
		'Button', 
		'Footer'
		'Header', 
		'Radiobox',
		'Checkbox',
		'Container',
		'DocComponent',
		'Toggle',
		'Tooltip',
		'Select',
		'Icon', 
		'Stepper', 
		'Segment',
		'TextInput',
		'Menu',
		'Link', 
		'Separator', 
		'View',
		'Template',
		'Toolbar'
		'FormComponent'
		"ProgressComponent"
		'CarouselComponent', 
		'SafariHeader'
		'SortableComponent'
		'TabComponent'
		'StickyComponent'
		]
	imports: [
		'Transitions'
	]
	globals: []
	theme: theme
	typography: typography
	colors: colors

# import as: { module } = require 'module'
exports.globals.forEach (variable) ->
	mod = require "components/#{variable}"
	window[variable] = mod[variable]

# import as: module = require 'module'
exports.imports.forEach (variable) ->
	mod = require "components/#{variable}"
	window[variable] = mod

# Add components to window
exports.components.forEach (componentName) ->
	mod = require "components/#{componentName}"
	component = mod[componentName]

	window[componentName] = class FrameworkComponent extends component
		constructor: (options = {}) ->
			@app = exports.app
			super options

# ... and finally, the App class
class window.App extends FlowComponent
	constructor: (options = {}) ->

		exports.app = @
		window.app = @

		_.defaults options,
			backgroundColor: white
			title: exports.defaultTitle
			chrome: 'ios'
			contentWidth: Screen.width
			showKeys: true
			perspective: 1000
			screenshot: true
			printErrors: false

		super options

		_.assign @,
			chrome: options.chrome
			showKeys: options.showKeys
			contentWidth: options.contentWidth
			_windowFrame: {}
			views: []
			keyboard: Keyboard
			printErrors: options.printErrors
			preload: new Promise (resolve, reject) -> _.defer resolve
	

		if options.chrome is "browser" and Screen.width isnt 1440
			_.defer ->
				Framer.Device.customize
					deviceType: Framer.Device.Type.Desktop
					devicePixelRatio: 1
					screenWidth: 1440
					screenHeight: 900
					deviceImageWidth: 900
					deviceImageHeight: 1440

				_.assign Framer.Device.screenBackground,
					backgroundColor: null

				_.assign Framer.Device.content, 
					borderWidth: 1
					borderRadius: 4
					backgroundColor: null
					clip: true

				Canvas.backgroundColor = "#1E1E1E"
				
				_.defer ->
					Utils.reset()
					CoffeeScript.load("app.coffee")

		# Transition
		 
		@_platformTransition = switch @chrome
			when "safari"
				@_safariTransition
			when "browser"
				@_safariTransition
			when "ios"
				@_iosTransition
			else
				@_defaultTransition

		# layers

		@loadingLayer = new Layer 
			name: '.'
			size: Screen.size
			backgroundColor: if @chrome is "safari" or @chrome is "browser" then 'rgba(0,0,0,0)' else 'rgba(0,0,0,.14)'
			visible: false

		@loadingLayer._element.style["pointer-events"] = "all"
		@loadingLayer.sendToBack()


		# By this point, these should be different classes...
		unless @chrome is "safari" or @chrome is "browser"
			Utils.bind @loadingLayer, ->
				
				@loadingContainer = new Layer
					name: '.'
					parent: @
					x: Align.center()
					y: Align.center()
					size: 48
					backgroundColor: 'rgba(0,0,0,.64)'
					borderRadius: 8
					opacity: .8
					backgroundBlur: 30

				@iconLayer = new Icon 
					parent: @loadingContainer
					height: 32
					width: 32
					point: Align.center()
					style:
						lineHeight: 1
					color: white
					icon: "loading"

			@loadingAnim = new Animation @loadingLayer.iconLayer,
				rotation: 360
				options:
					curve: "linear"
					looping: true


		# header

		if @chrome
			# don't show safari bar when opening this project on mobile web
			# ... but this might require a lot of app.header?.etc
			if @chrome is 'safari' and Utils.isSafari()
				@chrome = null
			
			if @chrome is "browser"
				@header = new SafariHeader
					title: options.title
			else 
				@header = new Header
					app: @
					safari: @chrome is 'safari'
					title: options.title
			
			if @chrome is 'safari'
				@footer = new Footer 
					app: @

				@onSwipeUpEnd =>
					return unless @current.isMoving
					return if @current.content.draggable.isBeyondConstraints
					
					@header._collapse()
					@footer._collapse()

				@onSwipeDownEnd =>
					return unless @current.isMoving

					@header._expand()
					@footer._expand()

				@header.statusBar.onTap =>
					@header._expand()

			if @chrome is 'ios'

				@onSwipeUpEnd =>
					return unless @current.isMoving 
					return if @current.content.draggable.isBeyondConstraints

					@header._collapse()

				@onSwipeDownEnd =>
					return unless @current.isMoving

					@header._expand()

				@header.statusBar.onTap =>
					@header._expand()

		@header?.on "change:height", @_setWindowFrame
		@footer?.on "change:height", @_setWindowFrame

		@_setWindowFrame()

		# definitions
		Utils.define @, 'focused', 		null, 		@_showFocused,	_.isObject,		"App.focused must be an html element."
		Utils.define @, 'loading', 		false, 		@_showLoading, 	_.isBoolean,	"App.loading must be a boolean (true or false)."
		Utils.define @, 'viewPoint',	{x:0, y:0}, undefined,		_.isObject, 	'App.viewPoint must be an point object (e.g. {x: 0, y: 0}).'
		Utils.define @, 'chromeOpacity', options.chromeOpacity, @_setChromeOpacity, _.isNumber, "App.chromeOpacity must be a number between 0 and 1."

		Screen.on Events.EdgeSwipeLeftEnd, @showPrevious

	# ---------------
	# Private Methods

	_setChromeOpacity: (num) =>
		num = _.clamp(num, 0, 1)
		for layer in [@header, @footer]
			continue if not layer
			layer.opacity = num

	_showFocused: (el) =>
		# possibly... an app state dealing with an on-screen keyboard
		return


	_safariTransition: (nav, layerA, layerB, overlay) =>
		options = {time: 0.01}
		transition =
			layerA:
				show: {options: options, x: Align.center(), brightness: 100}
				hide: {options: options, x: Align.center(), brightness: 109}
			layerB:
				show: {options: options, x: Align.center(), brightness: 100}
				hide: {options: options, x: Align.center(), brightness: 109}


	_iosTransition: (nav, layerA, layerB, overlay) =>
		options = {curve: "spring(300, 35, 0)"}
		transition =
			layerA:
				show: {options: options, x: Align.center()}
				hide: {options: options, x: 0 - layerA?.width / 2}
			layerB:
				show: {options: options, x: Align.center()}
				hide: {options: options, x: @width + layerB.width / 2}


	_defaultTransition: (nav, layerA, layerB, overlay) =>
		options = {curve: "spring(300, 35, 0)"}
		transition =
			layerA:
				show: {options: options, x: Align.center()}
				hide: {options: options, x: 0 - layerA?.width / 2}
			layerB:
				show: {options: options, x: Align.center()}
				hide: {options: options, x: @width + layerB.width / 2}


	_setWindowFrame: =>
		headerMaxY = @header?._expandProps?.height ? @header?.height ? 0
	
		@_windowFrame =
			expandY: headerMaxY
			y: (@header?.height ? 0)
			x: @x
			maxX: @maxX
			maxY: @height - (@footer?.height ? 0)
			height: @height - (@footer?.height ? 0) - headerMaxY
			width: @width
			size:
				height: @height - (@footer?.height ? 0) - (@header?.height ? 0)
				width: @width

		@emit "change:windowFrame", @_windowFrame, @



	_showLoading: (bool) =>
		if bool
			@focused?.blur()
			@loadingLayer.visible = true
			@loadingLayer.bringToFront()
			@loadingAnim?.restart()

			# show safari loading
			if @chrome is "safari" or @chrome is "browser"
				try @footer?._expand()
				try @header?._expand()
				@header?._showLoading(true)
				return

			# show ios loading
			return

		@loadingLayer.visible = false
		@loadingLayer.sendToBack()
		@loadingAnim?.stop()

		# show safari loading ended
		if @chrome is "safari" or @chrome is "browser"
			try @footer?._expand()
			try @header?._expand()
			@header?._showLoading(false)
			return


	_updatePrevious: (next, prev, options) =>
		@isTransitioning = false

		unless prev? and prev instanceof View
			@emit("transitionEnd", prev, next, options)	
			return

		prev.sendToBack()
		prev._unloadView(@, next, prev, options)
		@emit("transitionEnd", prev, next, options)	


	_transitionToNext: (next, prev, options) =>
		transition = options.transition ? @_platformTransition

		@loading = false
		@isTransitioning = false
		@transition(next, transition, options)
		@emit "transitionStart", next

		do (next, prev, options) =>
			@once Events.TransitionEnd, =>
				@_updatePrevious(next, prev, options)


	_transitionToPrevious: (transition, animate, prev, next, options) =>
		@loading = false
		@isTransitioning = false
		@_runTransition(transition, "back", animate, prev, next)
		@emit "transitionStart", next

		do (next, prev, options) =>
			@once Events.TransitionEnd, =>
				@_updatePrevious(next, prev, options)



	# lifecycle handlers
	
	_prepareToLoad: =>
		try @header._expand()
		try @footer._expand()
		@focused?.blur()
		@modal?.destroy()
		@isTransitioning = true
		Utils.delay .25, => @loading = @isTransitioning


	_sendError: (layer, area, error) =>
		# make this work with Framer's regular error handling
		print "#{layer.title ? layer.key ? layer.name}, Error in View.#{area}: #{error.message}"



	_preload: (layer) =>
		new Promise(_.bind(layer.preload, layer))

		
	_load: (layer, response) =>
		new Promise (resolve, reject) => 
			Utils.bind layer, -> 
				try layer.load(response) 
				catch error
					reject(error)

				resolve(response)


	_postload: (layer, response) =>
		new Promise (resolve, reject) =>
			_.defer =>
				layer.emit "loaded"
				layer.updateContent()		
				try 
					layer.postload(response)
				catch error
					reject(error)

				resolve()


	# ---------------
	# Public Methods
	

	showNext: (layer, loadingTime, options={}) ->
		return if @isTransitioning
		return if layer is @current

		@_initial ?= true

		if @chrome is "safari" and not @_initial 
			loadingTime ?= _.random(.5, .75)

		views = _.filter @views, (v) => v.parent is @

		if views.length > 0
			current = _.maxBy(views, 'index')

		cycle = =>
			@_preload(layer)
			.then (response) => 
				@_load(layer, response)
				.then (response) => 
					@_postload(layer, response)
					.then =>
						layer.updateContent()
						layer.y = @windowFrame.expandY
						@_transitionToNext(layer, current, options)
					.catch (e) => @_sendError(layer, "postload", e)
				.catch (e) => @_sendError(layer, "load", e)
			.catch (e) => @_sendError(layer, "preload", e)

		if loadingTime
			loadingTime ?= .5
			@loading = true
			@_prepareToLoad()
			Utils.delay loadingTime, cycle
			return

		cycle()


	showPrevious: (loadingTime, options={}) =>
		return unless @previous
		return if @isTransitioning

		@_prepareToLoad()

		# force loading time on safari

		if @chrome is "safari"
			@loading = true
			loadingTime = _.random(.3, .75)

		# Maybe people (Jorn, Steve for sure) pass in a layer accidentally
		options = {} if options instanceof(Framer._Layer)
		options = _.defaults({}, options, {count: 1, animate: true})

		if options.count > 1
			count = options.count
			@showPrevious(animate: false, count: 1) for n in [2..count]

		previous = @_stack.pop()

		# views = _.filter @views, (v) => v.parent is @

		# if views.length > 0
		# 	current = _.maxBy(views, 'index')

		layer = @current

		if layer.preserveContent
			layer.updateContent()
			layer.y = @windowFrame.expandY
			@_transitionToPrevious(previous?.transition, options.animate, previous.layer, layer, options)
			return

		# preload the new View
		cycle = => 
			@_preload(layer)
				.then (response) => 
					@_load(layer, response)
					.then (response) => 
						@_postload(layer, response)
						.then =>
							# do transition, for previous
							layer.updateContent()
							layer.y = @windowFrame.expandY
							@_transitionToPrevious(previous?.transition, options.animate, previous.layer, layer, options)
						.catch (e) => @_sendError(layer, "postload", e)
					.catch (e) => @_sendError(layer, "load", e)
				.catch (e) => @_sendError(layer, "preload", e)



		if loadingTime
			loadingTime ?= .5
			@loading = true
			@_prepareToLoad()
			Utils.delay loadingTime, cycle
			return

		cycle()


	getScreenshot: (options = {}) =>
		return new Promise (resolve, reject) =>
				
			_.defaults options,
				layer: @
				name: "screenshot"
				type: "png"
				style:
					height: '100%'
					width: '100%'

			load = new Promise (rs, rj) ->
				if @_isDomToImageLoaded?
					rs()
					return
			
				domtoimageCDN = "https://cdnjs.cloudflare.com/ajax/libs/dom-to-image/2.6.0/dom-to-image.js"

				Utils.domLoadScript domtoimageCDN, => 
					@_isDomToImageLoaded = true
					rs()

			load.then( ->
				node = options.layer._element
				func = domtoimage['to' + _.startCase(options.type)]
				
				func(node, {cacheBust: true, style: options.style})
				.then( (url) ->
					link = document.createElement('a')
					link.download = options.name + '.' + options.type
					link.href = url
					link.click()
					resolve()
				).catch (error) -> 
					console.log(error)
			)

	screenshotViews: (views, options = {}) =>
		i = 0
			
		loadNext = =>
			view = views[i]
			return if not view

			@showNext(view)
			i++
			
		@on "transitionEnded", =>
			Utils.delay 2.5, =>
				o = _.clone(options)
				o.name = @current?.key
				@getScreenshot(o).then loadNext
		
		loadNext()
	

	# DEFINITIONS

	@define "windowFrame",
		get: -> return @_windowFrame
	