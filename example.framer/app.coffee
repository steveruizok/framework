require 'framework'
{ theme } = require 'components/Theme' # not usually needed

# Setup
Canvas.backgroundColor = bg3
Framer.Extras.Hints.disable()

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
		
		@textLayer = new H4
			parent: @
			x: 12
			y: 12
			text: options.text
		
		@height = @textLayer.maxY + 16
			
		if @link
			@chevron = new Icon
				icon: 'chevron-right'
				color: black30
				parent: @
				x: Align.right(-16)
				y: Align.center()
				
			@textLayer.color = yellow80
			
			@onTap (event) => 
				return if Math.abs(event.offset.y) > 10
				app.showNext(@link)
		

app = new App

SHOW_ALL = true
SHOW_LAYER_TREE = false

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
			docsLinkCircle.onTap -> window.open("https://github.com/steveruizok/framework/#{url}")

# Typography View

typographyView = new View
	title: 'Typography'

typographyView.onLoad ->
	Utils.bind @content, ->
		return if not SHOW_ALL
		
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
	
		if not SHOW_LAYER_TREE then child.name = '.' for child in @children

addDocsLink(typographyView, 'wiki/Typography')

typographyView.onUnload ->
	for child in @content.children
		child.destroy()

# Icons View

iconsView = new View
	title: 'Icons'

iconsView.onLoad ->
	Utils.bind @content, ->
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
	
addDocsLink(iconsView, 'wiki/Icon')

iconsView.onUnload ->
	for child in @content.children
		child.destroy()

# Colors View

colorsView = new View
	title: 'Colors'
	
colorsView.onLoad ->
	Utils.bind @content, ->
		return if not SHOW_ALL
		
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

addDocsLink(colorsView, 'wiki/Colors')

colorsView.onUnload ->
	for child in @content.children
		child.destroy()

# Links View

linksView = new View
	title: 'Typography'
	
linksView.onLoad ->
	Utils.bind @content, ->
		return if not SHOW_ALL
		
		new H2Link
			parent: @
			text: 'Click here'
			x: 16
			
		new H2Link
			parent: @
			text: 'Click here'
			x: 16
			select: => print "Clicked!"
			
		new H2Link
			parent: @
			text: 'Click here'
			x: 16
			disabled: true
			select: => print "Clicked!"
			
		new H2Link
			parent: @
			text: 'Click here'
			x: 16
			color: red
			select: => print "Clicked!"
			
		for layer, i in @children
			continue if layer.constructor.name isnt 'Link'
			
			layer.y = (last ? 32)
			
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
			
			last = label.maxY + 32
		
		
		i = 0
		for k, v of theme.typography
			if window[k + 'Link']
				textExample = new window[k + 'Link']
					parent: @
					y: (last ? 0)
					text: k + 'Link'
					x: 16
				
				label = new Code
					parent: @
					name: '.'
					x: 16
					y: textExample.maxY + 4
					text: "new #{k}Link"
					color: black
				
				last = label.maxY + 32
	
		if not SHOW_LAYER_TREE then child.name = '.' for child in @children
	
addDocsLink(linksView, 'wiki/Link')

linksView.onUnload ->
	for child in @content.children
		child.destroy()

# Buttons View

buttonsView = new View
	title: 'Buttons'
	
buttonsView.onLoad ->
	Utils.bind @content, ->
		return if not SHOW_ALL
		
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
	
		if not SHOW_LAYER_TREE then child.name = '.' for child in @children
		
addDocsLink(buttonsView, 'wiki/Button')

buttonsView.onUnload ->
	for child in @content.children
		child.destroy()

# Steppers View

steppersView = new View
	title: 'Steppers'

