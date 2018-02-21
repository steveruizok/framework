require 'framework'

app = new App
# 	chrome: "safari"
	title: 'www.framework.com'

 # My View

myView = new View
	title: "Home"
	padding: null
	key: "0.0.0"

myView.onLoad (a, b, c) ->
	layer = new Layer
		parent: @content
		x: Align.center()
		y: 32
		backgroundColor: '#21ccff'
	
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
		
secondView.onLoad ->
	layer = new Layer
		parent: @content
		x: Align.center
		y: 32
		image: Utils.randomImage()
		
	text = new Body2
		parent: @content
		x: Align.center()
		y: layer.maxY + 32
		width: @width * .82
		text: Utils.randomText(48, true)



app.showNext myView
