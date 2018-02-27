require 'framework'


# Setup
{ theme } = require 'components/Theme' # not usually needed

Canvas.backgroundColor = bg3
Framer.Extras.Hints.disable()

# dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"

# Row Link

class RowLink extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			text: 'Hello world'
			width: Screen.width - 32
			x: 16
			link: null
			backgroundColor: null
		
		super options
		
		_.assign @,
			link: options.link
			
		# layers
		
		@linkLayer = new H4Link
			parent: @
			x: 12
			text: options.text
			color: if @link then yellow80
		
		@height = @linkLayer.height
			
		if @link?
			
			@linkLayer.onSelect (event) =>
				app.showNext(@link)

# Add Docs Link

addDocsLink = (view, url, icon = 'code-tags') ->
	Utils.bind view, ->
		docsLinkCircle = new Layer
			name: '.'
			parent: @
			size: 40
			borderRadius: 20
			backgroundColor: blue
			x: Align.right(-12)
			y: Align.bottom(-16)
			borderWidth: 1
			borderColor: blue60
			shadowY: 3
			shadowBlur: 4
			shadowColor: "rgba(0,0,0,.16)"
		
		docsIcon = new Icon
			name: '.'
			parent: docsLinkCircle
			point: Align.center(1)
			size: 32
			icon: icon
			color: white
		
		do (url) ->
			docsLinkCircle.onTap -> window.open("https://github.com/ProjectRogueOne/framework/#{url}")

# Title Div

titleDiv = (options = {}) ->
	title = new H4
		name: title
		parent: options.parent
		text: options.text
		x: options.x
		y: options.y
		
	div = new Layer
		name: 'Div'
		parent: title
		x: title.maxX
		y: 10
		width: options.width - (title.maxX) - 16
		backgroundColor: grey40
		height: 1

# ----------------
# App

app = new App
	showKeys: false
# 	chrome: "safari"


# ----------------
# Foundations

# Theme

# Colors View

colorsView = new View
	title: 'Colors'
	
colorsView.onLoad ->
	Utils.bind @content, ->
		
		{ colors } = require 'components/Colors'
		
		i = 0
		for k, v of colors
			chip = new Layer
				parent: @
				name: '.'
				width: (Screen.width * .618) - 24
				height: 64
				x: 16
				y: 32 + (i * 72)
				borderRadius: 2
				backgroundColor: v
				borderWidth: 1
				borderColor: new Color(v).darken(10)
			
			label = new Code
				parent: @
				name: '.'
				x: chip.maxX + 16
				text: "#{k}"
				color: '#000'
				
			label.midY = chip.midY
			
			i++

	addDocsLink(@, 'wiki/Colors')

# Typography View

typographyView = new View
	title: 'Typography'

typographyView.onLoad ->
	Utils.bind @content, ->
		
		i = 0
		for k, v of theme.typography
			if window[k]
				textExample = new window[k]
					parent: @
					y: (last ? 32)
					text: k
					x: 16
				
				label = new Code
					parent: @
					name: '.'
					x: 16
					y: textExample.maxY + 4
					text: "new #{k}"
					color: black
					
				last = label.maxY + 32
	
	addDocsLink(@, 'wiki/Typography')

# Icons View

iconsView = new View
	title: 'Icons'

iconsView.onLoad ->
	Utils.bind @content, ->
		
		i = 0
		for ic in _.entries(theme.icons)[0..50]
			icon = new Icon
				name: '.'
				icon: ic[0]
				parent: @
				x: 48
				y: 16 + (i * 50)
				i++
				
			label = new Code
				parent: @
				name: '.'
				x: icon.maxX + 48
				text: "'#{ic[0]}'"
				color: black
			
			label.midY = icon.midY
			
		label = new Body
			parent: @
			name: '.'
			y: label.maxY + 48
			x: Align.center
			textAlign: 'center'
			text: "For full list, see\nhttp://www.materialdesignicons.com"
			color: black
	
	addDocsLink(@, 'wiki/Icon')


# ----------------
# Structure

# App

# View

# Header


# ----------------
# Buttons

# Links View

linksView = new View
	title: 'Links'
	
linksView.onLoad ->
	Utils.bind @content, ->
		
		new H2Link
			parent: @
			name: 'Default Link'
			text: 'Click here'
			x: 16
			
		new H2Link
			parent: @
			name: 'Link with Select'
			text: 'Click here'
			x: 16
			select: => print "Clicked!"
			
		new H2Link
			parent: @
			name: 'Disabled Link'
			text: 'Click here'
			x: 16
			disabled: true
			select: => print "Clicked!"
			
		new H2Link
			parent: @
			name: 'Link with Custom Color'
			text: 'Click here'
			x: 16
			color: red
			select: => print "Clicked!"
		
		last = undefined
		
		for layer, i in @children
			continue if not layer instanceof Link
			
			title = new H4
				name: '.'
				parent: @
				y: (last?.maxY ? 0) + 32
				text: layer.name
				
			div = new Layer
				name: '.'
				parent: @
				x: title.maxX + 16
				y: title.y + 10
				width: @width - (title.maxX + 16) - 16
				backgroundColor: grey40
				height: 1
			
			layer.y = title.maxY + 24
			
			s = if i is 0 then "null" else "print 'Clicked!'"
			c = if i is 3 then 'red' else 'black'
		
			string = [
				"new H2Link",
				"text: #{layer.text}",
				"color: #{c}",
				"disabled: #{layer.disabled}",
				"select: -> #{s}"
				].join('\n\t')
				
			label = new Code
				name: '.'
				parent: @
				x: layer.x
				y: layer.maxY + 16
				text: string
				
			label.template = layer.value
			
			do (label, layer) ->
				layer.on "change:value", =>
					label.template = layer.value
			
			last = label
		
		# other links 
		title = new H4
			name: '.'
			parent: @
			y: (last?.maxY ? 0) + 56
			text: "All Links"
			
		div = new Layer
			name: '.'
			parent: @
			x: title.maxX + 16
			y: title.y + 10
			width: @width - (title.maxX + 16) - 16
			backgroundColor: grey40
			height: 1
		
		last = undefined
		
		i = 0
		for k, v of theme.typography
			if window[k + 'Link']
				textExample = new window[k + 'Link']
					parent: @
					y: (last?.maxY ? title.maxY) + 24
					text: k + 'Link'
					x: 16
				
				label = new Code
					parent: @
					name: '.'
					x: 16
					y: textExample.maxY + 4
					text: "new #{k}Link"
					color: black
				
				last = label
	
		
	
	addDocsLink(@, 'wiki/Link')

