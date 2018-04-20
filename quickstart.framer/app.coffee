require "myTheme"

app = new App

# ----------------
# Helpers

# ----------------
# Data

# Items

# [1]
list_items = [0...6].map (i) ->
	return {
		title: "Link " + i 
		description: Utils.randomText(48, true, false) #[2]
		image: Utils.randomImage()
		}
	

### Notes _____________________________________________________

[1] Here we're using the `Array.map` method to return an array
	of objects, which we'll use in our 1.0.0 List View. By 
	keeping that data here, rather than in the view, we can more 
	easily find and change it later.
	
[2] Framework comes with many useful new Util methods. We can
	use `Utils.randomText` to give us 48 words of lorem ipsum.
	The `true` argument tells the method to give us this text as 
	sentences; if the third argument were `true`, we'd get it in
	paragraphs, too.

###

# ----------------
# Components

# ----------------
# Views

# 0.0.0 Landing View

landingView = new View
	title: 'Landing'
	key: "0.0.0"
	contentInset:
		top: 0
		bottom: 0


landingView.onPreload (resolve, reject) ->
	preloadData = {}
	
	resolve(preloadData)


landingView.onLoad (preloadData) ->
	
	btn = new Button
		parent: @content
		x: Align.center()
		y: 200
	
	btn.onTap => app.showNext(secondView, true)
	
landingView.onPostload (preloadData) ->
	Utils.stack(@content.children, 16)

# 1.0.0 Second View

secondView = new View
	title: 'Landing'
	key: "0.0.0"
	contentInset:
		top: 0
		bottom: 0


secondView.onPreload (resolve, reject) ->
	preloadData = {}
	
	resolve(preloadData)


secondView.onLoad (preloadData) ->
	
	_.range(100).forEach (layer) =>
	
		layer = new Layer
			parent: @content
			width: @width - 32
			x: 16
		
		title = new H4
			parent: layer
			point: 16
		
		sub = new H6
			parent: layer
			x: 16
			padding: {bottom: 16}
		
		body = new Body2
			parent: layer
			x: 16
			text: Utils.randomText 32, true
			width: layer.width - 32
		
		Utils.stack layer.children
		Utils.contain layer, true, 0, 16
	
secondView.onPostload (preloadData) ->
	Utils.stack(@content.children, 16)


# ----------------
# Kickoff

app.showNext(landingView)