steppersView.onLoad ->
	Utils.bind @content, ->
		return if not SHOW_ALL
	
		stepper = new Stepper
			parent: @
		
		stepper = new Stepper
			parent: @
			value: 0
			
		stepper = new Stepper
			parent: @
			value: 10
			
		stepper = new Stepper
			parent: @
			min: 50
			max: 100
			value: 42
			
		stepper = new Stepper
			parent: @
			options: ['Less', 'More']
			icon: false
			
		# set positions and create code labels
		
		for layer in @children
			continue if layer.constructor.name isnt 'Stepper'
			
			layer.y = (last?.maxY ? 32) + 32
		
		
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
				y: layer.maxY + 16
				text: string
				
			label.template = layer.value
			
			do (label, layer) ->
				layer.on "change:value", =>
					label.template = layer.value
			
			last = label
		
		if not SHOW_LAYER_TREE
			child.name = '.' for child in @children
		
addDocsLink(steppersView, 'wiki/Stepper')

steppersView.onUnload ->
	for child in @content.children
		child.destroy()

# Sortables View

sortablesView = new View
	title: 'Sortables'

sortablesView.onLoad ->
	Utils.bind @content, ->
		return if not SHOW_ALL
		
		positions = []
		
		for i in _.range(7)
			sortable = new Sortable
				parent: @
				name: 'Sortable'
				positions: positions
				x: Align.center()
				y: 32
				width: @width * .618
				backgroundColor: null
			
			new Button
				parent: sortable
				width: sortable.width
				color: black
				backgroundColor: Color.mix(yellow, blue, i/7)
				text: 'Sortable ' + i
				borderRadius: 4
				
		if not SHOW_LAYER_TREE then child.name = '.' for child in @children
	
	addDocsLink(sortablesView, 'wiki/Sortable')

sortablesView.onUnload ->
	for child in @content.children
		child.destroy()

# Segments View

segmentsView = new View
	title: 'Segments'
	contentInset:
		bottom: 128

segmentsView.onLoad ->
	Utils.bind @content, ->
		return if not SHOW_ALL
	
		# Segments
		
		label = new H4
			parent: @
			text: 'Segment'
			y: 16
			
		new Segment 
			name: 'Segment'
			parent: @ 
			
		new Segment 
			name: 'Segment Active'
			parent: @ 
			active: 1
		
		new Segment 
			name: 'Segment Three'
			parent: @ 
			options: ['Good', 'Nuetral', 'Evil']
		
		new Segment 
			name: 'Segment Icons'
			parent: @
			options: ['phone', 'email', 'snapchat']
			icon: true
		
		new Segment 
			name: 'Segment Custom Colors'
			parent: @ 
			options: ['phone', 'email', 'snapchat']
			icon: true
			color: white
			backgroundColor: blue60
		
		new Segment 
			name: 'Segment Blank'
			parent: @ 
			options: [' ', ' ', ' ']
			
		# set positions and create code labels
		
		for layer in @children
			if layer.constructor.name is 'Segment'
			
				layer.y = (last?.maxY ? 32) + 32
			
				string = [
					"new Segment",
					"options: [#{_.join(_.map(layer.options, (n) -> return "'#{n}'"), ', ')}]"
					"icon: #{layer.icon}"
					"active: {active}"
					].join('\n\t')
					
				label = new Code
					name: '.'
					parent: @
					x: layer.x
					y: layer.maxY + 16
					text: string
					
				label.template = layer.active
				
				do (label, layer) ->
					layer.on "change:active", =>
						label.template = layer.active
				
				last = label
	
		if not SHOW_LAYER_TREE then child.name = '.' for child in @children

addDocsLink(segmentsView, 'wiki/Segment')

segmentsView.onUnload ->
	for child in @content.children
		child.destroy()

# Toggles View

togglesView = new View
	title: 'Toggles'
	contentInset:
		bottom: 128