# Buttons View

buttonsView = new View
	title: 'Buttons'
	
buttonsView.onLoad ->
	Utils.bind @content, ->
		
		buttons = _.map _.range(24), (i) =>
			button = new Button
				name: 'Button'
				parent: @
				secondary: i % 4 > 1
				disabled: i % 2 is 1
				dark: Math.floor(i/4) % 2 is 1
				icon: if i >= 8 then 'star'
				y: 32 + (i * 80)
				x: 32
				text: if i >= 16 then '' else 'Getting Started'
				
			strings = []
			if button.iconLayer?
				strings.push 'icon: star'
			if button.dark
				strings.push 'dark: true'
			if button.secondary
				strings.push 'secondary: true'
			if button.disabled
				strings.push 'disabled: true'
			string = strings.join('\n')
				
			label = new Code
				name: '.'
				parent: @
				x: button.maxX + 32
				text: string
				color: if button.dark then '#FFF' else '#000'
				
			label.midY = button.midY
			
			return button
		
		dark = new Layer
			name: '.'
			parent: @
			width: @width
			y: buttons[4].y - 16
			height: buttons[7].y - buttons[3].y
			backgroundColor: black
	
		dark2 = new Layer
			name: '.'
			parent: @
			width: @width
			y: buttons[12].y - 16
			height: buttons[15].y - buttons[11].y
			backgroundColor: black
			
		dark3 = new Layer
			name: '.'
			parent: @
			width: @width
			y: buttons[20].y - 16
			height: buttons[23].y - buttons[19].y
			backgroundColor: black
		
		dark.sendToBack()
		dark2.sendToBack()
		dark3.sendToBack()
	
		
		
	addDocsLink(@, 'wiki/Button')


# ----------------
# Inputs

# TextInputs View

textInputsView = new View
	title: 'TextInputs'

textInputsView.onLoad ->
	Utils.bind @content, ->
		
		@parent.padding = {}
		
		new TextInput
			name: 'Default TextInput'
			parent: @
		
		new TextInput
			name: 'TextInput with Placeholder'
			parent: @
			placeholder: 'Favorite naturalists'
		
		new TextInput
			name: 'TextInput with Value'
			parent: @
			value: 'Alexander von Humboldt'
			
		new TextInput
			name: 'Disabled TextInput'
			parent: @
			value: 'Dame Jane Morris Goodall'
			disabled: true
	
		for layer in @children
			continue if not layer instanceof TextInput
			
			content = new Layer
				parent: @
				width: @width
				backgroundColor: null
				y: 32
			
			titleDiv
				parent: content
				width: @width 
				x: 16
				text: layer.name
				
			layer.props = 
				parent: content
				x: 16
			
			new DocComponent
				parent: content
				text: [
					"new Stepper",
					"disabled: {disabled}"
					"placeholder: {placeholder}"
					"value: {value}"
					layer.extra ? ""
					]
				template:
					disabled: [layer, 'disabled']
					placeholder: [layer, 'placeholder', (v) -> "'#{v}'"]
					value: [layer, 'value', (v) -> "'#{v}'"]
			
			Utils.offsetY(content.children, 32)
			Utils.contain(content)
		
		Utils.offsetY(@children, 32)
		
	@updateContent()
	addDocsLink(@, 'wiki/TextInput')

# Selects View

selectsView = new View
	title: 'Selects'

selectsView.onLoad ->
	Utils.bind @content, ->
		
		@parent.padding = {}
		
		new Select
			name: 'Default Select'
			parent: @
		
		new Select
			name: 'Select with Selected Index'
			parent: @
			selectedIndex: 2
		
		new Select
			name: 'Select with Options'
			parent: @
			options: ['Red', 'Orange', 'Yellow', 'Green', 'Blue']
			
		new Select
			name: 'Disabled Select'
			parent: @
			disabled: true
	
		for layer in @children
			continue if not layer instanceof Select
			
			content = new Layer
				parent: @
				width: @width
				backgroundColor: null
				y: 32
			
			titleDiv
				parent: content
				width: @width 
				x: 16
				text: layer.name
				
			layer.props = 
				parent: content
				x: 16
			
			new DocComponent
				parent: content
				text: [
					"new Select",
					"selectedIndex: {selectedIndex}"
					"disabled: {disabled}"
					"value: {value}"
					"options: [{options}]"
					layer.extra ? ""
					]
				template:
					selectedIndex: [layer, 'selectedIndex']
					disabled: [layer, 'disabled']
					value: [layer, 'value', (v) -> "'#{v}'"]
					options: [layer, 'options', (v) -> 
						return (v.map (o) -> return "'#{o}'").join(', ')
						]
			
			Utils.offsetY(content.children, 32)
			Utils.contain(content)
		
		Utils.offsetY(@children, 32)
		
	@updateContent()
	addDocsLink(@, 'wiki/Select')
		

# Checkbox

# Radiobox

# Steppers View

steppersView = new View
	title: 'Steppers'

