require 'framework'

app = new App
# 	chrome: "safari"
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
		x: 32
		y: 32
	
	button = new Button
		parent: @content
		x: Align.center
		width: @width - 64
		y: layer.maxY + 40
		select: -> app.showNext(secondView, 1)
		
	l = new Layer
		parent: @content
		size: 100
		
	Utils.pin l, layer, 'right', 'bottom'
	
	anim1 = new Animation layer,
		x: 100
		width: 100
		y: 100
		height: 100
	
	anim2 = new Animation layer,
		x: 32
		width: 200
		y: 32
		height: 200
		
	Utils.chainAnimations anim1, anim2
	

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
