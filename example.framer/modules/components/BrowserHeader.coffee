###

Browser Header

A  header for desktop browser devices.

@extends {HeaderBase}


iOSHeader.update()	
	Updates the header's title, viewKey, and Back link.

###

class exports.BrowserHeader extends HeaderBase
	constructor: (options = {}) ->

		_.defaults options,
			name: "Browser Header"
			color: black
			backgroundColor: white
			height: 36
			
			title: "Browser Header"
			tint: blue
			hidden: false
			collapsed: false
			collapsedHeight: 20

		super options
		
		# minimize, etc buttons

		for color, i in ['#ff5f58', '#ffbd2d', '#28cc42']
			button = new Layer
				parent: @
				x: 16 + ((20) * i)
				y: Align.center
				size: 24
				borderRadius: 12
				backgroundColor: color
				borderColor: new Color(color).darken(10)
				borderWidth: 1
				scale: .5


		# back button
		
		@backButton = new Layer
			parent: @
			x: button.maxX + (8)
			y: Align.center
			height: 44
			width: 50
			borderRadius: 4
			borderWidth: 1
			borderColor: "#cecdcf"
			shadowY: 1
			shadowColor: "#a5a4a6"
			gradient:
				start: "#f1f1f1"
				end: "#fdfdfd"
			scale: .5
		
		@backButtonIcon = new Icon
			parent: @backButton
			x: Align.center
			y: Align.center(4)
			icon: "ios-back"
			color: "#808080"
			
		@backButton.onTap => app.showPrevious()
		
		@forwardButton = new Layer
			parent: @
			x: button.maxX + (32)
			y: Align.center
			height: 44
			width: 50
			borderRadius: 4
			borderWidth: 1
			borderColor: "#cecdcf"
			shadowY: 1
			shadowColor: "#a5a4a6"
			gradient:
				start: "#f1f1f1"
				end: "#fdfdfd"
			scale: .5
				
		@forwardButtonIcon = new Icon
			parent: @forwardButton
			x: Align.center
			y: Align.center(-2)
			icon: "ios-back"
			rotation: 180
			color: "#808080"
		
		# address field
		@addressContainer = new Layer
			parent: @
			height: 48
			width: @width * .618
			point: Align.center()
			gradient:
				start: "#f1f1f1"
				end: "#fefefe"
			borderRadius: 4
			borderColor: "#cac9cb"
			shadowY: 1
			shadowColor: "#a5a4a6"
			scale: .5
			
		@titleLayer = new TextLayer
			parent: @addressContainer
			point: Align.center()
			text: "{url}"
			fontSize: 24
			color: '#333'
		
		#icons
		@readerIcon = new Icon
			parent: @addressContainer
			x: 8
			y: Align.center()
			height: 26
			width: 26
			icon: "format-align-left"
			color: '#7c7c7d'
		
		@lockIcon = new Icon
			parent: @addressContainer
			x: @titleLayer.x - 32
			y: Align.center()
			height: 22
			width: 22
			icon: "lock"
			color: '#7c7c7d'

		Utils.pin @lockIcon, @titleLayer, "left"
			
		@refreshIcon = new Icon
			parent: @addressContainer
			x: Align.right(-8)
			y: Align.center()
			height: 26
			width: 26
			icon: "refresh"
			color: '#7c7c7d'

		@refreshIcon.onTap -> window.location.reload()

		@addressLoadingLayer = new Layer
			name: '.'
			parent: @addressContainer
			x: 0
			y: Align.bottom()
			height: 2
			width: 1
			backgroundColor: "#007AFF"
			visible: false

		# DEFINITIONS	


		# EVENTS

		@backButton.onTap => @app.showPrevious()

		@on "change:title",		@_setTitle
		@on "change:loading",	@_showLoading

		# CLEANUP

		child.name = '.' for child in @children unless options.showSublayers


		# KICKOFF

		delete @_initial

		@title = ""
		@title = options.title


	# PRIVATE METHODS


	_setTitle: (string) =>
		return if @_initial
		@titleLayer.template = string
		@titleLayer.x = Align.center()


	_setViewKey: (string) =>
		@statusBar.viewKey = string


	_setColor: (string) =>


	_setTint: (color) =>


	_showLoading: (bool) =>

		# loading is false
		_.assign @loadingLayer,
			width: 1
			visible: false


		if bool
			_.assign @addressLoadingLayer,
				width: 1
				visible: true

			@addressLoadingLayer.animate
				width: @addressContainer.width
				options:
					time: 1.7
					curve: "linear"
			return

		# loading is false
		_.assign @addressLoadingLayer,
			width: 1
			visible: false

	
	_showHidden: (bool) =>


	_showCollapsed: (bool) =>
	

	# PUBLIC METHODS

	update: (prev, next, options) =>
		# @title = next?.title ? ""
		# @viewKey = next?.viewKey if @app.showKeys

		# hasPrevious = @app._stack.length > 1
		# showPrevLinks = !next?.root and hasPrevious
		# @leftHitArea.visible = showPrevLinks