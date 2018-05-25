layout = undefined

class exports.Layout extends Layer
	constructor: (options = {}) ->
		_.defaults options,
			name: "Layout"
			width: Screen.width
			height: Screen.height
			visible: false
			showLayers: false
			
			offset: null
			columns: true
			rows: false
			center: true
			numberOfColumns: 4
			gutterWidth: 16
			columnWidth: 64
			gutterHeight: 16
			rowHeight: 5
			horizontalLines: false
			stroke: false
			dark: "rgba(155,155,155,.32)"
			light: "rgba(155,155,155,.32)"
			hidden: false
		
		_.assign options,
			backgroundColor: null
			borderColor: null
			borderWidth: null
		
		super options

		layout = @
		
		
		# Set Layer definitions

		Layer.define "position",
			get: -> @_position
			set: (options = {}) ->
				@_position ?= {}
				_.assign @_position, options

				if @_position.column?
					@layoutColumn = @_position.column
				if @_position.row?
					@layoutRow = @_position.row
				if @_position.width?
					@layoutWidth = @_position.width
				if @_position.height?
					@layoutHeight = @_position.height

			configurable: true


		Layer.define "layoutColumn",
			get: -> @_layout_column ? @x / ((layout.columnWidth + layout.gutterWidth) - layout.gutterWidth)
			set: (num) ->
				num = _.clamp(num, 0, layout.numberOfColumns - 1)
				@_layout_column = num
				@x = (layout._startX + (layout.columnWidth + layout.gutterWidth) * num)
				@emit "change:layoutColumn", @_layout_column, @
			configurable: true


		Layer.define "layoutRow",
			get: -> @_layout_row ? @y / ((layout.rowHeight * layout.gutterHeight) - layout.gutterHeight)
			set: (num) ->
				@_layout_row = num
				@y = (((layout.rowHeight * layout.gutterHeight) + layout.gutterHeight) * num)
				@emit "change:layoutRow", @_layout_row, @
			configurable: true


		Layer.define "layoutWidth",
			get: -> @_layout_width ? @width / (layout.columnWidth + layout.gutterWidth)
			set: (num) ->
				@_layout_width = num
				@width = layout.getWidth(num)
				@emit "change:layoutWidth", @_layout_width, @
			configurable: true


		Layer.define "layoutHeight",
			get: -> @_layout_height ? @height / (layout.rowHeight * layout.gutterHeight)
			set: (num) ->
				@_layout_height = num
				@height = layout.getHeight(num)
				@emit "change:layoutHeight", @_layout_height, @
			configurable: true

		# LAYERS
		
		@layers = {}
		
		for key, value of options
			@[key] = value
			
		offset = (layers, offset, axis = "y") ->
			for layer, i in layers
				continue if i is 0
				layer[axis] = layers[i-1]["max" + _.toUpper(axis)] + offset
		
		# columns
		
		if @columns
		
			startX = 0
			
			if @center
				totalWidth = @numberOfColumns * (@columnWidth + @gutterWidth) - @gutterWidth
				startX = (@width - totalWidth) / 2
				
			if @offset
				startX = @offset
			
			@_startX = startX

			@layers.columns = _.range(@numberOfColumns).map (col, i) =>
				layer = new Layer
					parent: @
					x: startX
					height: @height
					width: @columnWidth
					backgroundColor: @light
				
				if @stroke
					layer.props = 
						backgroundColor: null
						borderWidth: 1
						borderColor: @dark
					
				return layer
			
			offset(@layers.columns, @gutterWidth, "x")
		
		# rows
		
		if @rows
		
			rowCount = _.ceil(@height / ((@rowHeight * @gutterHeight) + @gutterHeight))
			
			@layers.rows = _.range(rowCount).map (col, i) =>
				layer = new Layer
					parent: @
					width: @width
					height: @rowHeight * @gutterHeight
					backgroundColor: @light
				
				if @stroke
					layer.props = 
						backgroundColor: null
						borderWidth: 1
						borderColor: @dark
					
				# horizontal lines
				
				if @horizontalLines
					layer.layers = {}
					layer.layers.horizontalLines = _.range(@rowHeight - 1).map =>
						horizontalLine = new Layer
							parent: layer
							y: @gutterHeight
							width: layer.width
							height: 1
							backgroundColor: @light
					
					offset(layer.layers.horizontalLines, @gutterHeight, "y")
				
				return layer
				
			offset(@layers.rows, @gutterHeight, "y")
		
		# hide child names
		
		unless @showLayers
			child.name = "." for child in @children
		
		# bring to front
		@_hidden = @hidden
		
		@_showHidden(@_hidden)
		
		# EVENTS
		
		document.body.onkeypress = (event) =>
			event.preventDefault()
			evtobj = if window.event? then event else e
			if evtobj.code is "KeyL" and evtobj.altKey
				@_hidden = !@_hidden
				@_showHidden(@_hidden)
	
	# PRIVATE METHODS
	
	_showHidden: (bool) =>
		if bool
			@visible = false
			@sendToBack()
			return
			
		@visible = true
		@bringToFront()
		
	
	# PUBLIC METHODS
	
	getWidth: (num, gutter = false) =>
		return unless @columns
		return ((@columnWidth + @gutterWidth) * num) + (if gutter then 0 else -@gutterWidth)
	
	getHeight: (num, gutter = false) => 
		return unless @rows
		return (((@rowHeight * @gutterHeight) + @gutterHeight) * num) + (if gutter then 0 else -@gutterHeight)
		
	column: (num) => 
		return unless @columns
		return @layers.columns[num].frame
	
	row: (num) => 
		return unless @rows
		return @layers.rows[num].frame
		
	line: (num) => 
		return unless @rows
		return @gutterHeight * num
		
	Layer: (options = {}) =>
			
		if options.column?
			options.x = @column(options.column)?.x ? options.x
		
		if options.row?
			options.y = @row(options.row)?.y ? options.y
	
		if options.width?
			options.width = @getWidth(options.width) ? options.width
	
		if options.height?
			options.height = @getHeight(options.height) ? options.height
			
		return new Layer(options)




