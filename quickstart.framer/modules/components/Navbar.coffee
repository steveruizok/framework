###

Navbar

A drop-down menu to select sub-pages.

@extends {Layer}
@param {Object} options 			The navbar's attributes.
@param {number} options.height	 	The navbar's collapsed height.
@param {string} options.color 		The color to use for the navbar's labels.
@param {number} options.start		The initial linked page.
@param {Object} options.links		An object of key value pairs, where the key is the title of the link and the value is the callback used to create that link's page content.
@param {Object} options.padding		An object to set the top, bottom, and stack paddings for the navbar's link labels.

###

class exports.Navbar extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: "Toolbar"
			width: Screen.width
			backgroundColor: white
			color: black
			shadowY: 1
			shadowColor: black.alpha(.16)
			clip: true
			animationOptions:
				time: .25

			padding: {}
			flow: undefined
			pages:
				"First Page": undefined
				"Second Page": undefined
				"Third Page": undefined
			start: 2

		_.defaults options.padding,
			top: 0
			stack: 0
			bottom: 8
		
		super options

		_.assign @, 
			_.pick options, [
				'padding'
				'start'
				'padding'
				'links'
				'flow'
				'pages'
				],
			{
				prevCurrent: undefined
			}
		

		# LAYERS

		# current selected

		@currentLayer = new Layer
			name: "Current"
			parent: @
			width: @width
			height: @height
			backgroundColor: @backgroundColor

		@currentLabel = new H5Link
			parent: @currentLayer
			name: "Current Label"
			text: ""
			width: @width
			textAlign: "center"
			color: @color
			opacity: 1
			padding: {top: 16, bottom: 16}
			animationOptions: @animationOptions

		@height = options.height ? @currentLabel.height
		@currentLayer.height = @height
		
		# chevron
		
		@chevron = new Icon
			name: "Chevron"
			parent: @currentLayer
			x: Align.right(-16)
			icon: 'chevron-down'
			color: @color
			y: Align.center()
			animationOptions: @animationOptions
		
		# link labels

		@links = _.map options.pages, (page, i) =>
			label = new H5Link
				parent: @
				name: page.name + ' Label'
				text: page.name
				width: @width
				textAlign: "center"
				color: @color
				opacity: 1
				y: @currentLabel.maxY + @padding.top
				padding: {top: 16, bottom: 16}
					
			label.onTap =>
				return unless @open
				@active = i
			
			return label
		
		Utils.stack(@links, @padding.stack)

		@fullHeight = _.last(@links)?.maxY + @padding.bottom ? @height

	
		# DEFINITIONS
		
		Utils.define @, "leftTransition", leftTransition
		Utils.define @, "rightTransition", rightTransition
		Utils.define @, "active", @start, @_setActiveLink
		Utils.define @, "open", false, @_setOpen
		

		# EVENTS

		@onTap => @open = !@open


		# CLEANUP
		
		delete @initial
		
		child.name = '.' for child in @children unless options.showSublayers
		
	

	# PRIVATE METHODS

	_setOpen: (bool) =>
		if bool
			Utils.setOrAnimateProps @, @initial, { height: @fullHeight }
			Utils.setOrAnimateProps @currentLabel, @initial, { opacity: .8 }
			Utils.setOrAnimateProps @chevron, @initial, { rotation: 180 }
			return
		
		Utils.setOrAnimateProps @, @initial, { height: @currentLayer.height + 1 }
		Utils.setOrAnimateProps @currentLabel, @initial, { opacity: 1 }
		Utils.setOrAnimateProps @chevron, @initial, { rotation: 0 }


	_setActiveLink: (index) =>
		link = @links[index]
		@currentLabel.text = link.text

		currentIndex = @prevCurrent ? -1
		transition = @_getTransition(index, currentIndex)
		
		@flow.transition(@pages[index], transition)
		@emit "change:current", @pages[index]
		@prevCurrent = index


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