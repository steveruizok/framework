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

# Typography View

typographyView = new View
	title: 'Typography'

Utils.bind typographyView.content, ->
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
	colorList = require 'components/Colors'
	
	i = 0
	for k, v of colorList.Colors
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
	buttons = _.map _.range(8), (i) =>
		button = new Button
			name: '.'
			parent: @
			secondary: i % 4 > 1
			disabled: i % 2 is 1
			dark: i >= 4
			y: 16 + (i * 80)
			x: 32
			
		strings = []
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
		height: _.last(buttons).y - buttons[3].y
		backgroundColor: deepGray
	
	dark.sendToBack()

# Example View

exampleView = new View
	title: 'Example'
	
Utils.bind exampleView, ->
	
	@header = new H2
		parent: @content
		x: Align.center
		y: 96
		text: 'Framework'
	
	@lead = new Body
		parent: @content
		x: Align.center
		y: @header.maxY + 12
		text: 'A Component Kit for Framer'
		
	@signup = new Button
		parent: @content
		x: Align.center()
		y: @lead.maxY + 160
		text: 'Sign Up'
		width: 200
	
	@login = new Button
		parent: @content
		x: Align.center()
		y: @signup.maxY + 16
		secondary: true
		text: 'Log In'
		width: 200

exampleView.onLoad = ->
	for child, i in @content.children
	
		y = child.y
		
		_.assign child, 
			opacity: 0
			y: y - 16
			ignoreEvents: true
		
		delay = .5 + (.15 * i)
		if i > 1 then delay += .5
		
		child.animate
			opacity: 1
			y: y
			options:
				time: .8
				delay: delay
		
		do (child) =>
			Utils.delay 2, =>
				child.ignoreEvents = false

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
		
		do (view) =>
			button.onSelect =>
				app.showNext view


app.showNext homeView