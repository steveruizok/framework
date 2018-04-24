Theme = require "components/Theme"
theme = undefined

MODEL = 'switch'

class exports.Switch extends Layer
	constructor: (options = {}) ->
		theme = Theme.theme
		@__constructor = true
		@__instancing = true

		# ---------------
		# Options

		_.defaults options,
			name: 'Switch'
			width: 50
			height: 30
			borderRadius: 15
			clip: true
			borderWidth: 1
			borderColor: yellow
			animationOptions:
				time: .2
				colorModel: 'husl'
			
			value: false
			icon: undefined

		
		super options

		# ---------------
		# Layers

		# _.assign @,

		@knob = new Layer
			parent: @
			borderRadius: "50%"
			size: 27
			y: Align.center(1)
			animationOptions: @animationOptions

		@knobIcon = new Icon 
			parent: @knob
			point: Align.center
			size: @knob.width - 12
			animationOptions: @animationOptions

		Utils.linkProperties @knob, @knobIcon, "color"

		# ---------------
		# Events  

		@onTap (event) =>
			return if Math.abs(event.offset.x > 10)
			return if Math.abs(event.offset.y > 10)
			@value = !@value

		# ---------------
		# Definitions
		# 
		
		delete @__constructor
		
		#				Property	Initial value 	Callback 	Validation	 	Error
		Utils.define @, 'theme', 	'default', 		@_setTheme,	 _.isString,	"Switch.theme must be a string."
		Utils.define @, 'value',	 options.value, @_setValue, _.isBoolean,	'Switch.value must be a boolean (true or false) or undefined.'
		Utils.define @, 'icon',		 options.icon,	@_setIcon,	_.isString,		'Switch.icon must be a string.'

		delete @__instancing

		# ---------------
		# Cleanup
		
		child.name = '.' for child in @children unless options.showSublayers

	# ---------------
	# Private Methods

	_setIcon: (string = "") =>
		@knobIcon.icon = string

	_setValue: (bool) =>
		if bool
			@theme = "active"
			return

		@theme = "default"
	
	_setTheme: (value) =>
		@animateStop()
		props = theme[MODEL][value]
		knobProps = theme[MODEL][value].knob
		if @__instancing then @props = props else @animate props
		if @__instancing then @knob.props = knobProps else @knob.animate knobProps

	# ---------------
	# Public Methods

	# ---------------
	# Special Definitions

	@define "toggled",
		get: -> return @value
		set: (bool) ->
			return if @__constructor
			@value = bool


