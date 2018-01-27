# View

class exports.View extends ScrollComponent
	constructor: (options = {}) ->
		@app = options.app
		
		_.defaults options,
			padding: {}

		_.assign options,
			width: Screen.width
			height: Screen.height
			backgroundColor: '#FFF'
			scrollHorizontal: false
			contentInset:
				top: @app.header.height
				bottom: 64

		super options

		@app.views.push(@)
		@content.backgroundColor = @backgroundColor
		@sendToBack()

		# padding
		
		Utils.define @, 'padding', options.padding

		# set padding defaults
		_.defaults @padding,
			left: 16,
			right: 16,
			top: 16,

		@content.on "change:children", @_fitChildrenToPadding

		# definitions

		Utils.define @, 'title', options.title

			
	_fitChildrenToPadding: (children) =>

		w = @width - @padding.right - @padding.left

		for child in children.added
			if child.x < @padding.left then child.x = @padding.left
			if child.y < @padding.top then child.y = @padding.top
			if child.width > w 
				Utils.delay 0, -> child.width = w
