require 'components/moreutils'
theme = require 'components/Theme'
colors = require 'components/Colors'
typography = require 'components/Typography'

colors.updateColors()

# disable hints 
Framer.Extras.Hints.disable()

# get rid of dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"

# Exports for theme support 
_.assign exports,
	app: undefined
	defaultTitle: "framework.com"
	typography: typography
	colors: colors
	theme: theme

components = [
	'Icon', 
	'HeaderBase'
	'BrowserHeader'
	'iOSStatusBar'
	'iOSHeader'
	'SafariHeader'
	'Switch',
	'Alert',
	'Button',
	'Radiobox',
	'Checkbox',
	'Container',
	'DocComponent',
	'Toggle',
	'Tooltip',
	'Select',
	'Stepper', 
	'Segment',
	'TextInput',
	"TextArea",
	'Menu',
	'Link', 
	'Separator', 
	'View',
	'Template',
	'Toolbar'
	'PageView'
	'Navbar',
	'ActionSheet', 
	'FormComponent',
	"ProgressComponent"
	'CarouselComponent', 
	'SortableComponent'
	'TabComponent'
	'StickyComponent'
	]

imports = [
	'Transitions'
	'Keyboard'
]

globals = []

# import as: { module } = require 'module'
globals.forEach (variable) ->
	mod = require "components/#{variable}"
	window[variable] = mod[variable]

# import as: module = require 'module'
imports.forEach (variable) ->
	mod = require "components/#{variable}"
	window[variable] = mod

