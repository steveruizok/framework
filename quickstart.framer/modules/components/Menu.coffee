###
Menu

An expanding menu of links.

@extends {Layer}
@param {Object} 	options 				The component's attributes.
@param {number} 	options.height	 	The menu's max expanded height
@param {number} 	options.color	 		The color to use for titles
@param {string} 	options.title	 		The menu's title
@param {boolean} 	options.open	 		Whether to start in an open state
@param {dividers} options.dividers	Whether to place dividers between sections
@param {number} 	options.tint	 		The color to use for links
@param {Object} 	options.padding		Padding for positioning links

	padding:
		top: <number>						Space to leave before the first link or title.
		right: <number>						Space to leave at the right of a link or title.
		bottom: <number>					Space to leave below each section.
		left: <number>						Space to leave at the left of a link or title.
		stack: <number>						Space to leave between links / titles.

@param {array} 		options.structure	The menu's links structure, made up of sections.

	structure: 
		[
			{								A section in the menu.
				title: <string>				The section's title (optional).
				links:						The section's links.
					<string>: <function>	The name of the link : the function to run when the link is tapped.
			}
		]

###

class exports.Menu extends ScrollComponent
	constructor: (options = {}) ->
		
		_.defaults options,
			name: "Menu"
			x: 4
			y: app.header?.statusBar?.maxY ? 0
			width: Screen.width
			height: Screen.height * .618
			shadowY: 1
			clip: true
			color: black
			backgroundColor: white
			scrollHorizontal: false
			marginTop: 0
			
			padding: {top: 56, bottom: 16, left: 20, right: 20, stack: 4}
			tint: black
			title: ""
			open: false
			dividers: true
			keepHidden: true
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
			name: 'Menu button'
			parent: options.parent
			x: options.x
			y: @y + 2 + options.marginTop
			size: 48
			padding: 12
			icon: "menu"
			color: @color
		
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
			y: 2 + options.marginTop
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
				y: options.padding.top + options.marginTop
				width: @width - options.padding.left - options.padding.right
				height: 2
				backgroundColor: null
			
			Utils.bind linksContainer, ->
			
				# section title

				if value.title?
					new Label
						name: "Section title"
						parent: @
						text: value.title
						width: @width
						color: @color
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
			y: @y
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
			unless @app.chrome and options.keepHidden
				@hidden = false
				return

			@hidden = !next.root
		
		@openButton.onTap => 
			return if @open
			@open = true
		
		@underlay.onTap =>
			return unless @open 
			@open = false
					
		@closeButton.onClick => 
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
			
			@underlay.bringToFront()
		
			@once Events.AnimationEnd, =>
				@openButton.visible = false

			return
	
		@openButton.visible = true	
				
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