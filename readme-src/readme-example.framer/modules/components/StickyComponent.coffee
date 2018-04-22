# StickyHeader

class exports.StickyComponent extends Layer
	constructor: (options = {}) ->

		unless options.parent?.parent instanceof ScrollComponent
			throw "StickyHeader must be a child of a ScrollComponent's content."
		
		_.defaults options,
			name: "Sticky Header"
			width: @app.width
			height: 64

		super options

		scroll = @parent.parent
		
		# update stickyheader record if header's y changes, but not if
		# that change occurred as a result of a sticky header action
		
		@_stickyAction = false
		
		@on "change:y", (y) ->
			return if @_stickyAction
			
			record = _.find(scroll.content._stickyHeaders, {layer: @})
			record?.y = @y

		# if parent already has sticky headers, add this record and bail
		
		if @parent._stickyHeaders?
			@parent._stickyHeaders.push({layer: @, y: @y})
			return
		
		# otherwise...
		
		app = @app
		
		scroll.content._stickyHeaders = [{layer: @, y: @y}]
		
		scroll.content.on "change:y", (y) ->
			tiptop = (app?.header?.maxY ? 0) - scroll.y # fix for expanding headers
			top = (-y + tiptop)
			
			for header, i in @_stickyHeaders
				layer = header.layer
				layer._stickyAction = true
				
				currentY = header.y + y - tiptop
				prev = @_stickyHeaders[i-1]?.layer
				
				if prev?
					prev._stickyAction = true
					
					if currentY < prev.height and layer.y > top
						prev.maxY = layer.y

					prev._stickyAction = false
					
				if currentY <= 0
					layer.y = top
			
				layer._stickyAction = false