# NavBar

class exports.Navbar extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: "Toolbar"
			height: 44
			width: Screen.width
			backgroundColor: white
			color: black
			shadowY: 1
			shadowColor: black.alpha(.16)
			animationOptions:
				time: .25

			clip: true
			flow: @app
			links:
				"First Page": undefined
				"Second Page": undefined
				"Third Page": undefined
			pages: []
			start: 2
		
		super options

		_.assign @,
			start: options.start
			pages: options.pages
			links: options.links
			flow: options.flow
			prevCurrent: undefined
		

		# LAYERS

		# current selected

		@currentLayer = new Layer
			parent: @
			width: @width
			height: @height
			backgroundColor: @backgroundColor

		@currentLabel = new H5Link
			parent: @currentLayer
			text: ""
			width: @width
			textAlign: "center"
			color: @color
			opacity: 1
			padding: {top: 16, bottom: 16}
			animationOptions: @animationOptions

		@height = @currentLabel.height
		@currentLayer.height = @height
		
		# chevron
		
		@chevron = new Icon
			parent: @currentLayer
			x: Align.right(-16)
			icon: 'chevron-down'
			color: @color
			y: Align.center()
			animationOptions: @animationOptions
		
		# link labels

		@links = _.map options.links, (value, key) =>
			label = new H5Link
				parent: @
				name: '.'
				text: key
				width: @width
				textAlign: "center"
				color: @color
				opacity: 1
				y: @currentLabel.maxY
				padding: {top: 16, bottom: 16}
					
			label.onTap =>
				return unless @open
				@active = _.keys(options.links).indexOf(key)
			
			return label
		
		Utils.stack(@links)

		@fullHeight = _.last(@links)?.maxY + 8 ? @height
	
	
		# DEFINITIONS
		
		Utils.define @, "leftTransition", leftTransition
		Utils.define @, "rightTransition", rightTransition
		Utils.define @, "active", @start, @_setActiveLink
		Utils.define @, "open", false, @_setOpen
		

		# EVENTS
		
		@onTap => @open = !@open
	

	# PRIVATE METHODS
	
	_setOpen: (bool) =>
		if bool
			@animate { height: @fullHeight }
			@currentLabel.animate { opacity: .8 }
			@chevron.animate { rotation: 180 }
			return
		
		@animate { height: @currentLayer.height + 1 }
		@currentLabel.animate { opacity: 1 }
		@chevron.animate { rotation: 0 }


	_setActiveLink: (index) =>
		link = @links[index]
		@currentLabel.text = link.text

		currentIndex = _.indexOf(@links, @prevCurrent) ? -1
		transition = @_getTransition(index, currentIndex)
		
		@flow.transition(@pages[index], transition)
		@emit "change:current", @pages[index]
		@prevCurrent = link


	_getTransition: (nextIndex, currentIndex) =>
		if currentIndex > nextIndex
			return @rightTransition

		return @leftTransition


leftTransition = (nav, layerA, layerB, overlay) ->
	transition =
		layerA: 
			show:
				x: Screen.width
				options:
					time: .45
			hide:
				x: -Screen.width
				options:
					time: .45
		layerB:
			show:
				x: 0
				options:
					time: .45
			hide:
				x: Screen.width
				options:
					time: .45
				
rightTransition = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x: -Screen.width
				options:
					time: .45
			hide:
				x: Screen.width
				options:
					time: .45
		layerB:
			show:
				x: 0
				options:
					time: .45
			hide:
				x: -Screen.width
				options:
					time: .45