steppersView.onLoad ->
	Utils.bind @content, ->
		
		@parent.padding = {}
	
		stepper = new Stepper
			name: 'Default Stepper'
			parent: @
		
		stepper = new Stepper
			name: 'Stepper at Mininum Value'
			parent: @
			value: 0
			
		stepper = new Stepper
			name: 'Stepper at Maximum Value'
			parent: @
			value: 10
			
		stepper = new Stepper
			name: 'Stepper with Min, Max and Value'
			parent: @
			min: 50
			max: 100
			value: 42
			
		stepper = new Stepper
			name: 'Stepper with Custom Options'
			parent: @
			options: ['Less', 'More']
			icon: false
			
		# set positions and create code labels
		
		for layer in @children
			continue if not layer instanceof Stepper
			
			content = new Layer
				parent: @
				width: @width
				backgroundColor: null
				y: 32
			
			titleDiv
				parent: content
				width: @width 
				x: 16
				text: layer.name
				
			layer.props = 
				parent: content
				x: 16
			
			new DocComponent
				parent: content
				text: [
					"new Stepper",
					"icon: {icon}"
					"min: {min}"
					"max: {max}"
					"value: {value}"
					"options: [{options}]"
					layer.extra ? ""
					]
				template:
					icon: [layer, 'icon', (v) -> "'#{v}'"]
					min: [layer, 'min']
					max: [layer, 'max']
					value: [layer, 'value', (v) -> "'#{v}'"]
					options: [layer, 'options', (v) -> 
						return (v.map (o) -> return "'#{o}'").join(', ')
						]
			
			Utils.offsetY(content.children, 32)
			Utils.contain(content)
		
		Utils.offsetY(@children, 32)
		
	@updateContent()
		
	addDocsLink(@, 'wiki/Stepper')

# Segments View

segmentsView = new View
	title: 'Segments'
	contentInset:
		bottom: 128

segmentsView.onLoad ->
	Utils.bind @content, ->
		
		@parent.padding = {}
	
		# Segments
			
		new Segment 
			name: 'Default Segment'
			parent: @ 
			
		fw = new Segment 
			name: 'Segment with Set Width'
			parent: @ 
			width: @width - 32
			
		fw.extra = "width: 343"
		
		new Segment 
			name: 'Segment with Active'
			parent: @ 
			active: 1
		
		new Segment 
			name: 'Segment with Three Options'
			parent: @ 
			options: ['Good', 'Nuetral', 'Evil']
		
		new Segment 
			name: 'Segment with Icons'
			parent: @
			options: ['phone', 'email', 'snapchat']
			icon: true
		
		new Segment 
			name: 'Segment with Custom Colors'
			parent: @ 
			options: ['phone', 'email', 'snapchat']
			icon: true
			color: white
			backgroundColor: blue60
		
		new Segment 
			name: 'Segment with Blank Options'
			parent: @ 
			options: [' ', ' ', ' ']
			
		# set positions and create code labels
		
		for layer in @children
			continue if not layer instanceof Segment
				
			content = new Layer
				parent: @
				width: @width
				backgroundColor: null
				y: 32
			
			titleDiv
				parent: content
				width: @width 
				x: 16
				text: layer.name
				
			layer.props = 
				parent: content
				x: 16
			
			new DocComponent
				parent: content
				text: [
					"new Segment",
					"options: [{options}]"
					"icon: {icon}"
					"active: {active}"
					layer.extra ? ""
					]
				template:
					icon: [layer, 'icon']
					active: [layer, 'active']
					options: [layer, 'options', (v) -> 
						return (v.map (o) -> return "'#{o}'").join(', ')
						]
			
			Utils.offsetY(content.children, 32)
			Utils.contain(content)
		
		Utils.offsetY(@children, 32)
		
	@updateContent()
	addDocsLink(segmentsView, 'wiki/Segment')

# Toggles View

togglesView = new View
	title: 'Toggles'
	contentInset:
		bottom: 128

togglesView.onLoad ->
	Utils.bind @content, ->
	
	
		@parent.padding = {}
		
		# toggles
		
		new Toggle 
			name: 'Toggle'
			parent: @ 
		
		new Toggle 
			name: 'Toggle'
			parent: @ 
			width: @width - 32
			
		new Toggle 
			name: 'Toggled Toggle'
			parent: @ 
			toggled: true
		
		new Toggle 
			name: 'Toggle with Options'
			parent: @ 
			options: ['Good', 'Evil']
		
		new Toggle 
			name: 'Toggle with Icons'
			parent: @ 
			options: ['pizza', 'apple']
			icon: true
		
		new Toggle 
			name: 'Toggle with Custom Colors'
			parent: @ 
			options: ['phone', 'email']
			icon: true
			color: white
			backgroundColor: blue60
		
		new Toggle 
			name: 'Blank Toggle'
			parent: @ 
			options: [' ', ' ']
			
		# set positions and create code labels
		
		for layer in @children
			continue if not layer instanceof Toggle
			
			content = new Layer
				parent: @
				width: @width
				backgroundColor: null
			
			titleDiv
				parent: content
				width: @width 
				x: 16
				y: 32
				text: layer.name
				
			layer.props = 
				parent: content
				x: 16
			
			new DocComponent
				parent: content
				text: [
					"new Toggle",
					"options: [{options}]"
					"icon: #{layer.icon}"
					"toggled: {toggled}"
					]
				template:
					icon: [layer, 'icon']
					toggled: [layer, 'toggled']
					options: [layer, 'options', (v) -> 
						return (v.map (o) -> return "'#{o}'").join(', ')
						]
			
			Utils.offsetY(content.children, 32)
			Utils.contain(content)
		
		Utils.offsetY(@children)
	
	@updateContent()		
	addDocsLink(@, 'wiki/Toggle')

# Inputs View

inputsView = new View
	title: 'Inputs'

inputsView.onLoad ->
	Utils.bind @content, ->
		
		# text input
		
		label = new Label 
			parent: @
			text: 'First Name'
		
		input = new TextInput
			parent: @
			y: label.maxY
			placeholder: 'Your first name'
			
		error = new Micro
			parent: @
			y: input.maxY
			text: 'This website only accepts users named Sean.'
		
		input.on "change:value", (value) ->
			error.color =
				if value.toLowerCase() is 'sean'
					green
				else if value is ""
					gray
				else
					red
					
			checkbox.disabled = value.toLowerCase() isnt 'sean'
			checkSubmit()
			
