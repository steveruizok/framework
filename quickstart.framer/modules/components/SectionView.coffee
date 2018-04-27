# { View } = require 'components/View'
# { Navbar } = require 'components/Navbar'

# Section View

class exports.SectionView extends View
	constructor: (options = {}) ->
		
		_.defaults options,
			name: "Section View"
			title: "Section View"
			# y: app.header?.maxY
			# height: app.height
			backgroundColor: white
			contentInset:
				top: 0
				bottom: 48
			sections:
				"First Page": undefined
				"Second Page": undefined
				"Third Page": undefined
			preload: new Promise (resolve, reject) -> resolve()
			start: 0
			clip: false
			placeholder: createBlankPage
		
		super options
		
		_.assign @,
			start: options.start 
			sections: options.sections
			pages: []
			placeholder: options.placeholder

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

			@pages = _.map @sections, (value, key) =>

				# Page

				page = new ScrollComponent
					name: key
					width: @width 
					height: @height - 44
					scrollHorizontal: false
					contentInset: {top: 0, bottom: 96}
					backgroundColor: @backgroundColor
					
				page.content.backgroundColor = null

				# Store back to object

				callback = value ? => @placeholder(page, @, key)

				@sections[key] =
					page: page
					callback: value?.callback ? callback

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
				links: @sections
				
			options.preload
			.then resolve


		# EVENTS
			
		@onLoad @createContent
			
		@onPostload @updateContent

	# PRIVATE METHODS

	# PUBLIC METHODS

	createContent: =>
		_.map @sections, (value, key) =>
			view = @
			Utils.bind value.page, -> 
				value.callback(value.page, view)



createBlankPage = (layer, view, title) ->
	Utils.bind layer, ->
		
		new H4
			parent: @content
			y: 32
			x: Align.center
			text: title + '\ncontent'
			textAlign: "center"
			
		Utils.stack(@content.children, 16)