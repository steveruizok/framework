###
Toolbar

An footer with links to views.

@extends {Layer}
@param {Object} options 			The toolbar's attributes.@param {number} options.height	 	The menu's max expanded height
@param {string} options.color 		The color to use for the toolbar's icons and labels.
@param {string} options.tint 		The color to use for the toolbar's accents colors.
@param {number} options.border 		The width of the toolbar's top border.
@param {boolean} options.indicator	Whether to use an indicator to show the active icon.
@param {number} options.start		Which page to start on.
@param {boolean} options.labels		Whether to use labels in the toolbar.
@param {Object} options.links		
@param {array} options.pages
@param {Object} options.flow
###

class exports.Toolbar extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: "Toolbar"
			y: Align.bottom()
			width: Screen.width
			height: 1
			backgroundColor: white
			color: black
			tint: black
			clip: true
			animationOptions:
				time: .25
			start: 0
			hidden: false
			border: 4
			indicator: false
			labels: false
			links:
				"Home":
					icon: "home"
					view: undefined
					loader: false
				"Second":
					icon: "flag"
					view: undefined
					loader: true
			pages: []
			flow: @app
		
		super options
		
		_.assign @,
			start: options.start
			pages: options.pages
			flow: options.flow
			links: options.links
			labels: options.labels
			prevCurrent: undefined
			tint: options.tint
			hasIndicator: options.indicator
			style:
				borderTop: "#{Utils.px(options.border)} solid #{options.tint}"
		
		# LAYERS
		
		# links

		linksContainer = new Layer
			name: "Links"
			parent: @
			backgroundColor: null
		
		@links = _.map options.links, (value, key) =>
			
			value.view?.root = true

			# icon

			link = new Icon
				name: "."
				parent: linksContainer
				size: 58
				padding: 15
				color: @color
				icon: value.icon
				clip: false
				animationOptions:
					time: .25
					
			_.assign link,
				view: value.view
				loader: value.loader
			
			# label
			
			if options.labels
				label = new Micro
					parent: link
					text: key
					x: Align.center()
					y: Align.bottom(2)
					color: @color
					opacity: 1
					
				Utils.linkProperties link, label, "opacity"
				Utils.linkProperties link, label, "color"

			return link

		@indicator = new SVGLayer
			name: "Indicator"
			parent: @
			x: Align.center()
			y: -1
			size: 16
			svg: "<svg><path d='M 0,0 L 8,8 16,0 Z'/></svg>"
			fill: options.tint
			visible: @hasIndicator
			animationOptions:
				time: .25
				
		Utils.offsetX(@links, 8)
		Utils.contain(linksContainer)
		linksContainer.x = Align.center()
		
		
		# DEFINITIONS
		
		Utils.define @, "hidden", options.hidden, @_showHidden
		Utils.define @, "active", undefined, @_setActiveLink

		# cleanup
		
		_.defer =>
			@height = 64
			@y = Align.bottom()
			linksContainer.y = Align.center(if options.labels then -10 else 0)
			
			app.rootView = @links[@start].view
			@active = @start
		

		# EVENTS


		@links.forEach (link, i) =>
			link.onTap =>
				@active = i

		@app.on "transitionEnded", =>
			@_transitioning = false

		@app.on "transitionStart", (layer) =>
			link = _.find(@links, (l) -> l.view is layer)
			if link? then @_showActive(link)
			@_active = @links.indexOf(link)
	

	# PRIVATE METHODS

	_showHidden: (bool) =>
		if bool
			@animate
				y: @app.height
				options:
					time: .2
			return

		@animate
			y: Align.bottom()
			options:
				time: .3


	_setActiveLink: (index) =>
		return unless index >= 0
		
		link = @links[index]
		currentIndex = _.indexOf(@links, @prevCurrent) ? -1
		transition = @_getTransition(index, currentIndex)
		@_showActive(link)
		
		if link.view? and link.view isnt @app.current
			@_transitioning = true
			@app.showNext link.view, link.loader,
				transition: transition
			@emit "change:current", @pages[index]
		
		@prevCurrent = link
	

	_showActive: (link) =>
		@indicator.animate
			midX: link.x + (link.width / 2) + link.parent.x
		
		bumpDown = @labels and @hasIndicator

		link.animate
			opacity: 1
			y: Align.center(if bumpDown then 3 else 0)
		
		for sib in _.without(@links, link)
			sib.animate
				opacity: .8
				y: Align.center()
	

	_getTransition: (nextIndex, currentIndex) =>
		
		leftTransition = (nav, layerA, layerB, overlay) =>
			transition =
				layerA:
					show:
						x: 0
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
						
		rightTransition = (nav, layerA, layerB, overlay) =>
			transition = 
				layerA:
					show:
						x: 0
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
		
		if currentIndex > nextIndex
			return rightTransition
		else
			return leftTransition
	

	# DEFINITIONS

	@define "current",
		get: -> 
			return @links[@active]