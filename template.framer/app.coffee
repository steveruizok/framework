require 'framework'

# Setup
Framer.Extras.Hints.disable()

# dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"

app = new App
	chrome: "safari"
	title: 'framework.com'

# Home View

myView = new View
	title: "Home"
	padding: null
	
Utils.bind myView, ->
	# This callback will run immediately and only once.
	# Use this to create the view's permanent properties, like functions.
	
	# fixed layers
	
	# fixed layer events
	
	# functions
	
myView.onLoad ->
	# This callback will run when app navigates to this View.
	# Before it runs, the View will destroy each of View.content's sublayers.
	# Use View.onLoad to create the view's content.
	
	# content layers
	
	new Layer
		parent: @content
		
	# content layer events
	

myView.onUpdate ->
	# This callback will run when myView.update() is run manually.

myView.onUnload ->
	# This callback will run when app navigates away from this View.
	# If performance is an issue, use it to destroy layers or stop processes.
	

app.showNext myView