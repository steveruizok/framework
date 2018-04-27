require "framework"

app = new App
	printErrors: true
	showKeys: true
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

createPage1 = (layer, view, title) ->
	Utils.bind layer, ->
		
		for i in _.range(10)
		
			new Layer
				parent: @content
				y: 32
				x: Align.center
				height: 64
				backgroundColor: blue
			
		Utils.stack(@content.children, 16)

# Page 2
	
createPage2 = (layer, view, title) ->
	Utils.bind layer, ->
		
		for i in _.range(10)
		
			new Layer
				parent: @content
				y: 32
				x: Align.center
				height: 64
				backgroundColor: green
			
		Utils.stack(@content.children, 16)

# Page 3

createPage3 = (layer, view, title) ->
	Utils.bind layer, ->
		
		for i in _.range(10)
		
			new Layer
				parent: @content
				y: 32
				x: Align.center
				height: 64
				backgroundColor: yellow
			
		Utils.stack(@content.children, 16)


# --------------------
# Views

# 0.0.0 First View

firstView = new PageView
	name: "1"
	title: "First View"
	key: "0.0.0"
	pages:
		"First Page": createPage1
		"Second Page": createPage2
		"Third Page": createPage3

firstView.onPostload ->
	Utils.stack(@content.children, 400)

# 1.0.0 Second View

secondView = new View
	name: "2"
	title: "Second View"
	key: "1.0.0"

secondView.onLoad ->
	
	btn = new Button
		parent: @content
		x: 16
		y: 32
		width: @width - 32
		text: "Show another view"
	
	btn.onSelect ->
		app.showNext(anotherView)
	
	new Layer
		parent: @content
		x: Align.center()
		
	new Layer
		parent: @content
		x: Align.center()
	
	
secondView.onPostload ->
	Utils.stack(@content.children, 400)

# 1.1.0 Another View

anotherView = new View
	name: "2.1"
	title: "Another View"
	key: "1.1.0"

anotherView.onLoad ->
	
	btn = new Button
		parent: @content
		x: 16
		y: 32
		width: @width - 32
		text: "Show third view"
	
	btn.onSelect ->
		app.showNext(thirdView)
	
	new Layer
		parent: @content
		x: Align.center()
		
	new Layer
		parent: @content
		x: Align.center()
	
	
anotherView.onPostload ->
	Utils.stack(@content.children, 400)

# 2.0.0 Third View

thirdView = new View
	name: "3"
	title: "Third View"
	key: "2.0.0"

thirdView.onLoad ->
	new Layer
		parent: @content
		x: Align.center()
		
	new Layer
		parent: @content
		x: Align.center()

thirdView.onPostload ->
	Utils.stack(@content.children, 400)
	


# --------------------
# Kickoff

# Menu

app.menu = new Menu
	structure:
		0:
			title: "Menu"
			links:
				"First View": firstView.show
				"Second View": secondView.show
				"Third View": thirdView.show
		1:
			title: undefined
			links:
				"secondary link 1": -> new Alert {title: "Secondary 1 tapped!"}
				"secondary link 2": -> new Alert {title: 'Secondary 2 tapped!'}
				"secondary link 3": -> new Alert {title: 'Secondary 3 tapped!'}
		2:
			title: undefined
			links:
				"sign up": undefined
				"sign in": undefined

# Toolbar

app.footer = new Toolbar
	labels: true
	border: 3
# 	indicator: true
	links:
		"Home":
			icon: "home"
			view: firstView
		"Second":
			icon: "flag"
			view: secondView
			loader: false
		"Third":
			icon: "star"
			view: thirdView

# app.showNext(secondView)

# Utils.delay 1, => firstView.navbar.height = 100