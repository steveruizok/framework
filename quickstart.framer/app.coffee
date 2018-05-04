require "myTheme"

app = new App
	title: "www.framework.com"
	showKeys: true
	printErrors: true
# 	chrome: "browser"
# 	showSublayers: true

# --------------------
# Data

# --------------------
# Helpers


# --------------------
# Components


# --------------------
# Pages

# Page 1

createPage1 = (data, page, view) ->
	
	for i in _.range(3)
	
		new Layer
			parent: @content
			y: 32
			x: Align.center
			height: 64
			backgroundColor: blue
		
	Utils.stack(@content.children, 16)
	@updateContent()

# Page 2
	
createPage2 = (data, page, view) ->
	
	for i in _.range(3)
	
		new Layer
			parent: @content
			y: 32
			x: Align.center
			height: 64
			backgroundColor: green
		
	Utils.stack(@content.children, 16)
	@updateContent()


# --------------------
# Views

# 0.0.1 View

view = new View
	name: "View"
	title: "View"
	key: "0.0.0"

view.onLoad ->
	
	btn = new Button
		parent: @content
		x: Align.center()
		y: 16
	
	btn.onSelect -> app.showNext(pageView)
	
	for i in _.range(3)
		new Layer
			parent: @content
			x: Align.center()
	
view.onPostload ->
	Utils.stack(@content.children, 16)

# 0.0.0 Page View

pageView = new PageView
	name: "Page View"
	title: "Page View"
	key: "2.0.0"
	pages:
		"Page One": createPage1
		"Page Two": createPage2
	preload: (resolve, reject) -> 
		resolve(new Date())
# 	start: 1
# 	placeholder: (data, page, view) ->
# 		new H4
# 			parent: @
# 			x: Align.center()
# 			y: 32
# 			text: "Placeholder for " + page.name



# --------------------
# Navigation

# Menu

menu = new Menu
	structure:
		0:
# 			title: "Views"
			links:
				"View": view.show
				"PageView": pageView.show
# 	open: false
# 	title: "Menu"
# 	dividers: false
# 	tint: red
# 	padding: {top: 56, bottom: 16, left: 8, right: 8, stack: 4}

# Toolbar

new Toolbar
	links:
		"Home":
			icon: "home"
			view: view
		"Second":
			icon: "flag"
			view: pageView
# 	labels: true
# 	start: 0
# 	color: red
# 	border: 3
# 	indicator: true
# 	tint: red

app.showNext(view)
