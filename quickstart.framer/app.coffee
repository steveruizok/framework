require "framework"

app = new App
	title: "www.framework.com"
	showKeys: true
	printErrors: true
	showSublayers: false

layout = new Layout
	rows: true
# 	hidden: true


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


view.onPreload (resolve, reject) ->
	resolve(null)


view.onLoad (data) ->
	new H3
		parent: @content
		x: Align.center()
		y: Align.center(-32)
		text: "Framework"
		
	layer = new Layer
		position:
			x: 800
# 			column: 1
			row: 0
			height: 2
			width: 3
	
	layer.animate 
		layoutColumn: 1
		layoutRow: 2
		layoutWidth: 2
		layoutHeight: 3
		options:
			time: 5
		
	layer.layoutHeight = 2
	
	layer.on "change:layoutColumn", (c) -> print c
	
view.onPostload ->
	null


# --------------------
# Navigation

app.showNext(view)
