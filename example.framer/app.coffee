require 'framework'
{ theme } = require 'components/Theme' # not usually needed

# Setup

Canvas.backgroundColor = '#000'

# ----------------
# custom stuff

# ----------------
# data

# User

user =
	name: 'Charlie Rogers'
	age: 28
	sex: Utils.randomChoice(['female', 'male', 'nonbinary'])
	date: new Date

app = new App
	safari: false

SHOW_ALL = true

# Typography View

typographyView = new View
	title: 'Typography'

Utils.bind typographyView.content, ->
	return if not SHOW_ALL
	
	i = 0
	for k, v of theme.typography
		if window[k]
			textExample = new window[k]
				name: '.'
				parent: @
				y: (textExample?.maxY ? 0) + 16
				text: k
				x: 64
			
			label = new Code
				parent: @
				name: '.'
				x: Screen.width * 3/5
				text: "new #{k}"
				color: '#000'
			
			label.midY = textExample.midY

# Icons View

iconsView = new View
	title: 'Icons'

Utils.bind iconsView.content, ->
	return if not SHOW_ALL
	
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
			color: '#000'
		
		label.midY = icon.midY
		
	label = new Body
		parent: @
		name: '.'
		y: label.maxY + 48
		x: Align.center
		textAlign: 'center'
		text: "For full list, see\nhttp://www.materialdesignicons.com"
		color: '#000'

# Colors View

colorsView = new View
	title: 'Colors'

Utils.bind colorsView.content, ->
	return if not SHOW_ALL
	{ colors } = require 'components/Colors'
	
	i = 0
	for k, v of colors
		chip = new Layer
			parent: @
			name: '.'
			width: (Screen.width / 2) - 16
			height: 64
			x: 16
			y: 16 + (i * 72)
			borderRadius: 2
			backgroundColor: v
			borderWidth: 1
			borderColor: new Color(v).darken(10)
		
		label = new Code
			parent: @
			name: '.'
			x: chip.maxX + 32
			text: "'#{k}'"
			color: '#000'
			
		label.midY = chip.midY
		
		i++

# Buttons View

buttonsView = new View
	title: 'Buttons'

Utils.bind buttonsView.content, ->
	return if not SHOW_ALL
	buttons = _.map _.range(24), (i) =>
		button = new Button
			name: '.'
			parent: @
			secondary: i % 4 > 1
			disabled: i % 2 is 1
			dark: Math.floor(i/4) % 2 is 1
			icon: if i >= 8 then 'star'
			y: 16 + (i * 80)
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
		parent: @
		width: @width
		y: buttons[4].y - 16
		height: buttons[7].y - buttons[3].y
		backgroundColor: black

	dark2 = new Layer
		parent: @
		width: @width
		y: buttons[12].y - 16
		height: buttons[15].y - buttons[11].y
		backgroundColor: black
		
	dark3 = new Layer
		parent: @
		width: @width
		y: buttons[20].y - 16
		height: buttons[23].y - buttons[19].y
		backgroundColor: black
	
	dark.sendToBack()
	dark2.sendToBack()
	dark3.sendToBack()

# Sortables View

sortablesView = new View
	title: 'Sortables'

Utils.bind sortablesView.content, ->
	
	positions = []
	
	for i in _.range(7)
		sortable = new Sortable
			parent: @
			positions: positions
			x: Align.center()
			width: @width * .618
			backgroundColor: null
		
		new Button
			parent: sortable
			width: sortable.width
			color: black
			backgroundColor: green30

# Inputs View

inputsView = new View
	title: 'Inputs'

Utils.bind inputsView.content, ->
	
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
		y: checkbox.maxY + 32
		text: 'Submit'
		disabled: true
		
	checkSubmit = ->
		submit.disabled = !(input.value.toLowerCase() is 'sean' and checkbox.checked and _.some(radioboxes, {'checked': true}))

# Example View

exampleView = new View
	title: 'Example'
	
Utils.bind exampleView, ->
	return if not SHOW_ALL
	
	@header = new H2
		parent: @content
		x: Align.center
		y: 80
		text: 'Framework'
	
	@lead = new Body
		parent: @content
		x: Align.center
		y: @header.maxY + 12
		text: 'A Component Kit for Framer'
		
	@email = new TextInput
		parent: @content
		y: @lead.maxY + 160
		width: 228
		x: Align.center()
		placeholder: 'Enter your e-mail'
		
	@signup = new Button
		parent: @content
		x: Align.center()
		y: @email.maxY + 16
		text: 'Sign Up'
		width: 228
		disabled: true
	
	@login = new Button
		parent: @content
		x: Align.center()
		y: @signup.maxY + 16
		secondary: true
		text: 'Log In'
		width: 228
		
	@email.on "change:value", (value) =>
		@signup.disabled = value.slice(-4) isnt '.com'
		
	@iconLayer = new Icon
		parent: @content
		icon: 'drawing-box'
		x: Align.center
		y: 208
		height: 72
		width: 72
		color: red
		opacity: 0

exampleView.onLoad ->
	for child, i in _.dropRight(@content.children, 1)
	
		y = child.y
		
		_.assign child, 
			opacity: 0
			y: y - 16
			ignoreEvents: true
		
		delay = .5 + (.15 * i)
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

# Home View

homeView = new View
	title: 'Framework Components'

Utils.bind homeView.content, ->
	for view, i in app.views
		continue if view is homeView
		
		button = new Button
			name: '.'
			parent: @
			x: Align.center()
			y: 32 + i * 64
			text: view.title
			width: 200
		
		do (view) =>
			button.onSelect =>
				app.showNext view


app.showNext homeView