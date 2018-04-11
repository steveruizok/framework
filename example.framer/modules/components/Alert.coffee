Theme = require "components/Theme"
theme = undefined

# MODEL = 'switch'

class exports.Alert extends Layer
	constructor: (options = {}) ->
		if @app.alert
			@app.alert.close()

		@app.alert = @

		theme = Theme.theme
		@__constructor = true
		@__instancing = true

		# ---------------
		# Options

		_.defaults options,
			name: 'Alert'
			size: Screen.size
			backgroundColor: "rgba(4, 4, 16, 0.4)"
			clip: true
			opacity: 0
			animationOptions:
				time: .2
				colorModel: 'husl'
			
			
			title: "A short title is best"
			description: "A description should be a short and complete sentence."
			cancel: "Cancel"
			options: []
				# {text: "ButtonA", select: -> print 'tapped'}
				# {text: "ButtonB", select: -> print 'tapped'}
			# ]

		super options

		_.assign @,
			options: options.options

		# ---------------
		# Layers

		# _.assign @,

		@alert = new Layer
			parent: @
			width: 270
			height: 140
			point: Align.center()
			borderRadius: 14
			backgroundColor: "rgba(247, 247, 247, 0.82)"
			animationOptions: @animationOptions


		@titleLayer = new TextLayer
			name: "Title"
			parent: @alert
			x: 30
			y: 20
			width: @alert.width - 60
			fontSize: 17
			fontWeight: 500
			fontFamily: "Helvetica Neue"
			letterSpacing: -0.41
			lineHeight: 1.5
			color: '#000'
			textAlign: "center"
			text: options.title

		@descriptionLayer = new TextLayer
			name: "Description"
			parent: @alert
			y: @titleLayer.maxY + 4
			x: @titleLayer.x
			width: @titleLayer.width
			fontSize: 13
			fontWeight: 400
			fontFamily: "Helvetica Neue"
			letterSpacing: -0.1
			lineHeight: 1.3
			color: '#000'
			textAlign: "center"
			text: options.description

		startY = @descriptionLayer.maxY + 20

		@cancelHitArea = new Layer
			name: "Cancel Hit Area"
			parent: @alert
			y: startY
			width: @alert.width
			height: 44
			shadowY: -1
			shadowColor: "rgb(218, 218, 222)"
			backgroundColor: null

		@cancelTextLayer = new TextLayer
			parent: @cancelHitArea
			name: "Cancel TextLayer"
			y: Align.center()
			width: @cancelHitArea.width
			fontSize: 17
			fontWeight: 400
			fontFamily: "Helvetica Neue"
			letterSpacing: -0.41
			color: 'rgb(0, 122, 255)'
			textAlign: "center"
			text: options.cancel

		Utils.constrain(@cancelTextLayer, 'width')

		switch @options.length
			when 0
				@cancelTextLayer.fontWeight = 600
			when 1
				@cancelHitArea.width = @alert.width / 2

				buttonHitArea = new Layer
					name: "Button Hit Area"
					parent: @alert
					x: Align.right()
					y: startY
					width: @alert.width / 2
					height: 44
					shadowY: -1
					shadowX: -1
					shadowColor: "rgb(218, 218, 222)"
					backgroundColor: null

				buttonTextLayer = new TextLayer
					parent: buttonHitArea
					name: "Button TextLayer"
					y: Align.center()
					width: buttonHitArea.width
					fontSize: 17
					fontWeight: 500
					fontFamily: "Helvetica Neue"
					letterSpacing: -0.41
					color: 'rgb(0, 122, 255)'
					textAlign: "center"
					text: @options[0].text

				buttonHitArea.onTap =>
					@options[0].select()
					@close()
			else
				buttons = @options.map (option, i) =>
					buttonHitArea = new Layer
						name: "Button #{i} Hit Area"
						parent: @alert
						y: startY + (i * 44)
						width: @alert.width
						height: 44
						shadowY: -1
						shadowColor: "rgb(218, 218, 222)"
						backgroundColor: null

					buttonTextLayer = new TextLayer
						parent: buttonHitArea
						name: "Button TextLayer"
						y: Align.center()
						width: buttonHitArea.width
						fontSize: 17
						fontWeight: 500
						fontFamily: "Helvetica Neue"
						letterSpacing: -0.41
						color: 'rgb(0, 122, 255)'
						textAlign: "center"
						text: option.text

					buttonHitArea.onTap =>
						option.select()
						@close()

					return buttonHitArea

				@cancelHitArea.y = _.last(buttons).maxY
		
		Utils.contain(@alert, true)
		@alert.point = Align.center()
		@cancelHitArea.onTap @close

		# ---------------
		# Events  


		# ---------------
		# Definitions
		# 
		
		delete @__constructor
		
		#				Property	Initial value 	Callback 	Validation	 	Error
		# Utils.define @, 'value',	 options.value, @_setValue, _.isBoolean,	'Switch.value must be a boolean (true or false) or undefined.'

		delete @__instancing

		# ---------------
		# Kickoff
		
		child.name = '.' for child in @children unless options.showSublayers
		@_show()

	# ---------------
	# Private Methods
	
	_show: =>
		@animate
			opacity: 1

		@alert.animate
			opacity: 1
			options:
				delay: .15

	# ---------------
	# Public Methods


	close: =>
		@animate
			opacity: 0
			delay: .15

		@alert.animate
			opacity: 0

		@once Events.AnimationEnd, @destroy


	# ---------------
	# Special Definitions
