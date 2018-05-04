###

Container

A layer designed to contain other layers.

@extends {Layer}
@param	{Object}	options 			The component's attributes.
@param 	{Object}	options.padding 	The padding to use when containing the container's children.
	
	padding:
		top: <number>		The space to leave at the top of the container.  
		right: <number>		The space to leave at the right of the container.
		bottom: <number>	The space to leave at the bottom of the container.
		left: <number>		The space to leave at the left of the container.
		stack:				The vertical space to leave between container's children.   


Container.stack() ->
	Stacks the container's children, according to its padding.stack property.

Container.contain([shrink <boolean>])	->
	Re-sizes the container based on its padding and the placement of the container's children.

###

class exports.Container extends Layer
	constructor: (options = {}) ->

		_.defaults options,
			name: 'Container'
			height: 8
			width: 8
			backgroundColor: null
			animationOptions:
				time: .2
			padding: { top: 0,  bottom: 0, left: 0, right: 0, stack: 0 }

		_.defaults options.padding,
			top: 0, 
			bottom: 0, 
			left: 0, 
			right: 0 
			stack: 0

		super options

		_.assign @, 
			padding: options.padding

		# LAYERS
		

		# EVENTS


		# DEFINITIONS


		# KICKOFF


 		# CLEANUP


	# PRIVATE METHODS

	
	# PUBLIC METHODS

	stack: => Utils.stack(@children, @padding.stack)

	hug: =>
		for layer in @children
			layer.x += @padding.left
			layer.y += @padding.top

		@width = _.maxBy(@children, 'maxX').maxX + @padding.right
		@height = _.maxBy(@children, 'maxY').maxY + @padding.bottom


	contain: (shrink = false) =>
		if @padding.top > 0 and _.find(@children, (c) => c.y < @padding.top)?
			for child in @children
				child.y += @padding.top

		if @padding.left > 0 and _.find(@children, (c) => c.x < @padding.left)?
			for child in @children
				child.x += @padding.left
		
		if shrink
			Utils.contain(@, false, @padding.right, @padding.bottom)
			return
		
		Utils.contain(@, true, @padding.right, @padding.bottom)


	@wrap = (layer, options = {}) ->
		return wrapComponent(layer, options)




# Wrap a layer

wrapComponent = (layer, options = {}) ->

	if not (layer instanceof Layer)
		throw new Error("ScrollComponent.wrap expects a layer, not #{layer}. Are you sure the layer exists?")

	
	Utils.bind layer, ->
		@padding ?= {
			top: 0, 
			bottom: 0, 
			left: 0, 
			right: 0 
			stack: 0
		}

		@stack = =>
			Utils.stack(@children, @padding.stack)


		@hug = =>
			for layer in @children
				layer.x += @padding.left
				layer.y += @padding.top

			@width = _.maxBy(@children, 'maxX').maxX + @padding.right
			@height = _.maxBy(@children, 'maxY').maxY + @padding.bottom


		@contain = (shrink = false) =>
			if @padding.top > 0 and _.find(@children, (c) => c.y < @padding.top)?
				for child in @children
					child.y += @padding.top

			if @padding.left > 0 and _.find(@children, (c) => c.x < @padding.left)?
				for child in @children
					child.x += @padding.left
			
			if shrink
				Utils.contain(@, false, @padding.right, @padding.bottom)
				return
			
			Utils.contain(@, true, @padding.right, @padding.bottom)
		
		