# 		# radiobox
		
		radioBoxlabel = new Label
			parent: @
			x: 16
			y: error.maxY + 16
			text: 'Select your city'
			
		radioboxes = []
		
		lastY = radioBoxlabel.maxY
		
		for city, i in ['London', 'Chicago', 'DeKalb']
			radioboxes[i] = new Radiobox
				parent: @
				group: radioboxes
				x: 16
				y: lastY
	
			label = new Body2
				parent: @
				x: radioboxes[i].maxX + 8
				y: lastY
				text: city
				
			radioboxes[i].labelLayer = label
			
			lastY = radioboxes[i].maxY + 3
		
		# check box
		
		label = new Label
			parent: @
			text: 'Agree to Conditions'
			y: _.last(radioboxes).maxY + 16
			
		checkbox = new Checkbox
			parent: @
			y: label.y + 7
			x: label.maxX + 8
			disabled: true
		
		checkbox.on "change:checked", (bool) ->
			checkSubmit()
		
		# submit button
		
		submit = new Button
			parent: @
			x: 16
			y: checkbox.maxY + 32
			text: 'Submit'
			disabled: true
			
		checkSubmit = ->
			submit.disabled = !(input.value.toLowerCase() is 'sean' and checkbox.checked and _.some(radioboxes, {'checked': true}))
	

	addDocsLink(@, 'wiki/Inputs')


# ----------------
# Components

# SortableComponent View

sortableComponentView = new View
	title: 'SortableComponent'

sortableComponentView.onLoad ->
	Utils.bind @content, ->
		
		title = new H4
			name: '.'
			parent: @
			y: (sortable?.maxY ? 0) + 32
			text: 'Default SortableComponent'
			
		div = new Layer
			name: '.'
			parent: @
			x: title.maxX + 16
			y: title.y + 10
			width: @width - (title.maxX + 16) - 16
			backgroundColor: grey40
			height: 1
		
		sortable = new SortableComponent
			parent: @
			x: Align.center()
			y: title.maxY + 24	
			width: @width * .618
		
		for i in _.range(3)
			
			last = new Layer
				parent: sortable
				x: 0
				y: (last?.maxY ? -16) + 16
				width: sortable.width
				height: 48
				
		last = undefined
		
		# Sortable with handle
		
		title = new H4
			name: '.'
			parent: @
			y: (sortable?.maxY ? 0) + 32
			text: 'SortableComponent using Handles'
			
		div = new Layer
			name: '.'
			parent: @
			x: title.maxX + 16
			y: title.y + 10
			width: @width - (title.maxX + 16) - 16
			backgroundColor: grey40
			height: 1
		
		sortable = new SortableComponent
			parent: @
			x: Align.center()
			y: title.maxY + 24	
			width: @width * .618
			backgroundColor: null
		
		for i in _.range(4)
			
			last = new Layer
				parent: sortable
				y: (last?.maxY ? 1) - 1
				width: sortable.width
				height: 48
				backgroundColor: grey30
				borderColor: grey
				borderWidth: 1
				animationOptions:
					time: .2
					curve: 'linear'
			
			last.handle = new Layer
				parent: last
				x: Align.right()
				height: last.height
				width: 40
				backgroundColor: null
			
			new Icon
				parent: last.handle
				x: Align.right(-8)
				y: Align.center()
				icon: 'drag'
		
		last = undefined
		
		# Sortable with dragging states
		
		title = new H4
			name: '.'
			parent: @
			y: (sortable?.maxY ? 0) + 32
			text: 'SortableComponent with Custom States'
			
		div = new Layer
			name: '.'
			parent: @
			x: title.maxX + 16
			y: title.y + 10
			width: @width - (title.maxX + 16) - 16
			backgroundColor: grey40
			height: 1
		
		sortable = new SortableComponent
			parent: @
			x: Align.center()
			y: title.maxY + 24	
			width: @width * .618
			backgroundColor: null
			draggingState:
				scale: 1.2
				backgroundColor: blue30
				opacity: .8
			defaultState:
				scale: 1
				backgroundColor: green30
				opacity: 1
		
		for i in _.range(4)
			
			last = new Layer
				parent: sortable
				y: (last?.maxY ? 1) - 1
				width: sortable.width
				height: 48
				backgroundColor: green30
				borderColor: green
				borderWidth: 1
			
		last = undefined
		
		
		
		# Sortable with other content
		
		title = new H4
			name: '.'
			parent: @
			y: (sortable?.maxY ? 0) + 32
			text: 'SortableComponent with Other Content'
			
		div = new Layer
			name: '.'
			parent: @
			x: title.maxX + 16
			y: title.y + 10
			width: @width - (title.maxX + 16) - 16
			backgroundColor: grey40
			height: 1
		
		sortable = new SortableComponent
			parent: @
			x: Align.center()
			y: title.maxY + 24	
			width: @width * .618
			backgroundColor: null
		
		for i in _.range(3)
			
			last = new Button
				parent: sortable
				y: (last?.maxY ? -16) + 16
				width: sortable.width
				text: 'Sortable ' + i
		
		last = undefined
			
		
	
	addDocsLink(@, 'wiki/SortableComponent')

# CarouselComponent

carouselComponentView = new View
	title: 'Carousels'

carouselComponentView.onLoad ->
	Utils.bind @content, ->
		
	
	addDocsLink(carouselComponentView, 'wiki/CarouselComponent')

# TabComponent View

tabComponentView = new View
	title: 'TabComponent'
	padding: null

