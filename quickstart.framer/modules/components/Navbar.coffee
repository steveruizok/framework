###

Navbar

A drop-down menu.

@extends {Layer}
@param	{Object}	options 		The navbar's attributes.
@param	{number}	options.height	The navbar's collapsed height.
@param	{string}	options.color 	The color to use for the navbar's labels.

@param	{number}	options.start	The initial active link.
@param	{Object}	options.padding	An object to set the top, bottom, and stack paddings for the navbar's link labels.
@param	{Object}	options.links	An object of key value pairs, where the key is the title of the link and the value is the callback to be fired when the link is clicked.

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

			start: 2
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
				@index = _.indexOf(@links, link) 

			return link
		
		Utils.stack(@links, @padding.stack)

		@fullHeight = _.last(@links)?.maxY + @padding.bottom ? @height

	
		# DEFINITIONS
		
		Utils.define @, "index", undefined, @_setIndex
		Utils.define @, "open", false, @_setOpen


		# EVENTS

		@onTap => @open = !@open


		# CLEANUP

		child.name = '.' for child in @children unless options.showSublayers

		@index = @start
		
		delete @initial
	

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

	_setIndex: (index) =>
		link = @links[index]

		@currentLabel.text = link?.text

		@emit("change:active", index, @prevIndex, @)

		@prevIndex = index
