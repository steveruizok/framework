###

Icon

An SVGLayer that displays one of about 1600 icons from www.materialdesignicons.com.

@extends {SVGLayer}
@param	{Object}	options 			The component's attributes.
@param	{string}	options.icon		The name of the icon to use (e.g. "account-outline").
@param	{string}	options.padding 	How much padding to place around the icon.

Icon.addIcon(name <string>, path <string>)	
	Adds a new icon to the collection. The SVG should be the `d` property of an SVG path, vertically flipped and designed for a viewBox of 0 0 512 512.

###

Theme = require "components/Theme"
theme = undefined

class exports.Icon extends Layer
	constructor: (options = {}) ->
		theme = Theme.theme

		_.defaults options,
			name: 'Icon'
			size: 24
			backgroundColor: null
			clip: true
			color: black
			animationOptions:
				time: .25

			icon: 'star'
			padding: 0

		super options

		
		# LAYERS

		@iconLayer = new SVGLayer
			parent: @
			name: "Icon SVG"
			size: _.min([@height, @width])
			backgroundColor: null


		# EVENTS

		@on "change:color",	@_refresh
		@on "change:size",	@_refresh


		# DEFINITIONS
		
		Utils.define @, 'padding', 	options.padding, 	@_setPadding, 	_.isNumber, 'Icon.padding must be a number.'
		Utils.define @, "icon", 	options.icon, 		@_refresh, 		_.isString, 'Icon.icon must be a string.'


		# CLEANUP

		child.name = '.' for child in @children unless options.showSublayers


		# KICKOFF

		@_refresh()

	
	# PRIVATE METHODS

	_setPadding: =>
		@iconLayer._element.style.padding = Utils.px(@padding)


	_refresh: =>
		icon = theme.icons[@icon ? "none"]
		
		@iconLayer.size = _.min([@height, @width])

		if @icon is 'random' then icon = _.sample(_.keys(theme.icons))

		@iconLayer.svg = "<svg height='100%' width='100%' viewBox='0 0 512 512'><path transform='scale(1, -1), translate(0, -448)' fill='#{@color}' d='#{icon}'/>"


	# PUBLIC METHODS

	addIcon: (name, svg) =>
		iconObj = {}
		iconObj[name] = svg
		theme.icons = _.merge(theme.icons, iconObj)
		@icon = name