tabComponentView.onLoad ->
# 	@content.backgroundColor = grey30
	Utils.bind @content, ->
		
		title = new H4
			name: 'Title'
			x: 16
			y: 32
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Tab Component**"
		
		Utils.toMarkdown(title)
		
		body = new Body2
			parent: @
			x: 16
			width: @width - 32
			text: "A TabComponent manages several layers, called `tabs`. The `active` or `current` tab is placed in front of the other tabs. The user can select a new `active` tab by tapping on the tab's button."
		
		Utils.toMarkdown(body)
		
		s = new Separator
			parent: @
			x: 0
			width: 100
		s.width = @width
		
		# examples
		
		# 1
	
		t1 = new TabComponent
			parent: @
			width: @width
			
		new DocComponent
			parent: @
			tabbed: false
			text: [
				"new TabComponent"
				"\ttabs: ['Tab 1', 'Tab 2']"
				"\tactive: {active}"
				""
				"print t1.current"
				""
				"# » {current}"
			]
			template:
				active: [t1, 'active']
				current: [t1, 'current', (v) -> 
					"<Layer id:#{v.id} name:#{v.name} (0, 0)>"
					]
		
		# 2
		
		t2 = new TabComponent
			parent: @
			width: @width
			active: 1
			
		new DocComponent
			parent: @
			tabbed: false
			text: [
				"t2 = new TabComponent"
				"\ttabs: ['Tab 1', 'Tab 2']"
				"\tactive: {active}"
				""
				"print t2.current"
				""
				"# » {current}"
			]
			template:
				active: [t2, 'active']
				current: [t2, 'current', (v) -> 
					"<Layer id:#{v.id} name:#{v.name} (0, 0)>"
					]
		
		# 3
			
		t3 = new TabComponent
			parent: @
			width: @width
			tabs: ["Fruit", "Veggies", "Liquor"]
			height: 220
			showSublayers: true
			
		new DocComponent
			parent: @
			tabbed: false
			text: [
				"t3 = new TabComponent"
				"\ttabs: ['Fruit', 'Vegetables', 'Liquor']"
				"\tactive: {active}"
				""
				"print t3.current"
				""
				"# » {current}"
			]
			template:
				active: [t3, 'active']
				current: [t3, 'current', (v) -> 
					"<Layer id:#{v.id} name:#{v.name} (0, 0)>"
					]
		
		Utils.bind t3.tabs[0], ->
			new Body2
				parent: @
				x: 16
				y: 16
				width: @width - 32
				text: "In botany, a fruit is the seed-bearing structure in flowering plants (also known as angiosperms) formed from the ovary after flowering. In common language usage, 'fruit' normally means the fleshy seed-associated structures of a plant that are sweet or sour, and edible in the raw state, such as apples."
		
		Utils.bind t3.tabs[1], ->
			new Body2
				parent: @
				x: 16
				y: 16
				width: @width - 32
				text: "In everyday usage, vegetables are certain parts of plants that are consumed by humans as food as part of a savory meal. Modern-day culinary usage of the term vegetable can be largely defined through culinary and cultural tradition."
		
		Utils.bind t3.tabs[2], ->
			new Body2
				parent: @
				x: 16
				y: 16
				width: @width - 32
				text: "A distilled beverage, spirit, liquor, hard liquor or hard alcohol is an alcoholic beverage produced by distillation of grains, fruit, or vegetables that have already gone through alcoholic fermentation. As distilled beverages contain significantly more alcohol, they are considered 'harder'."
		
		
		Utils.offsetY @children, 32
		
	@updateContent()	
	
	addDocsLink(tabComponentView, 'wiki/TabComponent')

# ----------------
# Miscellaneous

# Tooltips View

tooltipsView = new View
	title: 'Tooltips'

tooltipsView.onLoad ->
	Utils.bind @content, ->
		
		new Tooltip
			name: 'Default Tooltip'
			parent: @
			
		new Tooltip
			name: 'Tooltip Text'
			parent: @
			text: 'Context for the hovered element'
		
		new Tooltip
			name: 'Tooltip Above'
			parent: @
			text: 'Tooltip above an element'
			position: 'above'
		
		new Tooltip
			name: 'Tooltip Right'
			parent: @
			text: 'Tooltip right of an element'
			position: 'right'
		
		new Tooltip
			name: 'Tooltip Below'
			parent: @
			text: 'Tooltip below an element'
			position: 'below'
		
		new Tooltip
			name: 'Tooltip Left'
			parent: @
			text: 'Tooltip left of an element'
			position: 'left'
	
		for layer in @children
			continue if not layer instanceof Tooltip
			
			title = new H4
				name: '.'
				parent: @
				y: (last?.maxY ? 0) + 32
				text: layer.name
				
			div = new Layer
				name: '.'
				parent: @
				x: title.maxX + 16
				y: title.y + 10
				width: @width - (title.maxX + 16) - 16
				backgroundColor: grey40
				height: 1
			
			layer.y = title.maxY + 24
		
			string = [
				"new Tooltip",
				"position: '#{layer.position}'",
				"text: '#{layer.text}'",
				].join('\n\t')
				
			label = new Code
				name: '.'
				parent: @
				x: layer.x
				y: layer.maxY + 24
				text: string
			
			copyIcon = new Icon
				parent: @
				y: label.midY - 12
				x: Align.right(-16)
				icon: 'content-copy'
				color: grey
				
			do (layer, label, copyIcon) ->
				
				copyIcon.onTap ->
					Utils.copyTextToClipboard(label.text)
					
			
			last = label
		
	addDocsLink(@, 'wiki/Tooltip')

# Example View

exampleView = new View
	title: 'Example'

