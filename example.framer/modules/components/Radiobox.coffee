Theme = require "components/Theme"
theme = undefined


class exports.Radiobox extends Layer
	constructor: (options = {}) ->
		theme = Theme.theme

		# ---------------
		# Options

		_.defaults options,
			name: 'Radiobox'
			height: 32
			width: 32
			animationOptions:
				time: .2

			checked: false
			disabled: false
			group: undefined
			label: undefined

		_.assign options,
			backgroundColor: null

		@group = options.group ? throw 'Radiobox requires a group property (an array).'

		@customOptions = {
			color: options.color
		}

		options.labelLayer = options.label
		delete options.label

		super options

		@props =
			x: @x - 4
			y: @y - 4


		# ---------------
		# Layers
		
		@iconLayer = new Icon
			parent: @
			point: Align.center
			icon: 'radiobox-blank'
			color: options.color

		Utils.linkProperties @, @iconLayer, "color"


		# ---------------
		# Events

		@onTap => @checked = true
		@onMouseOver => @hovered = true
		@onMouseOut => @hovered = false


		# ---------------
		# Definitions

		isLayer = (value) -> return value.on?
		
		Utils.define @, 'theme', 'default', @_setTheme
		Utils.define @, 'checked', options.checked, @_showChecked, _.isBoolean, 'Checkbox.checked must be a boolean (true or false)'
		Utils.define @, 'hovered', false, @_showHovered, _.isBoolean, "Checkbox.hovered must be a boolean (true or false)."
		Utils.define @, 'error', options.disabled, @_showError, _.isBoolean, "Checkbox.error must be a boolean (true or false)."
		Utils.define @, 'disabled', options.disabled, @_showDisabled, _.isBoolean, "Checkbox.disabled must be a boolean (true or false)."
		Utils.define @, 'labelLayer', options.labelLayer, @_setLabelLayer, isLayer, "Checkbox.labelLayer must be a Layer type."
	
	# ---------------
	# Private Methods

	_setTheme: (value) =>
		@animateStop()
		props = @customTheme?[value] ? _.defaults(
			_.clone(@customOptions), 
			theme.radiobox[value]
			)

		if @__instancing then @props = props else @animate props

	_showChecked: (bool) =>
		if not bool
			@iconLayer.icon = 'radiobox-blank'
			return

		@group.active = _.indexOf(@group, @)

		for rb in _.without(@group, @)
			rb.checked = false

		@iconLayer.icon = 'radiobox-marked'
		return

	_showError: (bool) =>
		return if @disabled
		@theme = if bool then "error" else "default"

	_showHovered: (bool) =>
		return if @disabled
		@theme = if bool then "hovered" else "default"

	_setLabelLayer: (layer) =>
		return if not layer
		layer.onTap => @checked = true

	_showDisabled: (bool) =>
		if bool
			# show disabled
			@theme = 'disabled'
			@ignoreEvents = true
			return

		# show not disabled
		@theme = 'default'
		@ignoreEvents = false

	# ---------------
	# Public Methods


	# ---------------
	# Special Definitions