require "framework"

app = new App
	printErrors: true
	showKeys: true

# --------------------
# Data


# --------------------
# Helpers


# --------------------
# Components


# --------------------
# Views

# 0.0.0 Landing View

landingView = new View
	name: "1"
	title: "First View"
	key: "0.0.0"

landingView.onLoad ->
	new Layer
		parent: @content
		x: Align.center()
		
	new Layer
		parent: @content
		x: Align.center()
	
landingView.onPostload ->
	Utils.stack(@content.children, 400)

# 1.0.0 Second View

secondView = new View
	name: "2"
	title: "Second View"
	key: "1.0.0"

secondView.onLoad ->
	
	btn = new Button
		parent: @content
	
	btn.onSelect ->
		app.showNext(thirdView)
	
	new Layer
		parent: @content
		x: Align.center()
		
	new Layer
		parent: @content
		x: Align.center()
	
	
secondView.onPostload ->
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

# app.showNext(landingView)

app.footer = new Toolbar
	labels: true
	start: 0
	indicator: true
	links:
		"Home":
			icon: "home"
			view: landingView
		"Second":
			icon: "flag"
			view: secondView
			loader: true
		"Third":
			icon: "star"
			view: thirdView
	
app.menu = new Menu
	structure:
		0:
			title: "Menu"
			links:
				"First View": -> app.showNext(landingView)
				"Second View": -> app.showNext(secondView)
				"Third View": -> app.showNext(thirdView)
		1:
			title: undefined
			links:
				"secondary link 1": undefined
				"secondary link 2": undefined
				"secondary link 3": undefined
		2:
			title: undefined
			links:
				"sign up": undefined
				"sign in": undefined
# app.showNext(secondView)