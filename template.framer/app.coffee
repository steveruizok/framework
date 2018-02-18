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

	
Utils.bind myView, ->
	null
	
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
	
	new TextInput
		parent: @content
		y: button.maxY + 16
		x: Align.center()

# Second View

secondView = new View
	title: "Home"
	padding: null
	key: '1.0.0'
	
Utils.bind secondView, ->
	null
		
secondView.onLoad ->
	layer = new Layer
		parent: @content
		x: Align.center
		y: 32

app.showNext myView
