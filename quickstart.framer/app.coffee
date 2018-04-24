require "framework"

app = new App
	printErrors: true
	chrome: "browser"

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
	title: "First View"
	key: "0.0.0"

landingView.onLoad ->
	new Layer
		parent: @content
		x: Align.center()
	
landingView.onPostload ->
	Utils.stack(@content.children, 16)


# --------------------
# Kickoff

app.showNext(landingView)