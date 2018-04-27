###

Page View

A view that manages several pages through a nav bar.

@extends {Layer}	
@param {Object} options 			The pageview's attributes.
@param {function} options.preload 	A promise function that will run immediately before the View's onLoad.
@param {boolean} options.pages 		An object composed of key value pairs, where the key is the name of the page and the value is the callback used to create that page.	 	
@param {string} options.start 	
@param {number} options.placeholder

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
				
				page.callback = value ? => @placeholder(page, @, key)
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
				pages: @pages
				start: @start
				links: options.pages

			# update sectionview's start when active changes

			@navbar.on "change:active", (num) => @start = num
				
			new Promise options.preload.bind(@)
			.then resolve

		@onPreload = -> throw "PageView.preload is read only outside of the constructor. Use the preload option when creating a PageView instance."


		# EVENTS
			
		@onLoad @createContent
			
		@onPostload @updateContent


		# CLEANUP

		child.name = '.' for child in @children unless options.showSublayers


	# PRIVATE METHODS

	# PUBLIC METHODS

	createContent: =>
		_.map @pages, (page) =>
			view = @
			Utils.bind page, -> 
				page.callback(page, view)



createBlankPage = (layer, view, title) ->
	Utils.bind layer, ->
		
		new H4
			parent: @content
			y: 32
			x: Align.center
			text: title + '\ncontent'
			textAlign: "center"
			
		Utils.stack(@content.children, 16)