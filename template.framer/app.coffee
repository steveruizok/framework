# require "framework"
require "myTheme"

app = new App
# 	chrome: null
	chrome: "safari"	# [1] use safari theme
	showKeys: false		# [2] hide the view keys in status bar

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
		
landingView.onPreload (resolve, reject) -> # [4]
	preloadData = 
		title: "Best App"
	
	resolve(preloadData)

landingView.onLoad (preloadData) -> # [5]
		
	title = new H2
		parent: @content
		x: Align.center()
		y: 128
		text: preloadData.title # [5.1]
	
	container = new Container # [6]
		parent: @content
		x: Align.center()
		padding: 
			left: 0
			right: 0, 
			top: 16, 
			bottom: 16, 
			stack: 4

	label = new Label
		parent: container
		text: "Email"
	
	input = new TextInput 
		parent: container
		placeholder: "Enter your email"
		width: container.width
	
	button = new Button
		parent: @content
		x: Align.center()
		width: container.width
		text: "Sign in"
		disabled: true
	
	# Events
	
	input.onChange "value", (value) ->
		inputIsEmail = Utils.isEmail(value)
		button.disabled = not inputIsEmail # [7]
		
	button.onSelect -> 
		app.showNext(listView, 1) #[8]

landingView.onPostload (preloadData) -> #[9]
	Utils.stack(@content.children, 16)

### Notes _____________________________________________________

[1] If the `App` has a `chrome` of `iOS`, the App's header will 
	display the current View's `title` string as its title text. 
	
[2]	If the `App`'s `showKeys' option is `true` (as it is by 
	default), the App's header will also show the current View's 
	`key` in its status bar.
	
[3] Beneath all the extra action, Views are essentially just
	scroll components. You can set their options in the same way 
	you would when creating a ScrollComponent instance.

[4] Views have four "life cycle" methods. The first, `view.preload`, 
	is a Promise. This allows for true preloading: if data needs  
	to be fetched from an online source, you eventually resolve
	this data into the next method, `view.load`.

[5]	Every View *must* have an `load` property, set using
	`view.onLoad`. This is where you should all of the View's 
	content: layers, events, and functions that rely on them.
	It gets passed whatever data came out of `view.preload`, as
	shown at [5.1].
	
	There's a very important reason for building with `load`:   
	when App navigates to a View, it immediately runs this new 
	View's `load` function. Later, when the App navigates
	away from that View, the View purges its descendants,
	destroying destroys all of its sublayers except for 
	`view.content`. Then it destroys all of `view.content`'s 
	sublayers too. 
	
	However, so long as all of those layers were created inside 
	of the View's `load` function, all of this destruction won't
	matter to the user: the next time they navigate to the View, 
	all of that content will re-created for them before the 
	transition occurs, as if it had been there all along!

[6] The Container class is a great parent: it automatically 
	hugs its children, while giving them exactly the space you 
	tell it to. Building with Containers gives you more control 
	over spacing and positioning: set the paddings of your
	containers, then use Utils.stack to place them one after the 
	next.

[7] Here we're using one of the new Utils methods, `Utils.isEmail` 
	to validate whether the content of our email input is, in fact,
	an email address. Then we're using the value it returns 
	(true or false) to set the `disabled` status of our button.

[8] Though Framework's preload function does support real asyncronous 
	delays, sometimes we'll want to fake that delay. App's transition 
	method, `app.showNext`, takes two arguments: the new View to
	show, and how much fake delay we want to add.

[9] Dependng on how complicated your views are, you may want to 
	use the view's last method, `view.postload`, to clean up. 
	This method fires after `view.load` completes and also has
	access to any data that `view.preload` resolved. It's useful
	for Utils.stack calls.

###

# 1.0.0 List View

listView = new View
	title: "List View"
	key: "1.0.0"


listView.onLoad () ->
	
	app.getScreenshot()
	
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

# app.screenshotViews(app.views)


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