togglesView.onLoad ->
	Utils.bind @content, ->
		return if not SHOW_ALL
	
		# toggles
		
		label = new H4
			parent: @
			text: 'Toggle'
			y: 16
			
		new Toggle 
			name: 'Toggle'
			parent: @ 
			
		new Toggle 
			name: 'Toggle Toggled'
			parent: @ 
			toggled: true
		
		new Toggle 
			name: 'Toggle Options'
			parent: @ 
			options: ['Good', 'Evil']
		
		new Toggle 
			name: 'Toggle Icons'
			parent: @ 
			options: ['pizza', 'apple']
			icon: true
		
		new Toggle 
			name: 'Toggle Custom Colors'
			parent: @ 
			options: ['phone', 'email']
			icon: true
			color: white
			backgroundColor: blue60
		
		new Toggle 
			name: 'Toggle Blank'
			parent: @ 
			options: [' ', ' ']
			
		# set positions and create code labels
		
		for layer in @children
			if layer.constructor.name is 'Toggle'
				layer.y = (last?.maxY ? 32) + 32
			
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
					y: layer.maxY + 16
					text: string
					
				label.template = layer.toggled
				
				do (label, layer) ->
					layer.on "change:active", =>
						label.template = layer.toggled
				
				last = label
	
		
		if not SHOW_LAYER_TREE then child.name = '.' for child in @children
	
addDocsLink(togglesView, 'wiki/Toggle')

togglesView.onUnload ->
	for child in @content.children
		child.destroy()

# Inputs View

inputsView = new View
	title: 'Inputs'

inputsView.onLoad ->
	Utils.bind @content, ->
		return if not SHOW_ALL
		
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
	
# 		if not SHOW_LAYER_TREE then child.name = '.' for child in @children

addDocsLink(inputsView, 'wiki/Inputs')

inputsView.onUnload ->
	for child in @content.children
		child.destroy()

# Tooltips View

tooltipsView = new View
	title: 'Tooltips'

tooltipsView.onLoad ->
	Utils.bind @content, ->
		return if not SHOW_ALL
		
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
			continue if layer.constructor.name isnt 'Tooltip'
			
			layer.y = (last?.maxY ? 0) + 32
		
			string = [
				"new Tooltip",
				"direction: '#{layer.direction}'",
				"text: '#{layer.text}'",
				].join('\n\t')
				
			label = new Code
				name: '.'
				parent: @
				x: layer.x
				y: layer.maxY + 16
				text: string
			
			last = label
		
# 		if not SHOW_LAYER_TREE then child.name = '.' for child in @children

addDocsLink(tooltipsView, 'wiki/Tooltips')

tooltipsView.onUnload ->
	for child in @content.children
		child.destroy()

# Example View

exampleView = new View
	title: 'Example'

exampleView.onLoad ->
	Utils.bind @content, ->
		return if not SHOW_ALL
		
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

exampleView.onUnload ->
	for child in @content.children
		child.destroy()

# Home View

homeView = new View
	title: 'Framework'

Utils.bind homeView.content, ->
	
	# foundations
	new H3
		parent: @
		text: 'Foundations'
		padding: {top: 24, bottom: 16}
	
	new RowLink
		parent: @
		text: 'Theme'
		
	new RowLink
		parent: @
		text: 'Colors'
		link: colorsView
		
	new RowLink
		parent: @
		text: 'Typography'
		link: typographyView
	
	
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
		
	
	# components
	new H3
		parent: @
		text: 'Components'
		padding: {top: 16, bottom: 16}
	
	new RowLink
		parent: @
		text: 'Icon'
		link: iconsView
		
	new RowLink
		parent: @
		text: 'Link'
		link: linksView
		
	new RowLink
		parent: @
		text: 'Button'
		link: buttonsView
		
	new RowLink
		parent: @
		text: 'Sortable'
		link: sortablesView
		
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
		text: 'Checkbox'
		link: inputsView
		
	new RowLink
		parent: @
		text: 'TextInput'
		link: inputsView
		
	new RowLink
		parent: @
		text: 'Tooltip'
		link: tooltipsView
		
	new RowLink
		parent: @
		text: 'Segment'
		link: segmentsView
		
	new RowLink
		parent: @
		text: 'Toggle'
		link: togglesView
		
	new RowLink
		parent: @
		text: 'Stepper'
		link: steppersView
	
	# set child positions
	
	for child in @children
		child.y = last ? 0
		
		last = child.maxY
	
		if not SHOW_LAYER_TREE then child.name = '.'
	
homeView.updateContent()
addDocsLink(homeView, '', 'github-circle')


app.showNext homeView