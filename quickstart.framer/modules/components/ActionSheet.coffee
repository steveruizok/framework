###

Action Sheet

A dialog that lets users choose from a set of options.

@extends {Layer}
@param {Object} 	options 			The component's attributes.
@param {string} 	options.text 		The tooltip's text content.
@param {array}		options.position	The tooltip's position, relative to the content it explains. Valid options are: "above", "right", "below" or "left".

###

class exports.ActionSheet extends Layer
	constructor: (options = {}) ->
		if @app.actionsheet
			@app.actionsheet.close()

		@app.actionsheet = @

		# ---------------
		# Options

		_.defaults options,
			name: 'Action Sheet'
			size: Screen.size
			backgroundColor: "rgba(4, 4, 16, 0.7)"
			clip: true
			opacity: 0
			animationOptions:
				time: .2
			
			
			title: undefined
			options: [#]
				{text: "ButtonA", select: -> print 'tapped', warn: true}
				{text: "ButtonB", select: -> print 'tapped'}
			]

		super options

		_.assign @,
			options: options.options

		# LAYERS

		# cancel
		
		@cancelButton = new Layer
			parent: @
			x: 16
			y: Align.bottom(-16)
			width: Screen.width - 32
			height: 56
			point: Align.center()
			borderRadius: 14
			backgroundColor: "rgba(247, 247, 247, 0.82)"
			animationOptions: @animationOptions

		cancelLabel = new TextLayer
			parent: @cancelButton
			point: Align.center()
			fontSize: 20
			fontFamily: "Helvetica Neue"
			fontWeight: 600
			color: "#027aff"
			text: "Cancel"

		# buttons

		@buttonsContainer = new Container
			parent: @
			x: 16
			y: Align.bottom(-88)
			width: Screen.width - 32
			height: 56
			point: Align.center()
			borderRadius: 14
			backgroundColor: "rgba(247, 247, 247, 0.82)"
			animationOptions: @animationOptions
			clip: true
			padding:
				stack: 0

		# title

		if options.title?
			titleArea = new Layer
				name: "Title Area"
				parent: @buttonsContainer
				width: @buttonsContainer.width
				height: 56
				backgroundColor: null

			titleTextLayer = new TextLayer
				parent: titleArea
				name: "Button TextLayer"
				point: Align.center()
				fontSize: 13
				fontFamily: "Helvetica Neue"
				fontWeight: 400
				color: "#8f8f8f"
				text: options.title

			_.assign titleArea.style,
				"border-bottom": "#{Utils.px(1)} solid rgba(0,0,0,.16)"
		
		# buttons

		buttons = @options.map (option, i) =>
			buttonHitArea = new Layer
				name: "Button Hit Area"
				parent: @buttonsContainer
				width: @buttonsContainer.width
				height: 56
				backgroundColor: null

			_.assign buttonHitArea.style,
				"border-bottom": "#{Utils.px(1)} solid rgba(0,0,0,.16)"

			buttonTextLayer = new TextLayer
				parent: buttonHitArea
				name: "Button TextLayer"
				point: Align.center()
				fontSize: 20
				fontFamily: "Helvetica Neue"
				fontWeight: 400
				color: if option.warn then "f53c3d" else "#027aff"
				text: option.text

			buttonHitArea.onTap =>
				try option.select()
				@close()

			return buttonHitArea
		

		@buttonsContainer.stack()
		@buttonsContainer.contain()
		@buttonsContainer.y = Align.bottom(-88)

		# EVENTS 


		# DEFINITIONS
		

		# KICKOFF
		
		child.name = '.' for child in @children unless options.showSublayers
		@_show()

	# ---------------
	# Private Methods
	
	_show: =>
		@animate
			opacity: 1

		@cancelButton.animate
			opacity: 1
			options:
				delay: .15

		@buttonsContainer.animate
			opacity: 1
			options:
				delay: .15

	# ---------------
	# Public Methods


	close: =>
		@cancelButton.animate
			opacity: 0
			options:
				delay: .15

		@buttonsContainer.animate
			opacity: 0
			options:
				delay: .15

		@cancelButton.once Events.AnimationEnd, => 
			@destroy() 
			@buttonsContainer.destroy() 
			@cancelButton.destroy()


	# ---------------
	# Special Definitions