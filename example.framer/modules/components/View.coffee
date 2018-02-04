# View

class exports.View extends ScrollComponent
	constructor: (options = {}) ->
		
		@app = options.app

		# ---------------
		# Options

		_.defaults options,
			backgroundColor: '#FFF'
			contentInset:
				top: 0
				bottom: 64
				
			padding: {}
			title: ''
			load: -> null
			unload: -> null

		_.assign options,
			width: Screen.width
			height: Screen.height
			scrollHorizontal: false

		options.contentInset.top = (@app.header?.height ? 0) + (options.contentInset?.top ? 0)

		super options

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
		
		# unless padding is specifically null, set padding defaults
		if @padding?
			_.defaults @padding,
				left: 16,
				right: 16,
				top: 16,

		# ---------------
		# Events
		
		@content.on "change:children", @_fitChildrenToPadding


	# ---------------
	# Private Functions
			
	_fitChildrenToPadding: (children) =>
		return if not @padding

		w = @width - @padding.right - @padding.left

		for child in children.added
			if child.x < @padding.left then child.x = @padding.left
			if child.y < @padding.top then child.y = @padding.top
			if child.width > w 
				Utils.delay 0, -> child.width = w

	# ---------------
	# Private Functions			

	_loadView: =>
		@load()
	
	_unloadView: =>
		@unload()

	# ---------------
	# Public Functions

	onLoad: (callback) -> 
		@load = callback

	onUnload: (callback) -> 
		@unload = callback
