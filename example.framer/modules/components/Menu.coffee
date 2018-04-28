###
Menu

An expanding menu of links.

@extends {Layer}
@param {Object} options 			The menu's attributes.@param {number} options.height	 	The menu's max expanded height
@param {number} options.color	 	The color to use for titles
@param {Object} options.structure	The menu's links structure
@param {string} options.title	 	The menu's title
@param {boolean} options.open	 	Whether to start in an open state
@param {dividers} options.dividers	Whether to place dividers between sections
@param {number} options.tint	 	The color to use for links
@param {Object} options.padding		Padding for positioning links
@param {Object} options.showSublayers

###
class exports.Menu extends ScrollComponent
	constructor: (options = {}) ->
		
		_.defaults options,
			parent: @app.header
			name: "Menu"
			x: 4
			y: (app.header?.statusBar.maxY ? app.header?.maxY ? 0)
			width: Screen.width
			height: Screen.height * .618
			shadowY: 1
			clip: true
			color: black
			backgroundColor: white
			scrollHorizontal: false
			
			padding: {top: 56, bottom: 16, left: 20, right: 20, stack: 4}
			tint: black
			title: ""
			open: false
			dividers: true
			structure:
				0:
					title: "Menu"
					links:
						"primary link 1": -> print 'hello world'
						"primary link 2": undefined
						"primary link 3": undefined
				1:
					title: undefined
					links:
						"secondary link 1": undefined
						"secondary link 2": undefined
						"secondary link 3": undefined
				2:
					title: undefined
					links:
						"sign up": undefined
						"sign in": undefined
		
		super options

		@app.menu = @

		_.defaults options.padding,
			top: 0
			bottom: 0
			left: 0
			right: 0
			
		_.assign @,
			parent: null
			x: 0
			height: 2
			maxHeight: _.clamp(options.height, 40, Screen.height - @y)
		
		# LAYERS

		# open button


		@openButton = new Icon
			name: if options.showSublayers then 'Menu open button' else "."
			parent: options.parent
			x: options.x
			y: @y + 2
			size: 48
			padding: 12
			icon: "menu"
		
		# header content

		@headerContainer = new Layer
			name: "Header Container"
			parent: @
			y: -1
			width: @width
			height: 1
			backgroundColor: @backgroundColor
		
		@titleLayer = new H4
			name: "Title"
			parent: @headerContainer
			x: Align.center()
			text: options.title
			color: @color
		
		@closeButton = new Icon
			name: "Menu close button"
			parent: @headerContainer
			color: @color
			icon: "close"
			x: options.x
			y: 2
			size: 48
			padding: 12

		@titleLayer.midY = @closeButton.midY

		Utils.contain(@headerContainer, true, 0, 4)

		# sections content

		menu = @
		divider = undefined
		
		@sections = _.map options.structure, (value, key) =>
		
			linksContainer = new Layer
				parent: @content
				name: "Links container"
				color: @color
				x: options.padding.left
				y: options.padding.top
				width: @width - options.padding.left - options.padding.right
				height: 2
				backgroundColor: null
			
			Utils.bind linksContainer, ->
			
				# section title

				if value.title?
					new H4
						name: "Section title"
						parent: @
						text: value.title
						width: @width
						padding: 
							top: options.padding.stack
							bottom: options.padding.stack
				
				# section links

				linksContainer.links = _.map value.links, (value, key) =>
					link = new H5Link
						name: "Link"
						parent: @
						width: @width
						text: key
						color: options.tint
					
					link.value = value ? -> null

					return link
			
				# section divider

				if options.dividers
					divider = new Layer
						name: "Divider"
						parent: @
						width: @width
						height: 1
						backgroundColor: new Color(@color).alpha(.15)
			
			Utils.stack(linksContainer.children, options.padding.stack)
			Utils.contain(linksContainer, true, 0, options.padding.bottom)
			
			return linksContainer

		# scrim

		@scrim = new Layer
			parent: @
			y: Align.bottom()
			height: 32
			gradient:
				start: @backgroundColor
				end: new Color(@backgroundColor).alpha(0)

		Utils.constrain(@scrim, 'bottom')
	
		# underlay (tap to close menu)

		@underlay = new Layer
			parent: app
			name: "menu underlay"
			size: Screen.size
			visible: false
			backgroundColor: "rgba(0,0,0,.16)"
		
		# cleanup

		divider?.destroy() # remove last divider
		
		Utils.stack(@sections, options.padding.stack)
		
		@updateContent()
		
		child.name = '.' for child in @children unless options.showSublayers
		

		# DEFINITIONS
		
		Utils.define @, "hidden", false, @_showHidden
		Utils.define @, "open", options.open, @_showOpen
		

		# EVENTS

		@sections.forEach (section) =>
			section.links.forEach (link) =>
				link.onSelect => 
					@open = false
					@once Events.AnimationEnd, link.value

		@app.on "transitionStart", (prev, next, options) =>
			@hidden = true

		@app.on "transitionEnd", (prev, next, options) =>
			@hidden = !next.root
		
		@openButton.onTap => 
			return if @open 
			@open = true
		
		@underlay.onTap =>
			return unless @open 
			@open = false
					
		@closeButton.onTap => 
			return unless @open 
			@open = false
	

	# PRIVATE METHODS

	_showHidden: (bool) =>
		@openButton.animateStop()
		
		if bool
			@openButton.animate
				opacity: 0
				options: 
					time: .2

			@openButton.once Events.AnimationEnd, =>
				return unless @hidden
				@openButton.visible = false

			return

		@openButton.visible = true

		@openButton.animate
			opacity: 1
			options: 
				time: .3
	

	_showOpen: (bool) => 
		if bool
			@visible = true
			@underlay.visible = true
			
			@height = 128

			@openButton.animate
				opacity: 0
				options:
					time: .15

			@animate
				height: @maxHeight
				opacity: 1
				options:
					time: .25
			
			@underlay.animate
				opacity: 1
				options:
					time: .15
			
			@underlay.placeBefore(app.current)
			return
				
		@once Events.AnimationEnd, =>
			@visible = false
			@underlay.visible = false
			@underlay.sendToBack()
		
		@underlay.animate
			opacity: 0
			options:
				time: .2

		@openButton.animate
			opacity: 1
			options:
				time: .15
			
		@animate
			height: 1
			opacity: 0
			options:
				time: .2