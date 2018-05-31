###

Navbar

A drop-down menu.

@extends {Layer}
@param	{Object}	options 				The component's attributes.
@param	{number}	options.selectedIndex	The index of the link to activate on load.
@param	{number}	options.height			The navbar's collapsed height.
@param	{string}	options.color 			The color to use for the navbar's labels.
@param	{number}	options.start			The initial active link.
@param	{Object}	options.padding			An object to set the top, bottom, and stack paddings for the navbar's link labels.
@param	{Object}	options.links			An object of links for the navbar:

	links:
		<string>: <function>	The title / label for this link : a callback to fire when the link is selected.


Navbar.selectedIndex {number}
	Sets the index of the link to activate.
	Emits a "change:selectedIndex" event.


Navbar.open()	
	Opens the navbar. Equivilent to navbar.open = true.

Navbar.close()	
	Closed the navbar. Equivilent to navbar.open = false.

###

class exports.Navbar extends Layer
	constructor: (options = {}) ->
		
		@initial = true

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

			selectedIndex: 2
			padding: {}
			links:
				"First Page": undefined
				"Second Page": undefined
				"Third Page": undefined

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
				],
			{
				prevIndex: -1
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

		@links = _.map options.links, (value, key) =>
			link = new H5Link
				parent: @
				name: key + ' Label'
				text: key
				width: @width
				textAlign: "center"
				color: @color
				opacity: 1
				y: @currentLabel.maxY + @padding.top
				padding: {top: 16, bottom: 16}
				
			link.onTap =>
				try value()

				return unless @open
				@selectedIndex = _.indexOf(@links, link) 

			return link
		
		Utils.stack(@links, @padding.stack)

		@fullHeight = _.last(@links)?.maxY + @padding.bottom ? @height

	
		# DEFINITIONS
		
		Utils.define @, "open" , false, @_setOpen

		# EVENTS

		@on "change:selectedIndex", @_setSelectedIndex
		@onTap => @open = !@open


		# CLEANUP

		child.name = '.' for child in @children unless options.showSublayers
		
		delete @initial
	
		@selectedIndex = options.selectedIndex

	# PRIVATE METHODS

	_setOpen: (bool) =>
		if bool
			Utils.setOrAnimateProps @, @initial, { height: @fullHeight }
			Utils.setOrAnimateProps @currentLabel, @initial, { opacity: .618 }
			Utils.setOrAnimateProps @chevron, @initial, { rotation: 180 }
			return
		
		Utils.setOrAnimateProps @, @initial, { height: @currentLayer.height + 1 }
		Utils.setOrAnimateProps @currentLabel, @initial, { opacity: 1 }
		Utils.setOrAnimateProps @chevron, @initial, { rotation: 0 }

	_setSelectedIndex: (index) =>
		link = @links[index]

		@currentLabel.text = link?.text


	# PUBLIC METHODS
	
	open: => @open = true

	close: => @open = false

	@define "selectedIndex",
		get: -> @_selectedIndex
		set: (value) ->
			print value
			return if @initial
			return if value is @_selectedIndex or value is null

			@_selectedIndex = value
			@emit "change:selectedIndex", value, @prevIndex, @
			@prevIndex = @_selectedIndex