# Add components to window
components.forEach (componentName) ->
	mod = require "components/#{componentName}"
	component = mod[componentName]

	window[componentName] = class FrameworkComponent extends component
		constructor: (options = {}) ->
			@app = exports.app

			_.assign options,
				showSublayers: @app.showSublayers

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
			showSublayers: false

		super options

		_.assign @,
			title: options.title
			chrome: options.chrome
			showKeys: options.showKeys
			contentWidth: options.contentWidth
			_windowFrame: {}
			views: []
			showSublayers: options.showSublayers
			keyboard: Keyboard
			printErrors: options.printErrors
			preload: new Promise (resolve, reject) -> _.defer resolve

		# device
		
		if @chrome is "browser" or "fullscreen"
			Framer.Device.customize
				deviceType: Framer.Device.Type.Desktop
				devicePixelRatio: 1
				screenWidth: 1440
				screenHeight: 900
				deviceImageWidth: 900
				deviceImageHeight: 1440

			_.assign @,
				size: Screen.size

			_.assign Framer.Device.screenBackground,
				backgroundColor: null

			_.assign Framer.Device.content, 
				borderWidth: 1
				borderRadius: 4
				backgroundColor: null
				clip: true

			Canvas.backgroundColor = "#1E1E1E"

		# header

		switch @chrome
			when "ios"
				@header = new iOSHeader
				defaultTransition = @_iosTransition
				chromeLoading = false
			when "safari"
				@header = new SafariHeader
				defaultTransition = @_safariTransition
				chromeLoading = true
			when "fullscreen"
				defaultTransition = @_safariTransition
				chromeLoading = false
			when "browser"
				Framer.Device.customize
					deviceType: Framer.Device.Type.Desktop
					devicePixelRatio: 1
					screenWidth: 1440
					screenHeight: 900
					deviceImageWidth: 900
					deviceImageHeight: 1440

				_.assign @,
					width: 1440
					height: 900
					header: new BrowserHeader({title: @title})
				
				defaultTransition = @_safariTransition
				chromeLoading = true
			else
				defaultTransition = @_safariTransition
				chromeLoading = false


		# DEFINITIONS

		Utils.define @, 'focused', 		null, 					@_showFocused,		_.isObject,		"App.focused must be an html element."
		Utils.define @, 'loading', 		false, 					@_showLoading, 		_.isBoolean,	"App.loading must be a boolean (true or false)."
		Utils.define @, 'viewPoint',	{x:0, y:0}, 			undefined,			_.isObject, 	'App.viewPoint must be an point object (e.g. {x: 0, y: 0}).'
		Utils.define @, 'chromeOpacity', options.chromeOpacity, @_setChromeOpacity, _.isNumber, 	"App.chromeOpacity must be a number between 0 and 1."
		Utils.define @, 'chromeLoading',chromeLoading,			undefined,			_.isBoolean,	"App.chromeLoading must be boolean (true or false)."
		Utils.define @, 'time', 		new Date()
		Utils.define @, 'windowFrame', 	undefined
		Utils.define @, 'defaultTransition', defaultTransition,	undefined,			_.isFunction,	'App.defaultTransition must be a function (see flow.transition).'

		Screen.on Events.EdgeSwipeLeftEnd, @showPrevious

		# EVENTS

		@footer?.on "change:height", @_setWindowFrame

		@_setWindowFrame()


		# KICKOFF

		# update time
		@_setTime()
		
		# ... and update time every sixty seconds
		Utils.delay (60 - new Date().getSeconds()), =>
			@_setTime()
			Utils.interval 60, @_setTime


	# ---------------
	# Private Methods

	_setTime: => @time = new Date()


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
		footerHeight = @footer?.height ? 0
		headerHeight = @header?.height ? 0
		headerFullHeight = @header?.fullHeight ? headerHeight

		@windowFrame =
			expandY: headerFullHeight
			y: headerHeight
			x: @x
			maxX: @maxX
			maxY: @height - headerHeight
			height: @height - footerHeight - headerFullHeight
			width: @width
			size:
				height: @height - footerHeight - headerFullHeight
				width: @width


	_showLoading: (bool) =>
		@focused?.blur()


	_updatePrevious: (next, prev, options, direction) =>
		@isTransitioning = false

		unless prev? and prev instanceof View
			@emit("transitionEnd", prev, next, options)	
			return

		prev._unloadView(@, next, prev, options, direction)
		@emit("transitionEnd", prev, next, options)	


	_transitionToNext: (next, prev, options) =>
		transition = options.transition ? @defaultTransition

		@loading = false
		@isTransitioning = false

		@transition(next, transition, options)
		@emit "transitionStart", next

		do (next, prev, options) =>
			@once Events.TransitionEnd, =>
				@_updatePrevious(next, prev, options, "forward")


	_transitionToPrevious: (transition, animate, prev, next, options) =>
		@loading = false
		@isTransitioning = false
		@_runTransition(transition, "back", animate, prev, next)
		@emit "transitionStart", next

		do (next, prev, options) =>
			@once Events.TransitionEnd, =>
				@_updatePrevious(next, prev, options, "back")



	# lifecycle handlers
	
	_prepareToLoad: =>
		@header?.expand()

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
	

	showNext: (layer, load = false, options={}) ->
		return if @isTransitioning
		return if layer is @current

		@_initial ?= true

		views = _.filter @views, (v) => v.parent is @

		if views.length > 0
			current = _.maxBy(views, 'index')

		unless layer instanceof View
			@_transitionToNext(layer, current, options)
			return

		cycle = =>
			@_preload(layer)
			.then (response) => 
				@_load(layer, response)
				.then (response) => 
					@_postload(layer, response)
					.then =>
						layer.placeBehind(@overlay)
						layer.updateContent()
						layer.y = @windowFrame.expandY
						@_transitionToNext(layer, current, options)
					.catch (e) => @_sendError(layer, "postload", e)
				.catch (e) => @_sendError(layer, "load", e)
			.catch (e) => @_sendError(layer, "preload", e)

		@_prepareToLoad()


		if load or (@chromeLoading and not load)
			loadTime = _.random(.25, .5)
			@loading = true
			Utils.delay loadTime, cycle
			return

		cycle()


	showPrevious: (load = false, options={}) =>
		return unless @previous
		return if @isTransitioning

		# force loading time on safari

		# Maybe people (Jorn, Steve for sure) pass in a layer accidentally
		options = {} if options instanceof(Framer._Layer)
		options = _.defaults({}, options, {count: 1, animate: true})

		if options.count > 1
			count = options.count
			@showPrevious(animate: false, count: 1) for n in [2..count]

		previous = @_stack.pop()

		layer = @current

		if layer.preserveContent
			layer.updateContent()
			layer.y = @windowFrame.expandY
			@_transitionToPrevious(previous?.transition, options.animate, previous.layer, layer, options)
			return

		unless previous.layer instanceof View
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
							layer.placeBehind(@overlay)
							layer.updateContent()
							layer.y = @windowFrame.expandY
							@_transitionToPrevious(previous?.transition, options.animate, previous.layer, layer, options)
						.catch (e) => @_sendError(layer, "postload", e)
					.catch (e) => @_sendError(layer, "load", e)
				.catch (e) => @_sendError(layer, "preload", e)

		@_prepareToLoad()

		if load or (@chromeLoading and not load)
			loadTime = _.random(.25, .5)
			@loading = true
			Utils.delay loadTime, cycle
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
			
		@on "transitionEnd", =>
			Utils.delay 2.5, =>
				o = _.clone(options)
				o.name = @current?.key
				@getScreenshot(o).then loadNext
		
		loadNext()
	

	# DEFINITIONS
