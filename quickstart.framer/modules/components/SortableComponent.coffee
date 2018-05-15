class exports.SortableComponent extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: 'Sortable Component'
			animationOptions:
				time: .31
			clip: false
			
			defaultState: 
				scale: 1
				shadowY: 0
				shadowBlur: 0
			draggingState: 
				scale: 1.07
				shadowY: 6
				shadowBlur: 16
			vertical: true
			horizontal: true
			delay: .25
			shared: []
			closeGaps: true
		
		super options
		
		_.assign @,
			_isSorting: false
			positions: []
		
		# LAYERS
		
		
		# EVENTS
		
		@on "change:parent", @_setParentScroll
		@on "change:children", @_updateChildren
		@_context.on "layer:destroy", @_checkForLostChildren
		
		
		# DEFINITIONS
		
		Utils.define @, "defaultState",	options.defaultState,	@_updateStates
		Utils.define @, "draggingState",options.defaultState, 	@_updateStates
		Utils.define @, "horizontal",	options.horizontal
		Utils.define @, "vertical",		options.vertical
		Utils.define @, "delay",		options.delay
		Utils.define @, "shared",		options.shared
		Utils.define @, "closeGaps",	options.closeGaps


		@_setParentScroll()


	# PRIVATE METHODS

	_setParentScroll: =>
		if @parent?.parent instanceof ScrollComponent
			@_scrollParent = @parent.parent
			@_freezeVertical = @_scrollParent.scrollVertical
			@_freezeHorizontal = @_scrollParent.scrollVertical


	_setSorting: (bool) =>
		@_isSorting = bool
		@emit "change:isSorting", @_isSorting, @
		
		return unless @_scrollParent

		@_scrollParent.scrollVertical = if @_freezeVertical then !bool
		@_scrollParent.scrollHorizontal = if @_freezeHorizontal then !bool
	

	_checkForLostChildren: (layer) =>
		if layer.parent is @
			@emit "change:children", {added: [], removed: [layer]}
	
	
	_updateChildren: (layers) =>
		# scrub up layers that were removed as children
		for layer in layers.removed
			layer.position.layer = undefined
			Utils.delay 0, =>
				unless layer.parent instanceof SortableComponent
					@_unwrapLayer(layer) 

		# update positions
		if layers.removed.length > 0 and @positions.length > 0
			# _.last(@children)?.once Events.AnimationEnd, @_makePositions
			
			for child, i in @children
				@_moveToPosition(child, @positions[i], true)
			return
		
		# make positions if new positions were added
		return if layers.added[0]?._sortableWrapped

		for layer in layers.added
			@makePosition(layer.frame, layer)
		
	
	
	_updateStates: (state) =>
		for position in @positions
			position.layer.states =
				default: @defaultState
				dragging: @draggingState
	
	
	_moveToPosition: (layer, position, animate = true ) =>
		layer.position = position
		layer.position.layer = layer

		props =
			midY: position.midY
			midX: position.midX
		
		if animate
			layer.animate props
			return
	
		layer.props = props
		

	_wrapLayer: (layer) =>
		return if layer._sortableWrapped

		layer.states =
			default: @defaultState
			dragging: @draggingState
		
		layer.stateSwitch('default')
		
		_.defaults layer.animationOptions, @animationOptions
		
		_.assign layer.draggable,
			enabled: true
			momentum: false
			horizontal: @horizontal
			vertical: @vertical
			propagateEvents: true
		
		layer.on Events.DragStart, @_startSearch
		layer.on Events.Drag, @_duringSearch
		layer.on Events.DragEnd, @_endSearch
		
		layer.handle?.on Events.Tap, (event) -> event.stopPropagation()
		
		layer._sortableWrapped = true


	_unwrapLayer: (layer) =>
		layer.off Events.TouchStart, @_startSearch
		layer.off Events.Drag, @_duringSearch
		layer.off Events.DragEnd, @_endSearch
		layer.handle?.off Events.Tap, (event) -> event.stopPropagation()
		
		delete layer._sortableWrapped
	
	
	_startSearch: (event, layer) =>
		if Utils.isMobile()
			event = Events.touchEvent(event)
			
		if layer.handle?
			return unless Utils.pointInFrame(
				event.contextPoint, 
				layer.handle.screenFrame
				)

		@_setSorting(true)

		layer._isSorting = true
		layer.bringToFront()
		layer.animate "dragging"
		
		layer.position.layer = undefined
	
	
	_duringSearch: (event, layer) =>
		unless layer._isSorting
			layer.props = 
				midX: layer.position.midX
				midY: layer.position.midY
	
		hoverPosition = @_getHoverPosition(layer)

		Utils.delay @delay, =>
			return unless layer._isSorting
			delayPosition = @_getHoverPosition(layer)
			if hoverPosition is delayPosition
				@_updatePositions(layer, hoverPosition)
	
	
	_getHoverPosition: (layer) =>
		hoverPosition = _.head _.sortBy @positions, (p) ->
			Utils.pointDistance(
				{x: p.midX, 	y: p.midY}, 
				{x: layer.midX, y: layer.midY}
			)
	
	_getEmptyPosition: (startIndex = 0, endIndex = @positions.length - 1) =>
		emptyPosition = _.find(@positions[startIndex..endIndex], (p) ->
			return _.isUndefined(p.layer)
			)
	
	_updatePositions: (layer, hoverPosition) =>
		emptyPosition = @_getEmptyPosition()
		
		return unless emptyPosition?
		return if emptyPosition.index is hoverPosition.index

		if hoverPosition.index < emptyPosition.index
			bumpPositions = @positions.slice()[hoverPosition.index...emptyPosition.index].reverse()
			direction = 1
		else if hoverPosition.index > emptyPosition.index
			bumpPositions = @positions.slice()[(emptyPosition.index + 1)..hoverPosition.index]
			direction = -1
		
		newPositions = bumpPositions.map (position) =>
			newPos = @positions[position.index + direction]
			if position.layer?
				layer = position.layer
				position.layer = undefined
				@_moveToPosition( layer, newPos, true)
	
	
	_endSearch: (event, layer) =>
		return if not layer._isSorting

		_.defer =>
			@_setSorting(false)
			delete layer._isSorting

			position = if @closeGaps then @_getEmptyPosition() else @_getHoverPosition(layer)
			
			@_moveToPosition(layer, position)
			layer.animate 'default'
			@emit "change:current", @current, @


	# PUBLIC METHODS

	adopt: (layer) =>
		emptyPosition = @_getEmptyPosition()
		return unless emptyPosition?

		layer.parent = @
		layer.position = emptyPosition
		emptyPosition.layer = layer


	makePosition: (frame, layer) =>

		position =
			index: @positions.length
			layer: undefined
			midY: frame.y + frame.height / 2
			midX: frame.x + frame.width / 2
	
		if layer?
			position.layer = layer
			layer.position = position
			@_wrapLayer(layer)
		
		@positions.push(position)

		return position


	setPosition: (layer, index, animate = true) ->

		index ?= @positions.indexOf @_getEmptyPosition()

		layer.parent = @
		layer.x -= @x
		layer.y -= @y

		position = @positions[index] ? throw "SortableComponent: No position found at that index."
		@_moveToPosition(layer, position, animate)


	resetPositions: =>
		@positions = []
		@children.forEach (child) => 
			@makePosition(child.frame, child)

	# SPECIAL DEFINITIONS
	
	@define "isSorting",
		get: -> return @_isSorting

	@define "current",
		get: -> return @positions.map (p) -> return p.layer
