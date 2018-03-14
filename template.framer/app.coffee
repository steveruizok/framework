# require "framework"
require "myTheme"

app = new App
# 	chrome: "safari"	# [1] use safari theme
# 	showKeys: false		# [2] hide the view keys in status bar

# ----------------
# Data [3]

# Items

# [1]
list_items = [0...6].map (i) ->
	return {
		title: "Link " + i 
		description: Utils.randomText(48, true, false) #[2]
		image: Utils.randomImage()
		}
	

### Notes _____________________________________________________

[1] Here we're using the `Array.map` method to return an array
	of objects, which we'll use in our 1.0.0 List View. By 
	keeping that data here, rather than in the view, we can more 
	easily find and change it later.
	
[2] Framework comes with many useful new Util methods. We can
	use `Utils.randomText` to give us 48 words of lorem ipsum.
	The `true` argument tells the method to give us this text as 
	sentences; if the third argument were `true`, we'd get it in
	paragraphs, too.

###

# ----------------
# Views [4]

# 0.0.0 Landing View

landingView = new View
	title: 'Landing' # [1]
	key: "0.0.0" # [2]
	contentInset: # [3]
		bottom: 0

landingView.onLoad -> # [4]
# Utils.bind landingView, -> #[5]
	title = new H2
		parent: @content
		x: Align.center()
		y: 128
		text: "Best App"
		
	input = new TextInput 
		parent: @content
		x: Align.center()
		placeholder: "Enter your email"
	
	button = new Button
		parent: @content
		x: Align.center()
		width: input.width
		text: "Sign in"
		disabled: true
		
	Utils.offsetY(@content.children, 32)
	
	# Events
	
	input.onChange "value", (v) ->
		button.disabled = !Utils.isEmail(v)
		
	button.onSelect -> 
		app.showNext(listView, 1)
	

### Notes _____________________________________________________

[1] If the `App` has a `chrome` of `iOS`, the App's header will 
	display the current View's `title` string as its title text. 
	
[2]	If the `App`'s `showKeys' option is `true` (as it is by 
	default), the App's header will also show the current View's 
	`key` in its status bar.
	
[3] Beneath all the extra action, Views are essentially just
	scroll components. You can set their options in the same way 
	you would when creating a ScrollComponent instance.

[4]	Every View *must* have an `onLoad` property. This is where
	you will should all of the View's layers, events, and other
	content. There's a very important reason for this: when the 
	App navigates to a new View, it immediately runs this new 
	View's `onLoad` function. Later, when the App navigates
	away from that View, the View destroys all of its sublayers 
	except for `View.content`, and then destroys all of 
	`View.content`'s sublayers too. So long as all of those
	layers were created inside of an `onLoad` function, the user
	won't be able to tell the difference: the next time they
	navigate to the View, all of that content will re-created 
	for them before the transition occurs, as if it had been 
	there all along!

[5] While you must include an `onLoad`, it is also useful to 
	leave that function blank while constructing your View.
	Error handling doesn't work very well with `onLoad`: you
	won't be able to tell where an error occurs inside of an
	`onLoad` callback (the `onLoad` will simply throw a warning).
	To solve for this, you can use `Utils.bind yourView, ->` 
	to create a similar scope, build your View, get your errors,
	and then comment out the `Utils.bind` line when everything 
	is working the way it should.

###

# 1.0.0 List View

listView = new View
	title: "List View"
	key: "1.0.0"


listView.onLoad () ->
	
	# Iterate over items (see the "Data" code fold)
	links = list_items.map (item, i) =>
		
		link = new H3Link
			x: 32
			y: 48
			parent: @content
			width: @width - 64
			text: item.title
			
		photo = new Layer
			parent: link
			x: Align.right()
			size: link.height
			image: item.image
			
		return link
		
	# Events
	
	links.forEach (link, i) -> 
		link.onSelect ->
			detailView = new DetailView
				item: list_items[i]
			
			app.showNext(detailView)
		
	Utils.offsetY(@content.children, 16)
	@updateContent()

# 2.0.x Detail View

class DetailView extends View
	constructor: (options = {}) ->
		
		_.defaults options,
			name: "Detail View"
			key: "2.0.x"
			item: list_items[0]
			padding: null
			oneoff: true
		
		super options
		
		item = options.item
				
		@onLoad (data) ->
		
# 		Utils.bind @, ->  # un-comment to find errors
				
			photo = new Layer
				parent: @content
				size: @width
				image: item.image
			
			@padding =
				left: 16
				right: 16
			
			title = new H3 
				parent: @content
				padding: { top: 24 }
				text: item.title 
			
			body = new Body 
				parent: @content
				width: @width
				text: item.description
				
			Utils.offsetY(@content.children, 16)
			@updateContent()

# ----------------
# Kickoff / Testing [3]

app.showNext(landingView)
# app.showNext(listView)
# app.showNext(new DetailView)

### Notes _____________________________________________________

[1] The `chrome` property sets which device chrome to use.
	It can be either "ios" (the default value), "safari",
	or null to hide the device chrome altogether.

[2] The `showKeys` property sets whether or not to show the
	view keys (a special name given to each View, like "0.0.0"), 
	in the status bar. View keys help keep track of where you 
	or your user is in the flow.
	
[3] If your project uses data, like a list of names or objects,
	it's best to keep that data somewhere easy to find, rather 
	than hidden deep in your Views.

[4] With Framework, your project will (almost certainly) be made
	up of View instances. To keep things organized, I suggest using
	a different code folds for each View and naming it with its
	view key (e.g. "1.1.0") and the name or purpose of the view.

[5] You'll want to start your project by showing one of your Views.
	When building a View, it's useful to start the project at that
	view.

 
###