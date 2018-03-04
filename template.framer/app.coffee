# require "framework"
require "myTheme"

app = new App
# 	chrome: "safari"


# Data

items = _.range(6).map (i) ->
	{
		title: "Link " + i 
		description: Utils.randomText(48, true)
		image: Utils.randomImage()
	}

# 0.0.0 Landing View

landingView = new View
	title: ' '
	key: "0.0.0"

landingView.onLoad ->
	Utils.bind @content, ->

		title = new H2
			parent: @
			x: Align.center()
			y: 128
			text: "Best App"
			
		input = new TextInput 
			parent: @
			x: Align.center()
			placeholder: "Enter your email"
		
		button = new Button
			parent: @
			x: Align.center()
			width: input.width
			text: "Sign in"
			disabled: true
			
		Utils.offsetY(@children, 32)
		
		# Events
		
		input.onChange "value", (v) ->
			button.disabled = !Utils.isEmail(v)
			
		button.onSelect -> 
			app.showNext(listView, 1)

# 1.0.0 List View

listView = new View
	title: "List View"
	key: "1.0.0"

listView.onLoad ->
	Utils.bind @content, ->
		
		items.forEach (item, i) =>
			
			link = new H3Link
				x: 32
				y: 48
				parent: @
				width: @width - 64
				text: item.title
				
			photo = new Layer
				parent: link
				x: Align.right()
				size: link.height
				image: item.image
			
			# Events
			
			link.onSelect -> 
				detailView = new DetailView
					item: item
					
				app.showNext(detailView)
		
		Utils.offsetY(@children, 24)

# 2.0.x Detail View

class DetailView extends View
	constructor: (options = {}) ->
		
		_.defaults options,
			name: "Detail View"
			key: "2.0.x"
			item: items[0]
			padding: null
			oneoff: true
		
		super options
			
		item = options.item
		
		@onLoad ->
			Utils.bind @content, ->
				
				photo = new Layer
					parent: @
					size: @width
					image: item.image
				
				@parent.padding =
					left: 16
					right: 16
				
				title = new H3 
					parent: @
					padding: { top: 24 }
					text: item.title 
				
				body = new Body 
					parent: @
					width: @width
					text: item.description
					
				Utils.offsetY(@children, 16)

app.showNext(landingView)