exampleView.onLoad ->
		
	@header = new H2
		name: 'Header H2'
		parent: @content
		x: Align.center
		y: 80
		text: 'Framework'
	
	@lead = new Body
		name: 'Lead Body'
		parent: @content
		x: Align.center
		y: @header.maxY + 12
		text: 'A Component Kit for Framer'
		
	@email = new TextInput
		name: 'Email Input'
		parent: @content
		y: @lead.maxY + 160
		width: 228
		x: Align.center()
		placeholder: 'Enter your e-mail'
		
	@signup = new Button
		name: 'Sign Up Button'
		parent: @content
		x: Align.center()
		y: @email.maxY + 16
		text: 'Sign Up'
		width: 228
		disabled: true
	
	@login = new Button
		name: 'Login Button'
		parent: @content
		x: Align.center()
		y: @signup.maxY + 16
		secondary: true
		text: 'Log In'
		width: 228
		
	@email.on "change:value", (value) =>
		@signup.disabled = value.slice(-4) isnt '.com'
		
	@iconLayer = new Icon
		name: 'Logomark Icon'
		parent: @content
		icon: 'drawing-box'
		x: Align.center
		y: 208
		height: 72
		width: 72
		color: red
		opacity: 0

	# opening animations

	for child, i in @content.children
		
		y = child.y
		
		_.assign child, 
			opacity: 0
			y: y - 16
			ignoreEvents: true
		
		delay = .5 + (.2 * i)
		if i > 1 then delay += .75
		
		child.animate
			opacity: 1
			y: y
			options:
				time: .8
				delay: delay

		do (child) =>
			Utils.delay 2, =>
				child.ignoreEvents = false


# Utils View

Content = (parent) ->
	s = new Separator
		parent: parent
		x: 0
		width: 100
	s.width = parent.width
	
	return new Layer
		parent: parent
		width: 312
		x: 16
		backgroundColor: null

# Utils Home

utilsView = new View
	title: 'Utils'
	contentInset:
		bottom: 200
				
utilsView.onLoad ->
	Utils.bind @content, ->
			
		title = new H3
			parent: @
			x: 16
			text: "Utils"
			
		body = new Body
			parent: @
			x: 16
			y: title.maxY + 16
			width: @width - 32
			text: "Framework comes packaged with several new utilities. See below for documentation, or check the `moreutils.coffee` file included with Framework."
			
		Utils.toMarkdown(body)
		
		# text
		s = new Separator
			parent: @
			x: 0
			y: body.maxY + 32
			width: 100
		s.width = @width
		
		new Label
			parent: @
			text: "Text"
		
		new H4Link
			parent: @
			x: 16
			text: "Utils.toMarkdown"
			color: yellow80
			select: -> app.showNext(toMarkdownView)
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.randomText"
			color: yellow80
			select: -> app.showNext(randomTextView)
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.isEmail"
			color: yellow80
			select: -> app.showNext(isEmailView)
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.copyTextToClipboard"
			color: yellow80
			select: -> app.showNext(copyTextView)
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.getOrdinal"
			color: black
		
		# relationships
		s = new Separator
			parent: @
			x: 0
			width: 100
		s.width = @width
		
		new Label
			parent: @
			text: "Relationships"
			padding: {top: 16}
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.constrain"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.pin"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.unpin"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.pinOriginX"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.pinOriginY"
			color: black
		
		# positioning
		s = new Separator
			parent: @
			x: 0
			width: 100
		s.width = @width
		
		new Label
			parent: @
			text: "Positioning"
			padding: {top: 16}
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.distribute"
			color: yellow80
			select: -> app.showNext(distributeView)
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.align"
			color: yellow80
			select: -> app.showNext(alignView)
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.hug"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.contain"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.offsetX"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.offsetY"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.grid"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.makeGrid"
			color: black
			
		# layers
		s = new Separator
			parent: @
			x: 0
			width: 100
		s.width = @width
		
		new Label
			parent: @
			text: "Layers"
			padding: {top: 16}
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.pointInLayer"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.getLayerAtPoint"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.getLayersAtPoint"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.getLayerFromElement"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.pointInLayer"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.chainAnimations"
			color: black
			
		# properties
		s = new Separator
			parent: @
			x: 0
			width: 100
		s.width = @width
		
		new Label
			parent: @
			text: "Properties"
			padding: {top: 16}
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.define"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.linkProperties"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.setAttributes"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.px"
			color: black
			
		# data
		s = new Separator
			parent: @
			x: 0
			width: 100
		s.width = @width
		
		new Label
			parent: @
			text: "Data"
			padding: {top: 16}
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.CORSproxy"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.fetch"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.fetchJSON"
			color: black
			
		new H4Link
			parent: @
			x: 16
			text: "Utils.timer"
			color: black
			
		Utils.offsetY(@children[2...])
				
	@updateContent()
	addDocsLink(@, 'wiki/Utils')






		
	

# Utils.toMarkdown View

toMarkdownView = new View
	title: 'Utils.toMarkdown'
	contentInset:
		bottom: 200

toMarkdownView.onLoad ->
		
	@padding = {left: 16, top: 16, right: 16}
	
	Utils.bind @content, ->
		# -----------------
		# Utils.toMarkdown
		
		title = new H4
			name: 'Title'
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Utils.toMarkdown**(textLayer)"
		
		Utils.toMarkdown(title)
		
		body = new Body2
			parent: @
			width: @width - 32
			text: "Utils.toMarkdown will convert some basic markdown syntax into inline styles. It works with bold, italic, strike-thru, and code tags.\n\nIf it's not working, try `Utils.delay 0, -> Utils.toMarkdown(textLayer)`."
			padding: {bottom: 16}
		
		Utils.toMarkdown(body)
		
		@parent.padding = null
		
		# examples
		
		content = new Content(@)
		
		new Label
			parent: content
			text: "Example_0"
			
		body = new Body
			parent: content
			x: 16
			text: "This is a **bold** and ***italic*** sentence."
			
		new Label
			parent: content
			text: "Example_1"
			
		body1 = new Body
			parent: content
			x: 16
			text: "This is a **bold** and ***italic*** sentence."
			
		Utils.offsetY(content.children)
		Utils.contain(content)
		
		Utils.toMarkdown(body1)
		
		new DocComponent
			parent: @
			text: [
				"Utils.toMarkdown(Example_1)"
				]
				
		# cleanup
		Utils.offsetY(@children, 16)
	@updateContent()

# Utils.distribute View

distributeView = new View
	title: 'Utils.distribute'
	contentInset:
		bottom: 200

