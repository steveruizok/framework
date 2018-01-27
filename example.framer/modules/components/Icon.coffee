{ theme } = require 'components/Theme'

class exports.Icon extends Layer
	constructor: (options = {}) ->
		@__constructor = true

		_.defaults options,
			name: 'Icon'
			width: 24
			height: 24
			icon: 'star'
			backgroundColor: null
			clip: true
			lineHeight: 0
			animationOptions:
				time: .25

		super options

		svgNS = "http://www.w3.org/2000/svg"
		@ctx = document.createElementNS(svgNS, 'svg')
		@svgIcon = document.createElementNS(svgNS, 'path')
		
		@ctx.appendChild(@svgIcon)
		@_element.appendChild(@ctx)

		# when tap ends, turn on / off

		Utils.define @, "icon", options.icon, @_refresh

		throttleSetSize = Utils.throttle .15, @_setSize

		@on "change:color", @_refresh
		@on "change:size", throttleSetSize

		delete @__constructor
		_.assign @,
			icon: options.icon
			padding: options.padding
			color: options.color

		@_refresh()
		Utils.delay 0, @_setSize

	_setSize: =>
		return if @__constructor

		@setAttributes @ctx,
			width: '100%'
			height: '100%'
			viewBox: "0 0 512 512"

	addIcon: (iconObj) ->
		theme.icons = _.merge(theme.icons, iconObj)
		@icon = _.keys(iconObj)[0]

	setAttributes: (element, attributes = {}) ->
		for key, value of attributes
			element.setAttribute(key, value)

	showPressed: (isPressed) ->
		@animateStop()
		if isPressed
			@animate {brightness: 80}
		else 
			if @isOn then @animate {brightness: 85}
			else @animate {brightness: 100}

	_refresh: ->
		return if @__constructor
		
		return if not @color? or not @icon?

		icon = @icon
		if @icon is 'random' then @icon = _.sample(_.keys(theme.icons))

		@setAttributes @svgIcon,
			d: theme.icons[icon]
			fill: @color
			transform: "scale(1, -1), translate(0, -448)"
