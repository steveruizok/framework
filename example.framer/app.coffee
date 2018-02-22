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


# ----------------
# App

app = new App
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
				"new TextInput",
				"placeholder: '#{layer.placeholder}'"
				"value: '{value}'"
				"disabled: #{layer.disabled}"
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
					Utils.copyTextToClipboard(label)
				
				layer.on "change:value", (value) -> 
					label.template =
						value: value
			
				label.template =
					value: layer.value
			
			last = label
		
	addDocsLink(@, 'wiki/TextInput')

# Selects View

selectsView = new View
	title: 'Selects'

selectsView.onLoad ->
	Utils.bind @content, ->
		
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
				"new Select",
				"options: [\n\t\t#{_.join(_.map(layer.options, (n) -> return "'#{n}'"), '\n\t\t')}\n\t\t]"
				"selectedIndex: {index}"
				"value: {value}"
				"disabled: {disabled}"
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
					Utils.copyTextToClipboard(label)
					
				layer.on "change:disabled", (bool) -> 
					label.template =
						disabled: bool
					
				layer.on "change:selectedIndex", (selectedIndex) -> 
					label.template =
						index: layer.selectedIndex
						value: layer.value
			
				label.template =
					index: layer.selectedIndex
					value: layer.value
					disabled: layer.disabled
			
			last = label
		
	addDocsLink(@, 'wiki/Select')

# Checkbox

# Radiobox

# Steppers View

steppersView = new View
	title: 'Steppers'

steppersView.onLoad ->
	Utils.bind @content, ->
	
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
				"new Stepper",
				"options: [#{_.join(_.map(layer.options, (n) -> return "'#{n}'"), ', ')}]",
				"icon: #{layer.icon}",
				"min: #{layer.min}",
				"max: #{layer.max}",
				"value: {value}"
				].join('\n\t')
				
			label = new Code
				name: '.'
				parent: @
				x: layer.x
				y: layer.maxY + 24
				text: string
				
			label.template = layer.value
			
			copyIcon = new Icon
				parent: @
				y: label.midY - 12
				x: Align.right(-16)
				icon: 'content-copy'
				color: grey
				
			do (layer, label, copyIcon) ->
				
				copyIcon.onTap ->
					Utils.copyTextToClipboard(label)
					
				layer.on "change:value", =>
					label.template = layer.value
			
			last = label
		
		
	addDocsLink(@, 'wiki/Stepper')

# Segments View

segmentsView = new View
	title: 'Segments'
	contentInset:
		bottom: 128

segmentsView.onLoad ->
	Utils.bind @content, ->
	
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
				"new Segment",
				"options: [#{_.join(_.map(layer.options, (n) -> return "'#{n}'"), ', ')}]"
				"icon: #{layer.icon}"
				"active: {active}"
				layer.extra ? ""
				].join('\n\t')
				
			label = new Code
				name: '.'
				parent: @
				x: layer.x
				y: layer.maxY + 24
				text: string
				
			label.template = layer.active
			
			copyIcon = new Icon
				parent: @
				y: label.midY - 12
				x: Align.right(-16)
				icon: 'content-copy'
				color: grey
				
			do (layer, label, copyIcon) ->
				
				copyIcon.onTap ->
					Utils.copyTextToClipboard(label)
					
				layer.on "change:active", =>
					label.template = layer.active
			
			last = label
	
		

	addDocsLink(segmentsView, 'wiki/Segment')

# Toggles View

togglesView = new View
	title: 'Toggles'
	contentInset:
		bottom: 128

togglesView.onLoad ->
	Utils.bind @content, ->
	
		# toggles
		
		new Toggle 
			name: 'Toggle'
			parent: @ 
			
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
				"new Topggle",
				"options: [#{_.join(_.map(layer.options, (n) -> return "'#{n}'"), ', ')}]"
				"icon: #{layer.icon}"
				"toggled: {toggled}"
				].join('\n\t')
							
			label = new Code
				name: '.'
				parent: @
				x: layer.x
				y: layer.maxY + 24
				text: string
				
			label.template = layer.toggled
			
			copyIcon = new Icon
				parent: @
				y: label.midY - 12
				x: Align.right(-16)
				icon: 'content-copy'
				color: grey
				
			do (layer, label, copyIcon) ->
				
				copyIcon.onTap ->
					Utils.copyTextToClipboard(label)
					
				layer.on "change:active", =>
					label.template = layer.toggled
			
			last = label
	
		
		
	
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
			
		# radiobox
		
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
			direction: 'above'
		
		new Tooltip
			name: 'Tooltip Right'
			parent: @
			text: 'Tooltip right of an element'
			direction: 'right'
		
		new Tooltip
			name: 'Tooltip Below'
			parent: @
			text: 'Tooltip below an element'
			direction: 'below'
		
		new Tooltip
			name: 'Tooltip Left'
			parent: @
			text: 'Tooltip left of an element'
			direction: 'left'
	
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
				"direction: '#{layer.direction}'",
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
					Utils.copyTextToClipboard(label)
					
			
			last = label
		
	addDocsLink(@, 'wiki/Tooltip')

# Example View

exampleView = new View
	title: 'Example'

exampleView.onLoad ->
	Utils.bind @content, ->
		
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
	
	for child, i in _.dropRight(@content.children, 1)
	
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
	
	@email.value = ''
	@signup.disabled = true
	
	@iconLayer.props =
		opacity: 0
		scale: .8
	
	@iconLayer.animate
		opacity: 1
		scale: 1
		options:
			delay: 1
			time: .7


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
			text: 'SortableComponent'
			link: sortableComponentView
			
		new RowLink
			parent: @
			text: 'Carousel'
			
		# misc
		new H3
			parent: @
			text: 'Miscellaneous'
			padding: {top: 16, bottom: 16}
			
		new RowLink
			parent: @
			text: 'Tooltip'
			link: tooltipsView
		
		# set child positions
		
		Utils.offsetY(@children, 0)
	
	@updateContent()
	
	addDocsLink(@, '', 'github-circle')


app.showNext homeView