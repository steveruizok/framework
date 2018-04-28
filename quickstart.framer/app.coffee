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

createPage1 = (data, page, view) ->
	
	new H4
		parent: @content
		text: data ? "(Preloaded data here)"
		y: 32
		x: 16
		width: @width - 32
		textAlign: "center"
		
	for i in _.range(10)
	
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
	for i in _.range(10)
	
		new Layer
			parent: @content
			y: 32
			x: Align.center
			height: 64
			backgroundColor: green
		
	Utils.stack(@content.children, 16)
	@updateContent()

# Page 3

createPage3 = (data, page, view) ->
	for i in _.range(10)
	
		new Layer
			parent: @content
			y: 32
			x: Align.center
			height: 64
			backgroundColor: yellow
		
	Utils.stack(@content.children, 16)
	@updateContent()


# --------------------
# Views

# 0.0.0 First View

firstView = new PageView
	name: "0"
	title: "First View"
	key: "0.0.0"
	pages:
		"First Page": createPage1
		"Second Page": createPage2
		"Third Page": undefined
# 	start: 1
# 	preload: (resolve, reject) -> 
# 		resolve("Preloaded Data!")
# 	placeholder: (data, page, view) ->
# 		new H4
# 			parent: @
# 			x: Align.center()
# 			y: 32
# 			text: "Placeholder for " + page.name

# 1.0.0 Second View

secondView = new View
	name: "1"
	title: "Second View"
	key: "1.0.0"

secondView.onLoad ->
	
	btn = new Button
		parent: @content
		x: 16
		y: 72
		width: @width - 32
		text: "Show another view"
	
	btn.onSelect ->
		app.showNext(anotherView)
	
	btn = new Button
		parent: @content
		x: 16
		y: 32
		width: @width - 32
		text: "Show takeover view"
	
	btn.onSelect ->
		app.showNext(new TakeoverView)
			
	nav = new Navbar
		parent: @
		start: 0
		links:
			"Scroll to Top": => @scrollToTop()
			"Scroll to Bottom": => @scrollToPoint
				x: 0, y: 999999
			
	@app.on "transitionEnd", => 
		Utils.pin nav, app.header, 'bottom'
			
	for i in _.range(4)
		new Layer
			parent: @content
			x: Align.center()
	
secondView.onPostload ->
	Utils.stack(@content.children, 16)

# 1.1.0 Another View

anotherView = new View
	name: "1.1"
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
			
	for i in _.range(4)
		new Layer
			parent: @content
			x: Align.center()
	
anotherView.onPostload ->
	Utils.stack(@content.children, 16)

# 1.2.0 Takeover View

class TakeoverView extends View
	constructor: (options = {}) ->
		_.defaults options,
			name: "1.2"
			title: "Takeover View"
			key: "1.2.0"
			oneoff: true

		super options
		
		@onLoad ->
			info = new Body
				parent: @content
				text: "On views with the `oneoff` property, the Toolbar will hide away, giving the View a focused 'takeover' appearance. This ensures that the user will navigate away form the View using `showPrevious`, which will remove the `oneoff` View."
				x: 32
				width: @width - 64
				
			Utils.toMarkdown(info)
			
			for i in _.range(4)
				new Layer
					parent: @content
					x: Align.center()
	
			Utils.stack(@content.children, 16)

# 2.0.0 Third View

thirdView = new View
	name: "2"
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
# 	open: false
# 	title: "Menu"
# 	dividers: false
# 	tint: red
# 	padding: {top: 56, bottom: 16, left: 8, right: 8, stack: 4}
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
# 	labels: true
# 	start: 0
# 	color: red
# 	border: 3
# 	indicator: true
# 	tint: red
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