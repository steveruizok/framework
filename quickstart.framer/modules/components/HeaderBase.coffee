###

Header Base

A base class for other headers.

@extends {Layer}	
@param 	{Object}	options 				The component's attributes.
@param 	{string}	options.title 			The header's initial title.
@param 	{string}	options.tint 			The header's tint color.
@param 	{boolean}	options.hidden			Whether the header should begin with its content hidden.
@param 	{boolean}	options.collapsed		Whether the header should begin in its collapsed state.
@param 	{number}	options.collapsedHeight	How tall the header should be when collapsed.

HeaderBase.loading {boolean}
	Turns on or off the header's loading state, if any. 
	Emits a "change:loading" event.

HeaderBase.expand()	
	Expands the header.

HeaderBase.collapse()	
	Collapses the header.

###

class exports.HeaderBase extends Layer
	constructor: (options = {}) ->

		_.defaults options,
			name: "Header"
			width: Screen.width
			height: 72
			color: black
			backgroundColor: white
			shadowY: 1
			shadowColor: black.alpha(.16)
			clip: true
			animationOptions: {time: .25}

			title: undefined
			tint: "#333"
			hidden: false
			collapsed: false
			collapsedHeight: 20

		super options


		_.assign @, 
			_.pick options, [
				'collapsedHeight'
				]
			{
				_initial: true
				fullHeight: @height
			}

		# LAYERS

		@loadingLayer = new Layer 
			name: '.'
			size: Screen.size
			backgroundColor: 'rgba(0,0,0,0)'

		@loadingLayer._element.style["pointer-events"] = "all"
		@loadingLayer.sendToBack()

		# DEFINITIONS

		Utils.define @, 'title',	options.title,
		Utils.define @, 'viewKey',	options.viewKey,
		Utils.define @, 'tint',		options.tint,
		Utils.define @, 'hidden',	options.hidden,
		Utils.define @, 'loading',	options.loading,
		Utils.define @, 'collapsed',options.collapsed, (bool) =>
			height = if bool then @collapsedHeight else @fullHeight
			Utils.setOrAnimateProps @, @_initial, { height: height }

		# EVENTS

		@loadingLayer.onTap (event) => event.stopPropagation()

		@on "change:height", @app._setWindowFrame

		@app.on "change:loading", (bool) =>
			@expand()
			
			if bool
				@loadingLayer.visible = true
				@loadingLayer.bringToFront()
			else
				@loadingLayer.visible = false
				@loadingLayer.sendToBack()

			@loading = bool

		@app.onSwipeUpEnd =>
			return unless @app.current.isMoving 
			return if @app.current.content.draggable.isBeyondConstraints
			@collapsed = true
 
		@app.onSwipeDownEnd =>
			return unless @app.current.isMoving
			@collapsed = false

		@app.on "transitionStart", => @hidden = true
		
		@app.on "transitionEnd", => @hidden = false

		@app.on "transitionEnd", @update


		# CLEANUP

		if not options.showSublayers then child.name = '.' for child in @children


		# KICKOFF

		delete @_initial


	# PRIVATE METHODS

	# _setTitle: (string) =>

	# _setViewKey: (string) =>

	# _setTint: (string) =>

	# _showHidden: (string) =>

	# _showLoading: (string) =>

	# _showCollapsed: (bool) =>


	# PUBLIC METHODS

	update: => 

	expand: => @collapsed = false

	collapse: => @collapsed = true