distributeView.onLoad ->
		
	@padding = {left: 16, top: 16, right: 16}
	
	Utils.bind @content, ->
		# -----------------
		# Utils.distribute
			
	
		dtitle = new H4
			name: 'Title'
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Utils.distribute**(layers, direction, [start], [end], [animate], [animationOptions])"
		
		Utils.delay 0, -> Utils.toMarkdown(dtitle)
		
		body = new Body2
			parent: @
			width: @width - 32
			text: "Utils.distrubute works the same way as the Distribute tools in Sketch or Framer's Design Mode. Give it an array of layers and a property (like 'x'), and it will try to evenly distribute the layers between the minimum and maximum values among the layers. You can also include values for where to start and where to end, and optionally animate the transition. The method includes alias names for 'midX' ('horizontal') and 'midY' ('vertical')."
			padding: {bottom: 16}
		
		@parent.padding = null
		
		# horizontal
		
		content = new Content(@)
			
		layers = _.range(10).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
		
		Utils.distribute(layers, 'horizontal', 16, 312)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.distribute("
				"layers,", 
				"'horizontal',", 
				"16,", 
				"312"
				")"
				]
		
		# color
		
		content = new Content(@)
			
		layers = _.range(10).map (l, i) ->
			new Layer
				parent: content
				size: 32
				x: i * 32
				backgroundColor: blue
				borderRadius: 16
		
		Utils.distribute(layers, 'hueRotate', 0, 180)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.distribute("
				"layers,", 
				"'hueRotate',", 
				"0,", 
				"180"
				")"
				]
				
		# animated
		
		content = new Content(@)
				
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
		
		Utils.distribute(layers, 'horizontal', 16, 312, true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.distribute("
				"layers,", 
				"'horizontal',", 
				"16,", 
				"312",
				"true",
				"{time: 1, looping: true}"
				")"
				]
				
		# cleanup
		Utils.offsetY(@children, 16)
	@updateContent()

# Utils.align View

alignView = new View
	title: 'Utils.align'
	contentInset:
		bottom: 200

alignView.onLoad ->
		
	@padding = {left: 16, top: 16, right: 16}
	
	Utils.bind @content, ->
		# -----------------
		# Utils.align
			
	
		title = new H4
			name: 'Title'
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Utils.align**(layers, direction, [animate, [animationOptions]])"
		
		Utils.delay 0, -> Utils.toMarkdown(title)
	
		body = new Body2
			parent: @
			width: @width - 32
			text: "Utils.Align works the same way the Align tools work in Sketch or Design Mode. Give it an array of layers and a direction ('top', 'bottom', 'middle', 'left', 'right', or 'center'), and it will set the layers to the correct minimum or maximum among those layers."
			padding: {bottom: 16}
		
		@parent.padding = null
		
		# left
		
		content = new Content(@)
				
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
# 				y: _.random(24, 128)
		
		Utils.align(layers, 'left', true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.align("
				"layers, 'left'",
				"true, {time: 1, looping: true}"
				")"
				]
		
		
		# right
		
		content = new Content(@)
		
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
		
		Utils.align(layers, 'right', true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.align("
				"layers, 'right'",
				"true, {time: 1, looping: true}"
				")"
				]
		
		# middle
		
		content = new Content(@)
		
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
				y: _.random(24, 128)
		
		Utils.align(layers, 'middle', true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.align("
				"layers, 'middle'",
				"true, {time: 1, looping: true}"
				")"
				]
		
		# top
		
		content = new Content(@)
		
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
				y: _.random(24, 128)
		
		Utils.align(layers, 'top', true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.align("
				"layers, 'top'",
				"true, {time: 1, looping: true}"
				")"
				]
		
		# bottom
		
		content = new Content(@)
		
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
				y: _.random(24, 128)
		
		Utils.align(layers, 'bottom', true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.align("
				"layers, 'bottom'",
				"true, {time: 1, looping: true}"
				")"
				]
		
		# center
		
		content = new Content(@)
		
		layers = _.range(6).map ->
			new Layer
				parent: content
				size: 32
				borderRadius: 16
				x: _.random(24, 296)
				y: _.random(24, 128)
		
		Utils.align(layers, 'center', true, {time: 1, looping: true})
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"Utils.align("
				"layers, 'center'",
				"true, {time: 1, looping: true}"
				")"
				]
		
		# cleanup
		Utils.offsetY(@children, 16)
	@updateContent()

# Utils.randomText View

randomTextView = new View
	title: 'Utils.randomText'
	contentInset:
		bottom: 200

randomTextView.onLoad ->
		
	@padding = {left: 16, top: 16, right: 16}
	
	Utils.bind @content, ->
	
		title = new H4
			name: 'Title'
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Utils.randomText**(words, [sentences = false, [paragraphs = false]])"
		
		Utils.toMarkdown(title)
		
		body = new Body2
			parent: @
			width: @width - 32
			text: "Utils.randomText will generate *n* words of lorem ipsum text. By default, the string will be lower case words separated by a space, but you can return sentences or paragraphs as well."
			padding: {bottom: 16}
		
		Utils.toMarkdown(body)
				
		# words
		
		@parent.padding = null
		
		content = new Content(@)
		
		textLayer = new Body1
			parent: content
			text: Utils.randomText(16)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"textLayer = new Body2"
				"text: Utils.randomText(16)",
				]
		
		# sentences
		
		content = new Content(@)
		
		textLayer = new Body1
			parent: content
			text: Utils.randomText(16, true)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"textLayer = new Body2"
				"text: Utils.randomText(16, true)",
				]
		
		# paragraphs
		
		content = new Content(@)
		
		textLayer = new Body1
			parent: content
			text: Utils.randomText(48, true, true)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"textLayer = new Body2"
				"text: Utils.randomText(16, true, true)",
				]
		
		# cleanup
		Utils.offsetY(@children, 16)
	@updateContent()

# Utils.isEmail View

isEmailView = new View
	title: 'Utils.isEmail'
	contentInset:
		bottom: 200

isEmailView.onLoad ->
		
	@padding = {left: 16, top: 16, right: 16}
	
	Utils.bind @content, ->
	
		title = new H4
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Utils.isEmail**(string)"
		
		Utils.toMarkdown(title)
		
		body = new Body2
			parent: @
			width: @width - 32
			text: "Utils.isEmail will return `true` if the string is a valid email address, or `false` if it isn't. This works well with an TextInput's 'change:value' event:"
		
		code = new Code
			parent: @
			text: "input.onChange 'value', (value) ->\n\tbutton.disabled = !Utils.isEmail(value)"
			padding: {bottom: 16}
		
		Utils.toMarkdown(body)
		
		@parent.padding = null
		
		# validEmail
		
		content = new Content(@)
		
		input = new TextInput
			parent: content
			value: 'stevecase@aol.com'
		
		button = new Button
			parent: content
			text: 'Submit'
			disabled: !Utils.isEmail(input.value)
		
		input.onChange "value", (value) -> button.disabled = !Utils.isEmail(value)
		
		Utils.offsetY(content.children, 8)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"new Button"
				"text: 'submit'"
				"disabled: !Utils.isEmail(input.value)"
				]
		
		# invalidEmail
		
		content = new Content(@)
		
		input1 = new TextInput
			parent: content
			value: 'stevecase@aol.c0m'
		
		button1 = new Button
			parent: content
			text: 'Submit'
			disabled: !Utils.isEmail(input1.value)
		
		input1.onChange "value", (value) -> button1.disabled = !Utils.isEmail(value)
		
		Utils.offsetY(content.children, 8)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"new Button"
				"text: 'submit'"
				"disabled: !Utils.isEmail(input.value)"
				]
		
		# cleanup
		Utils.offsetY(@children, 16)
	@updateContent()


