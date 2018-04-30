require "framework"

app = new App
	chrome: "ios"
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

createPage1 = (preloadedData, page, view) ->
		
	info = new Body
		parent: @content
		text: "This is the first page of a `PageView`.\n\nUnlike regular `Views`, which are extended `ScrollComponents`, a `PageView` is an extended `FlowComponent` that manages its own set of `ScrollComponents`. Both `View` and `PageView` instances are managed by the larger `App` instance, which is also an extended `FlowComponent`.\n\n`PageView`s use a `NavBar` instance to navigate between their pages. You'll use functions to create the content for each of a `PageView`'s pages. For example, the content for this page is created using the `createPage1` function.\n\n`PageView`s also take a Promise for their `preload` property. The results of this data are passed into each of the content functions, allowing for dynamic content. The date below comes from this `PageView`'s '`preload`:"
		x: 32
		y: 32
		width: @width - 64
		
	Utils.toMarkdown(info)
	
	new H4
		parent: @content
		y: 32
		x: 16
		width: @width - 32
		textAlign: "center"
		text: preloadedData ? "(Preloaded data here)"
		
	info = new Body
		parent: @content
		text: "Note that all of the content for each of a `PageView`'s pages is created simultaneously when that `PageView` loads – and destroyed again when the `PageView` unloads. If the content of these pages is very complex, `PageView`s may take longer to load than regular `View`s."
		x: 32
		y: 32
		width: @width - 64
		
	Utils.toMarkdown(info)
	
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
	preload: (resolve, reject) -> 
		resolve(new Date())
# 	start: 1
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
	info = new Body
		parent: @content
		text: "This is a another root view, associated with the second tab in the `Toolbar`.\n\nIt also has a NavBar, however unlike the first view (a `PageView`), which will automatically create a `NavBar` to navigate between its pages, we've made this one by hand -- and we can use it for whatever we want. Here we've given it links to navigate to the top and bottom of the view's content."
		x: 32
		y: 72
		width: @width - 64
		
	Utils.toMarkdown(info)
	
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
		return unless app.header?
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
	info = new Body
		parent: @content
		text: "This is a regular view.\n\nIt's not a `root` view and it's not one of the views associated with a tab in the toolbar. As a result, we've hidden the menu button and replaced it with a `showPrevious` link in the header."
		x: 32
		y: 16
		width: @width - 64
		
	Utils.toMarkdown(info)
	
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
				text: "This is a takeover view. Takeover views are used for dead ends and terminal content - the bedrock of a drill-down, where the only way out is back.\n\nOn views with the `oneoff` property, the Toolbar will hide away, giving the View a focused 'takeover' appearance. This ensures that the user will navigate away form the View using `showPrevious`, which will remove the `oneoff` View.\n\n"
				x: 32
				y: 16
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
	
	info = new Body
		parent: @content
		text: "This is another `root` view, associated with the third tab in the toolbar."
		x: 32
		y: 16
		width: @width - 64
		
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
			loader: true
		"Third":
			icon: "star"
			view: thirdView

app.showNext(firstView)
