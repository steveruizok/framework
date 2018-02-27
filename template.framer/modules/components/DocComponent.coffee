class exports.DocComponent extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options
		
		_.defaults options,
			name: "Documentation"
			width: Screen.width
			color: white
			backgroundColor: black
			tabbed: true
			text: [
				"new Component"
				"status: {status}"
				]
			template: {}
		
		super options

		# ---------------
		# Layers
		
		if typeof options.text is 'string' then options.text = [options.text]
		
		@codeBlock = new Code
			name: 'Label'
			parent: @
			x: 12
			y: 16
			text: options.text.join(if options.tabbed then '\n\t' else '\n')
			color: @color
		
		Utils.toMarkdown(@codeBlock)
		
		template = {}
		formatter = {}
		
		_.entries(options.template).forEach (pair) =>
			key = pair[0]
			options = pair[1]
			layer = options[0]
			property = options[1]
			format = options[2]
			
			template[key] = layer[property] ? ''
			formatter[key] = format
			
			layer.onChange property, (value) =>
				@codeBlock.template = {"#{key}": value}
				@height = _.maxBy(@children, 'maxY')?.maxY + 16

		@codeBlock.templateFormatter = formatter
		@codeBlock.template = template
			
		@copyIcon = new Icon
			name: 'Copy Icon'
			parent: @
			y: 16
			icon: 'content-copy'
			color: grey
			
		@copyLabel = new Label
			name: 'Copy Label'
			parent: @
			y: @copyIcon.maxY
			x: Align.right(-8)
			text: 'COPY'
			color: grey
			
		@copyIcon.midX = @copyLabel.midX

		# ---------------
		# Cleanup
		
		child.name = '.' for child in @children unless options.showSublayers

		# ---------------
		# Definitions
			
		# ---------------
		# Events
		
		@copyIcon.onTap => 
			Utils.copyTextToClipboard(@codeBlock.text)
			
			@codeBlock.animate
				color: blue
				options: { time: .07 }
					
			Utils.delay .1, =>
				@codeBlock.animate
					color: @color
					options: { time: .5 }
					
		@height = _.maxBy(@children, 'maxY')?.maxY + 16