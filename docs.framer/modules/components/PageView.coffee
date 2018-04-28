###

Page View

A view that manages several pages through a nav bar.

@extends {Layer}	
@param 	{Object}	options 			The pageview's attributes.
@param 	{function}	options.preload 	A promise function that will run immediately before the View's onLoad.
@param 	{string}	options.start 		The page index to start on.
@param 	{number}	options.placeholder	A function used for pages without content callbacks.
@param 	{boolean}	options.pages 		An object composed of key value pairs, where the key is the name of the page and the value is the callback used to create that page's content. This callback receives all data resolved from options.preload, the page, and the PageView instance. It is bound to the page context.

###

class exports.PageView extends View
	constructor: (options = {}) ->
		
		_.defaults options,
			name: "Section View"
			title: "Section View"
			backgroundColor: white
			clip: false
			contentInset:
				top: 0
				bottom: 48

			start: 0
			placeholder: createBlankPage
			preload: (resolve, reject) -> resolve()
			pages:
				"First Page": undefined
				"Second Page": undefined
				"Third Page": undefined
		
		super options

		_.assign @, 
			_.pick options, [
				'start'
				'placeholder'
				'tint'
				]
			{
				prevCurrent: undefined
				contentFuncs: {}
				links: {}
			}

		@content.backgroundColor = @backgroundColor

		# preload handler
				
		@onPreload (resolve, reject) ->	

			# Flow Component
			
			@flow = new FlowComponent
				name: "Flow"
				parent: @
				width: @width
				height: @height - 44
				y: 44
				contentInset: {top: 16, bottom: 32}
				clip: false
				
			Utils.constrain(@flow, "height")
			
			# Pages

			@pages = _.map options.pages, (value, key) =>

				# Page

				page = new ScrollComponent
					name: key
					parent: @
					width: @width 
					height: @height - 44
					scrollHorizontal: false
					contentInset: {top: 0, bottom: 96}
					backgroundColor: @backgroundColor
				
				@contentFuncs[key] = value ? @placeholder
				@links[key] = null

				page.content.backgroundColor = null
				page.sendToBack()

				# Swipe handlers
				
				goLeft = =>
					return if @navbar.active is 0
					@navbar.active--
					
				goRight = =>
					return if @navbar.active is @navbar.links.length - 1
					@navbar.active++
				
				# Swipe events

				page.on Events.SwipeLeftEnd, goRight
				page.on Events.SwipeRightEnd, goLeft
				
				# Method to turn off swipe events

				page.turnOffSwipes = ->
					@off Events.SwipeLeftEnd, goRight
					@off Events.SwipeRightEnd, goLeft
				
				page.sendToBack()

				return page
			
			# Nav Bar

			@navbar = new Navbar
				parent: @
				width: @width
				flow: @flow
				start: null
				links: @links


			# Events

			@app.on "transitionEnd", => Utils.pin @navbar, @app.header, 'bottom'

			@navbar.on "change:active", @_changePages
			

			# Run preload

			new Promise options.preload.bind(@)
			.then resolve


			# Kickoff

			@onPreload = -> throw "PageView.preload is read only outside of the constructor. Use the preload option when creating a PageView instance."

			@navbar.index = @start


		# EVENTS
			
		@onLoad @createContent
			
		@onPostload @updateContent


		# DEFINITIONS

		Utils.define @, "leftTransition", leftTransition
		Utils.define @, "rightTransition", rightTransition
		

		# CLEANUP

		child.name = '.' for child in @children unless options.showSublayers

		

	# PRIVATE METHODS

	_changePages: (index, prevIndex) =>
		@start = index
		page = @pages[index]

		transition = @_getTransition(index, prevIndex)
		
		@flow.transition(page, transition)
		@emit "change:current", page, @


	_getTransition: (index, prevIndex) =>
		if prevIndex > index
			return @rightTransition

		return @leftTransition


	# PUBLIC METHODS

	createContent: (data) =>
		_.map @pages, (page) =>
			@contentFuncs[page.name].bind(page, data, page, @)()


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

createBlankPage = (data, page, view) ->
	new H4
		parent: @content
		y: 32
		x: Align.center
		text: page.name + '\ncontent'
		textAlign: "center"
		
	Utils.stack(@content.children, 16)