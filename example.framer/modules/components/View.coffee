# View

class exports.View extends ScrollComponent
	constructor: (options = {}) ->
		
		@app = options.app

		# ---------------
		# Options

		_.defaults options,
			backgroundColor: '#FFF'
			contentInset:
				top: 16
				bottom: 64
				
			padding: {}
			title: ''
			load: null
			unload: null
			key: null
			clip: false

		_.assign options,
			width: @app.contentWidth
			height: @app.windowFrame.height
			scrollHorizontal: false

		super options

		@key = options.key

		# ---------------
		# Layers

		@app.views.push(@)
		@content.backgroundColor = @backgroundColor
		@sendToBack()

		# ---------------
		# Definitions
		
		Utils.defineValid @, 'title', options.title, _.isString, 'View.title must be a string.'
		Utils.defineValid @, 'padding', options.padding, _.isObject, 'View.padding must be an object.'
		Utils.defineValid @, 'load', options.load, _.isFunction, 'View.load must be a function.'
		Utils.defineValid @, 'unload', options.unload, _.isFunction, 'View.unload must be a function.'
		
		# unless padding is specifically null, set padding defaults
		if @padding?
			_.defaults @padding,
				left: 16,
				right: 16,
				top: 16,

		# ---------------
		# Events
		
		@content.on "change:children", @_fitChildrenToPadding
		@app.on "change:windowFrame", @_updateSize


		@delayedUpdate = Utils.throttle 1, @_delayUpdateSize
	# ---------------
	# Private Functions
	
	_delayUpdateSize: =>
		Utils.delay 1, @_updateSize

	_updateSize: (windowFrame) =>
		# perhaps doing nothing is the best thing to do
		@keyLayer?.y = 8 + (@app.windowFrame.y - @y)
		return
	# 	_.assign @,
	# 		y: @app.windowFrame.y
	# 		height: @app.windowFrame.height
			
	_fitChildrenToPadding: (children) =>
		return if not @padding

		w = @width - @padding.right - @padding.left

		for child in children.added
			if child.x < @padding.left then child.x = @padding.left
			if child.y < @padding.top then child.y = @padding.top
			if child.width > w 
				Utils.delay 0, -> child.width = w

	# ---------------
	# Private Methods

	_loadView: (app, next, prev) =>
		try 
			@load(app, next, prev)
		catch
			throw "View ('#{@title ? @name}') must have a `load` property, a function that creates the View's child layers."
		@app.loading = false

		if @key
			@keyLayer = new TextLayer
				name: "Key: #{@key}"
				parent: @
				fontSize: 12
				fontWeight: 600
				y: 8
				width: @width
				textAlign: 'center'
				color: '#000'
				text: @key

	
	_unloadView: (app, next, prev) =>
		try @unload(app, next, prev)
		child.destroy() for child in _.without(@children, @content)
		child.destroy() for child in @content.children

	# ---------------
	# Public Methods

	onLoad: (callback) -> 	
		@load = callback

	onUnload: (callback) -> 
		@unload = callback