# Utils.copyTextToClipboard View

copyTextView = new View
	title: 'Utils.copyTextToClipboard'
	contentInset:
		bottom: 200

copyTextView.onLoad ->
		
	@padding = {left: 16, top: 16, right: 16}
	
	Utils.bind @content, ->
	
		title = new H4
			parent: @
			fontWeight: 400
			width: @width - 32
			text: "**Utils.copyTextToClipboard**(string)"
		
		Utils.toMarkdown(title)
		
		body = new Body2
			parent: @
			width: @width - 32
			text: "Utils.copyTextToClipboard will copy a given string to the user's clipboard, as if the user had selected the text and pressed Command + C."
			padding: {bottom: 16}
		
		Utils.toMarkdown(body)
		
		@parent.padding = null
		
		# invalidEmail
		
		content = new Content(@)
		
		input = new TextInput
			parent: content
			value: 'This text will get copied to the clipboard.'
		
		button1 = new Button
			parent: content
			text: 'Copy to Clipboard'
			select: -> Utils.copyTextToClipboard(input.value)
			
		Utils.offsetY(content.children, 8)
		
		Utils.contain(content)
		
		new DocComponent
			parent: @
			text: [
				"new Button"
				"text: 'Copy to Clipboard'"
				"select: ->\n\t\ttext = input.value \n\t\tUtils.copyTextToClipboard(text)"
				]
		
		# cleanup
		Utils.offsetY(@children, 16)
	@updateContent()

# ----------------

# Home View

homeView = new View
	title: 'Framework'

homeView.onLoad ->
	Utils.bind @content, ->
		# foundations
		new H3
			parent: @
			text: 'Foundations'
			y: 32
			padding: {top: 24, bottom: 16}
		
		new RowLink
			parent: @
			text: 'Theme'
			
		new RowLink
			parent: @
			text: 'Color'
			link: colorsView
			
		new RowLink
			parent: @
			text: 'Typography'
			link: typographyView
		
		new RowLink
			parent: @
			text: 'Icon'
			link: iconsView
		
		
		# structure
		new H3
			parent: @
			text: 'Structure'
			padding: {top: 16, bottom: 16}
		
		new RowLink
			parent: @
			text: 'App'
			
		new RowLink
			parent: @
			text: 'View'
			
		new RowLink
			parent: @
			text: 'Header'
		
		# buttons
		new H3
			parent: @
			text: 'Buttons'
			padding: {top: 16, bottom: 16}
			
		new RowLink
			parent: @
			text: 'Link'
			link: linksView
			
		new RowLink
			parent: @
			text: 'Button'
			link: buttonsView
		
		# inputs
		new H3
			parent: @
			text: 'Inputs'
			padding: {top: 16, bottom: 16}
			
		new RowLink
			parent: @
			text: 'TextInput'
			link: textInputsView
			
		new RowLink
			parent: @
			text: 'Select'
			link: selectsView
			
		new RowLink
			parent: @
			text: 'Checkbox'
			link: inputsView
			
		new RowLink
			parent: @
			text: 'Radiobox'
			link: inputsView
			
		new RowLink
			parent: @
			text: 'Stepper'
			link: steppersView
			
		new RowLink
			parent: @
			text: 'Segment'
			link: segmentsView
			
		new RowLink
			parent: @
			text: 'Toggle'
			link: togglesView
		
		
		# components
		new H3
			parent: @
			text: 'Components'
			padding: {top: 16, bottom: 16}
			
		new RowLink
			parent: @
			text: 'TabComponent'
			link: tabComponentView
			
		new RowLink
			parent: @
			text: 'SortableComponent'
			link: sortableComponentView
			
		new RowLink
			parent: @
			text: 'DocComponent'
			
		new RowLink
			parent: @
			text: 'CarouselComponent'
			
		# misc
		new H3
			parent: @
			text: 'Miscellaneous'
			padding: {top: 16, bottom: 16}
			
		new RowLink
			parent: @
			text: 'Tooltip'
			link: tooltipsView
			
		new RowLink
			parent: @
			text: 'Utils'
			link: utilsView
		
		# set child positions
		
		Utils.offsetY(@children, 0)
	
	@updateContent()
	
	addDocsLink(@, '', 'github-circle')


app.showNext(homeView)


# ----------------
# Debugging

# app.views.forEach (view, i) ->
# 	Utils.delay i, ->
# 		app.showNext view
