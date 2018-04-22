require "framework"

app = new App


# Landing View

firstView = new View
	title: "First View"
	key: "0.0.0"

firstView.onLoad ->
	new H3
		parent: @content
		y: 24
		x: Align.center()
		text: "First Page"
        
	btn = new Button
		parent: @content
		x: Align.center()
		text: "Get Started"
        
	btn.onSelect -> app.showNext(secondView)
        
firstView.onPostload ->
	Utils.stack(@content.children, 16)


# Second View

secondView = new View
	title: "Second View"
	key: "1.0.0"

secondView.onLoad ->
	new H3
		parent: @content
		y: 24
		x: Align.center()
		text: "Second Page"
        
secondView.onPostload ->
	Utils.stack(@content.children, 16)

app.showNext(firstView)