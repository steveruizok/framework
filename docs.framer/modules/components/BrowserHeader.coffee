class exports.SafariHeader extends Layer
	constructor: (options = {}) ->

		_.defaults options,
			width: Screen.width
			height: 36
			gradient:
				start: "#d6d5d7"
				end: "f7f6f7"
			shadowY: 1
			shadowColor: "#a2a1a3"

		super options

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
		@addressField = new Layer
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
			
		@textLayer = new TextLayer
			parent: @addressField
			point: Align.center()
			text: "framework.com"
			fontSize: 24
			color: '#333'
		
		#icons
		@readerIcon = new Icon
			parent: @addressField
			x: 8
			y: Align.center()
			height: 26
			width: 26
			icon: "format-align-left"
			color: '#7c7c7d'
		
		@lockIcon = new Icon
			parent: @addressField
			x: @textLayer.x - 32
			y: Align.center()
			height: 22
			width: 22
			icon: "lock"
			color: '#7c7c7d'
			
		@refreshIcon = new Icon
			parent: @addressField
			x: Align.right(-8)
			y: Align.center()
			height: 26
			width: 26
			icon: "refresh"
			color: '#7c7c7d'

		@refreshIcon.onTap -> window.location.reload()

		@loadingLayer = new Layer
			name: '.'
			parent: @addressField
			x: 0
			y: Align.bottom()
			height: 2
			width: 1
			backgroundColor: "#007AFF"
			visible: false

		# EVENTS

		@backButton.onTap => @app.showPrevious()
		
	# ---------------
	# Private Methods

	_showLoading: (bool, time) =>
		if bool
			# loading is true
			_.assign @loadingLayer,
				width: 1
				visible: true

			@loadingLayer.animate
				width: @addressField.width
				options:
					time: time ? 2
					curve: "linear"
			return

		# loading is false
		_.assign @loadingLayer,
			width: 1
			visible: false


	_setViewKey: (value) =>
		@statusBar.viewKeyLayer.template = value ? ''

	# ---------------
	# Public Methods

	updateTitle: (title) =>
		@addressField.text = title
		