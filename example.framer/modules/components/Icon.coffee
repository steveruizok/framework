Theme = require "components/Theme"
theme = undefined

class exports.Icon extends SVGLayer
	constructor: (options = {}) ->
		theme = Theme.theme

		_.defaults options,
			name: 'Icon'
			size: 24
			icon: 'star'
			backgroundColor: null
			clip: true
			color: black
			lineHeight: 0
			padding: 0
			animationOptions:
				time: .25
				colorModel: 'husl'

		super options

		# LAYERS


		# EVENTS

		@on "change:color", @_refresh


		# DEFINITIONS
		
		Utils.define @, 'padding', options.padding, @_setPadding, _.isNumber, 'Icon.padding must be a number.'
		Utils.define @, "icon", options.icon, @_refresh, _.isString, 'Icon.icon must be a string.'


		# CLEANUP

		child.name = '.' for child in @children unless options.showSublayers


		# KICKOFF

		@_refresh()

	
	# PRIVATE METHODS

	_setPadding: =>
		@_element.style.padding = Utils.px(@padding)


	_refresh: =>
		icon = theme.icons[@icon]
		if @icon is 'random' then icon = _.sample(_.keys(theme.icons))

		@svg = "<svg height='100%' width='100%' viewBox='0 0 512 512'><path transform='scale(1, -1), translate(0, -448)' fill='#{@color}' d='#{icon}'/>"


	# PUBLIC METHODS

	addIcon: (name, svg) =>
		iconObj = {}
		iconObj[name] = svg
		theme.icons = _.merge(theme.icons, iconObj)
		@icon = name

	# ---------------
	# DEFINITIONS
