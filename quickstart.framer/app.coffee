require "framework"

app = new App
	title: "www.framework.com"
	showKeys: true
	printErrors: true
	showSublayers: false


# --------------------
# Data


# --------------------
# Helpers


# --------------------
# Components


# --------------------
# Pages


# --------------------
# Views

# 0.0.0 View

view = new View
	name: "View"
	title: "View"
	key: "0.0.0"
	contentInset: 
		top: 300


view.onPreload (resolve, reject) ->
	resolve(null)


view.onLoad (data) ->
	

view.onPostload ->
	null


# --------------------
# Navigation

app.showNext(view)
