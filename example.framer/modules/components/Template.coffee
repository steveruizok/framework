{ theme } = require 'components/Theme'

class exports.NewComponent extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options

		@app = options.app

		_.defaults options,
			name: 'New Component'

		# _.assign options,
		# 	prop: value
		
		super options

		# ---------------
		# Layers
		



		# ---------------
		# Definitions
		
		Utils.define @, 'selected', options.selected, @showSelected



		# ---------------
		# Events
		
		@on "change:height", @_adjustHeight



	# ---------------
	# Private Functions
	
	_adjustHeight: (value) => null

	_setSelected: (bool) => null



	# ---------------
	# Public Functions
	
	showSelected: (bool) =>
		if bool
			# selected is true
			# ...
			return

		# selected is false
		# ...
		return