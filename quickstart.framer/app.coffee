require "myTheme"

app = new App

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
		bottom: 0


landingView.onPreload (resolve, reject) ->
	preloadData = 
		title: "Best App"
	
	resolve(preloadData)


landingView.onLoad (preloadData) ->
	new Layer
		parent: @
		x: Align.center()
		y: 232
	 
	# Events


landingView.onPostload (preloadData) ->
	Utils.stack(@content.children, 16)


# ----------------
# Kickoff

app.showNext(landingView)