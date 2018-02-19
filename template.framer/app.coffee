require 'framework'

app = new App
	chrome: "safari"
	title: 'www.framework.com'


 # My View

myView = new View
	title: "Home"
	padding: null
	key: "0.0.0"
	preserveContent: true

myView.onLoad (a, b, c) ->
	layer = new Layer
		parent: @content
		x: Align.center
		y: 32
	
	button = new Button
		parent: @content
		x: Align.center
		width: @width - 64
		y: layer.maxY + 40
		select: -> app.showNext(secondView, 1)

# Second View

secondView = new View
	title: "Home"
	padding: null
	key: '1.0.0'
	oneoff: true
		
secondView.onLoad ->
	layer = new Layer
		parent: @content
		x: Align.center
		y: 32
		
	button = new Button
		parent: @content
		x: Align.center
		y: layer.maxY + 32
		secondary: true
		select: -> app.showNext(thirdView)

# Third View

thirdView = new View
	title: "Home"
	padding: null
	key: '2.0.0'
		
thirdView.onLoad ->
	layer = new Layer
		parent: @content
		x: Align.center
		y: 32

app.showNext myView
