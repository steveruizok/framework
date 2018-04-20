require 'framework'
# require 'myTheme'

# Setup
{ theme } = require 'components/Theme' # not usually needed

Canvas.backgroundColor = "#222222"
Framer.Extras.Hints.disable()

# dumb thing that blocks events in the upper left-hand corner
dumbthing = document.getElementById("FramerContextRoot-TouchEmulator")?.childNodes[0]
dumbthing?.style.width = "0px"

# HomeView Container

class HomeViewContainer extends Layer 
	constructor: (options = {}) ->
	
		_.defaults options,
			name: options.title
			borderRadius: 2
			width: Screen.width
			backgroundColor: white
			clip: true
			
			title: 'Title'
			links:
				Color: colorsView
	
		super options
		
		titleRow = new Layer
			parent: @
			backgroundColor: linen ? grey30
			width: @width
			height: 32
		
		new H2
			parent: titleRow
			text: options.title
			x: 16
			color: black
			padding: {top: 16, bottom: 16}
			
		Utils.contain(titleRow, true)
		
		_.forIn options.links, (value, key) =>
			new RowLink
				parent: @
				text: key
				link: value
		
		Utils.offsetY(@children, 0)
		Utils.contain(@)
		@height -= 1
		
		for layer in @children
			layer.name = '.'

# Component Header

class ComponentHeader extends Layer 
	constructor: (options = {}) ->
	
		_.defaults options,
			borderRadius: 2
			width: Screen.width
			backgroundColor: white
			clip: true
			
			title: 'Title'
			body: "The body of this component's description."
	
		super options
		
		# the component's title
		
		titleRow = new Layer
			parent: @
			backgroundColor: linen ? grey30
			width: @width
			height: 32
		
		title = new H2
			parent: titleRow
			text: options.title
			x: 16
			color: black
			padding: {top: 16, bottom: 16}
			
		Utils.contain(titleRow, true)
		
		# the description of the component
		
		body = new Body 
			parent: @
			x: 16
			width: @width - 32
			text: options.body
		
		Utils.toMarkdown(body)
		
		
		Utils.offsetY(@children, 16)
		Utils.contain(@)
		@height += 16

# Component Example
class ComponentExample extends Layer
	constructor: (options = {}) ->

		# ---------------
		# Options
		
		_.defaults options,
			name: "Component Example"
			width: Screen.width
			backgroundColor: white
			
			title: 'Title'
			body: undefined
			doc: undefined
			content: undefined
			text: undefined 
			tabbed: undefined
			template: undefined 
			dark: false
		
		super options
		
		if options.dark then @backgroundColor = black80
		
		# the component's title
		
		titleRow = new Layer
			parent: @
			name: '.'
			backgroundColor: linen ? grey30
			width: @width
			height: 32
		
		numberCircle = new Layer
			parent: titleRow
			name: '.'
			height: 32
			width: 40
			backgroundColor: null
			
		number = new H4 
			parent: numberCircle
			name: '.'
			text: '1'
			color: grey60
			y: 64
			width: numberCircle.width
			textAlign: "center"
			text: _.filter(@parent?.children, (c) -> 
				c instanceof ComponentExample
				)?.length
			
		Utils.constrain(numberCircle, 'height')
		
		title = new H4
			parent: titleRow
			text: options.title
			name: '.'
			x: 54
			width: @width - 108
			color: black
			padding: {top: 64, bottom: 16}
			
		Utils.contain(titleRow, true)
		
		
		# the description of the component
		
		if options.body?
			body = new Body
				name: '.'
				parent: @
				x: 54
				width: @width - 70
				text: options.body
			
			Utils.toMarkdown(body)
		
		options.content?.props = 
			parent: @
			x: 54
		
		# fix for sortables
		if options.content instanceof SortableComponent
			scroll = @parent?.parent
			if scroll instanceof ScrollComponent
				options.content.on "change:isSorting", (bool) =>
					scroll.scrollVertical = !bool
		
		if options.text?
			doc = new DocComponent
				name: '.'
				parent: @
				width: @width
				text: options.text
				tabbed: options.tabbed
				template: options.template
			
		Utils.offsetY(@children, 16)
			
		Utils.contain(@, true)
		
		
		# body border
		
		bodyBorder = new Layer
			parent: @
			name: '.'
			x: 0
			y: titleRow.maxY
			width: 40
			height: @height - titleRow.height - (doc?.height ? 0) 
			backgroundColor: null

# Icon Example
class IconExample extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			name: '.'
			icon: "star"
			height: 48
			width: 200
			backgroundColor: null
		
		super options
		
		@iconLayer = new Icon
			parent: @
			icon: options.icon
		
		@iconLabel = new Code
			parent: @
			text: "{label}"
		
		Utils.align @children, 'middle'
		Utils.offsetX(@children, 16)
		
		# definitions
		Utils.define @, "icon", options.icon, @_setLayers
		
		# Events
		@onTap (event) => 
			return if Math.abs(event.offset.y) > 16
			
			Utils.copyTextToClipboard("'#{@icon}'")
			
			@iconLayer.animate
				color: blue
				options: { time: .07 }
					
			Utils.delay .1, =>
				@iconLayer.animate
					color: black
					options: { time: .5 }
		
	_setLayers: (string) ->
		@iconLayer.icon = string
		@iconLabel.template = if string.length > 0 then "'#{string}'" else ""

# Row Link

class RowLink extends Layer
	constructor: (options = {}) ->
		
		_.defaults options,
			text: 'Hello world'
			link: null
			height: 52
			shadowY: 1
			shadowColor: grey30
			backgroundColor: null
		
		super options
		
		_.assign @,
			link: options.link
			width: @parent?.width
			
		# layers
		
		@linkLayer = new H4Link
			parent: @
			x: 16
			y: Align.center()
			text: options.text
			color: if @link then black else grey60
			width: @width
		
		chevron = new Icon
			parent: @
			color: if @link then black else grey60
			size: 16
			icon: "chevron-right"
			x: Align.right(-16)
			y: Align.center()
			
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
			x: Align.right(-8)
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
			
		if app.footer?
			Utils.pin(docsLinkCircle, app.footer, 'top')

# Title Div

titleDiv = (options = {}) ->
	title = new H4
		name: title
		parent: options.parent
		text: _.startCase(options.text)
		x: options.x
		y: options.y
		color: options.color
		
	div = new Layer
		name: 'Div'
		parent: title
		x: title.maxX
		y: Align.bottom(-10)
		width: options.width - (title.maxX) - 32
		color: new Color(options.color).alpha(.8)
		height: 1
		
	title.onChange "text", =>
		div.props =
			y: Align.bottom(-10)


# ----------------
# App

app = new App
# 	showKeys: false
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
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30 ? grey20
	contentInset:
		bottom: 128

iconsView.onLoad ->
	
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "Icon"
		body: "Framework includes over 2,000 icons drawn from www.materialdesignicons.com."
	
	# examples
	
	icon = new Icon
		name: 'Default Icon'
		parent: @
	
	icon = new Icon
		name: 'Icon with Icon'
		icon: "menu"
		parent: @
	
	icon = new Icon
		name: 'Icon with Color'
		icon: "account"
		color: red
		parent: @
	icon.extra = '\tcolor: red'
	
	icon = new Icon
		name: 'Icon with Size'
		icon: "arrow-left"
		parent: @
		size: 64
	icon.extra = '\tsize: 64'
		
	i = 0
	for layer in @children
		continue unless layer instanceof Icon
		
		c = "black"
		
		i++
		
		new ComponentExample
			parent: @content
			title: layer.name
			body: layer.body
			content: layer
			tabbed: false
			text: [
				"new Icon",
				"\ticon: '#{layer.icon}'"
				"\tcolor: #{c}"
				layer.extra ? ""
				]

	# search for icon
	
	content = new Layer
		backgroundColor: null
	
	textInput = new TextInput
		parent: content
		placeholder: "Search for Icons"
		value: ""
		
	resultsLabel = new Label
		parent: content
		text: "Results: ({results})"
		padding: {top: 16, bottom: 16}
		
	iconExamples = _.range(7).map ->
		new IconExample
			parent: content
			icon: 'star'
		
	andMoreLabel = new Label
		parent: content
		text: "...plus {more} more."
			
	iconNames = _.keys(theme.icons)
		
	updateIcons = (value = " ") ->
		v = value?.toLowerCase()
		icons = _.filter(iconNames, (c) ->
			c[0...v.length] is v or _.includes(c, v)
			)
		
		iconExamples.forEach (example, i) ->
			example.icon = icons[i] ? ''
		
		resultsLabel.visible = icons.length > 0
		resultsLabel.template = icons.length
		extra = icons.length - iconExamples.length
		andMoreLabel.visible = extra > 0
		andMoreLabel.template = extra
			
	updateIcons(' ')
	textInput.on "change:value", updateIcons
	
	Utils.offsetY(content.children, 8)
	Utils.contain(content)
	content.height += 32
	
	new ComponentExample
		parent: @content
		title: "Search for icons"
		body: "For an even better search, check www.materialdesignicons.com. Tap icons to copy their icon name as a string."
		content: content

	Utils.offsetY(@content.children)
	@updateContent()
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
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30
	contentInset:
		bottom: 128
	
linksView.onLoad ->
	
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "Link"
		body: "A Link is a TextLayer that runs its `select` method when tapped. All of the Typography styles automatically get link versions when created. For example, `H2` has `H2Link`."
	
	# buttons
		
	new H3Link
		name: 'Default Link'
		parent: @
		text: 'Click here'
		x: 16
		
	new H3Link
		name: 'Link with Select'
		parent: @
		text: 'Click here'
		x: 16
		select: -> @x += 10
		
	new H3Link
		name: 'Disabled Link'
		parent: @
		text: 'Click here'
		x: 16
		disabled: true
		select: -> @x += 10
		
	l = new H3Link
		name: 'Link with Custom Color'
		parent: @
		text: 'Click here'
		x: 16
		color: red
		select: -> @x += 10
	
	l.extra = "\tcolor: red"
		
	i = 0
	for layer in @children
		continue unless layer instanceof H3Link
		
		s = if i > 0 then "link.onSelect -> @x += 10" else ""
		i++ 
		
		new ComponentExample
			parent: @content
			title: layer.name
			body: layer.body
			content: layer
			tabbed: false
			text: [
				"link = new H3Link",
				"\ttext: #{layer.text}"
				layer.extra ? ""
				""
				s
				]
	
		
	Utils.offsetY(@content.children)
	@updateContent()
	addDocsLink(@, 'wiki/Link')

# Buttons View

buttonsView = new View
	title: 'Buttons'
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30
	contentInset:
		bottom: 128
	
buttonsView.onLoad ->
	
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "Button"
		body: "A Button is a button that runs its `select` method when tapped."
	
	# buttons
		
	buttons = _.map _.range(24), (i) =>
		button = new Button
			name: 'Button'
			parent: @
			secondary: i % 4 > 1
			disabled: i % 2 is 1
			dark: Math.floor(i/4) % 2 is 1
			icon: if i >= 8 then 'star'
			y: 32 #+ (i * 80)
			x: 32
			text: if i >= 16 then '' else 'Getting Started'
		
		string = ""
		if button.dark then string += " dark"
		if button.secondary then string += " secondary"
		if button.disabled then string += " disabled"
		string += " button"
		if button.icon?.length > 0 then string += " with icon"
		if button.text?.length is 0 then string += " and no text"
		
		button.name = _.startCase(string)
		
		return button
	
	
	for layer in @children
		continue unless layer instanceof Button
		
		new ComponentExample
			parent: @content
			title: layer.name
			body: layer.body
			content: layer
			dark: layer.dark
			text: [
				"new Button",
				"icon: {icon}"
				"secondary: {secondary}"
				"dark: {dark}"
				"disabled: {disabled}"
				"text: {text}"
				layer.extra ? ""
				]
			template:
				icon: [layer, 'icon', (v) -> "'#{v}'"]
				secondary: [layer, 'secondary']
				dark: [layer, 'dark']
				disabled: [layer, 'disabled']
				text: [layer, 'text', (v) -> "'#{v}'"]
		
		
	Utils.offsetY(@content.children)
	@updateContent()		
	addDocsLink(@, 'wiki/Button')


# ----------------
# Inputs

# TextInputs View

textInputsView = new View
	title: 'TextInputs'
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30
	contentInset:
		bottom: 128

textInputsView.onLoad ->
	
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "TextInput"
		body: "A TextInput allows the user to enter text."
	
	# selects
			
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
		continue unless layer instanceof TextInput
		
		new ComponentExample
			parent: @content
			title: layer.name
			body: layer.body
			content: layer
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
			
	Utils.offsetY(@content.children, 32)
	@updateContent()
	addDocsLink(@, 'wiki/TextInput')

# Selects View

selectsView = new View
	title: 'Selects'
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30
	contentInset:
		bottom: 128

selectsView.onLoad ->
	
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "Select"
		body: "A select is a drop down menu of `options`."
	
	# selects
	
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
		continue unless layer instanceof Select
		
		new ComponentExample
			parent: @content
			title: layer.name
			body: layer.body
			content: layer
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
	
	Utils.offsetY(@content.children)
	@updateContent()
	addDocsLink(@, 'wiki/Select')
		

# Checkbox View

checkboxView = new View
	title: 'Checkbox'
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30
	contentInset:
		bottom: 128

checkboxView.onLoad ->
	
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "Checkbox"
		body: "A checkbox is an icon that can be `checked`. It may also be part of a group of icons, any one or more of which may be checked."
		
	# checkboxes
	
	cbs1 = new Checkbox 
		name: 'Checkbox'
	
	cbs2 = new Checkbox 
		name: 'Checked Checkbox'
		checked: true
	
	cbs3 = new Checkbox 
		name: 'Disabled Checkbox'
		disabled: true
		
	# set positions and create code labels
	
	for layer in [cbs1, cbs2, cbs3]
		continue unless layer instanceof Checkbox
		
		new ComponentExample
			parent: @content
			title: layer.name
			body: layer.body
			content: layer
			text: [
				"new Checkbox",
				"checked: {checked}"
				"disabled: {disabled}"
				]
			template:
				checked: [layer, 'checked']
				disabled: [layer, 'disabled']
		
	# checkboxes group
		
	cbContent = new Layer
		y: 24
		backgroundColor: null
	
	for i in _.range(3)
		rb = new Checkbox 
			name: 'Checkbox'
			parent: cbContent
			y: 32 * i
	
	Utils.offsetY(cbContent.children)
	Utils.contain(cbContent)
	
	new ComponentExample
		parent: @content
		title: "Checkbox Group"
		body: "If checkboxes have the same parent, the parent will get two properties: `checkboxes`, an array of the parent's child checkboxes; and `checked`, an array of its checkboxes' checked states."
		content: cbContent
		text: [
			"cbContainer = new Layer"
			""
			"for i in [0...3]"
			"\tnew Checkbox"
			"\t\tparent: cbContainer"
			""
			"Utils.offsetY(cbContainer.children)"
			"Utils.contain(cbContainer)"
			""
			"print cbContent.checkboxes.length"
			"# » {checkboxes}"
			""
			"print cbContent.checked"
			"# » {checked}"
			]
		tabbed: false
		template:
			checkboxes: [cbContent, 'checkboxes', (v) -> v.length]
			checked: [
				cbContent, 
				'checked', 
				(v) -> "[#{v.join(', ')}]"
				]
	
	# checkboxes group with labels
	
		
	cbContent1 = new Layer
		y: 24
		backgroundColor: null
	
	for i in _.range(3)
		rb = new Checkbox 
			name: 'Checkbox'
			parent: cbContent1
			width: 200
			checked: i is 2
			
		new Body2
			parent: rb
			x: 40
			y: Align.center()
			text: 'Label ' + i
			
	Utils.offsetY(cbContent1.children)
	Utils.contain(cbContent1)
	
	new ComponentExample
		parent: @content
		title: "Checkbox Labels"
		body: "Labels and other content may be added as a Checkbox's child layers. To make these clickable too, make the Checkbox large enough to include them."
		content: cbContent1
		text: [
			"cbContainer = new Layer"
			""
			"for i in [0...3]"
			"\tcb = new Checkbox"
			"\t\tparent: cbContainer"
			"\t\twidth: 200"
			""
			"\tnew Body2"
			"\t\tparent: cb"
			"\t\text: 'Label ' + i"
			""
			"Utils.offsetY(cbContainer.children)"
			"Utils.contain(cbContainer)"
			]
		tabbed: false

	Utils.offsetY(@content.children, 0)
	@updateContent()
	addDocsLink(@, 'wiki/Checkbox')

# Radiobox View

radioboxView = new View
	title: 'Radiobox'
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30
	contentInset:
		bottom: 128

radioboxView.onLoad ->
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "Radiobox"
		body: "A radiobox is part of a group where only one radiobox may be `checked` at once."
		
	# radiobox
	
	rb0 = new Radiobox 
		name: 'Radiobox'
		x: 16
		y: 32
	
	new ComponentExample
		parent: @content
		title: 'Radiobox'
		content: rb0
		text: [
			"new Radiobox"
			"\tchecked: {checked}"
			"\tdisabled: {disabled}"
			]
		tabbed: false
		template:
			checked: [rb0, 'checked']
			disabled: [rb0, 'disabled']
			
	
	# radiobox disabled
	
	rb1 = new Radiobox 
		name: 'Radiobox'
		x: 16
		y: 32
		disabled: true
					
	new ComponentExample
		parent: @content
		title: 'Radiobox (disabled)'
		content: rb1
		text: [
			"new Radiobox"
			"\tchecked: {checked}"
			"\tdisabled: {disabled}"
			]
		tabbed: false
		template:
			checked: [rb1, 'checked']
			disabled: [rb1, 'disabled']
	
	# checkboxes group
		
	rbContainer = new Layer
		x: 16
		y: 24
		backgroundColor: null
	
	for i in _.range(3)
		new Radiobox 
			name: 'Radiobox'
			parent: rbContainer
			
	Utils.offsetY(rbContainer.children)
	Utils.contain(rbContainer)
					
	new ComponentExample
		parent: @content
		title: 'Radiobox Group'
		content: rbContainer
		text: [
			"rbContainer = new Layer"
			""
			"for i in [0...3]"
			"\tnew Radiobox"
			"\t\tparent: rbContainer"
			""
			"Utils.offsetY(rbContainer.children)"
			"Utils.contain(rbContainer)"
			""
			"print rbContent.radioboxes.length"
			"# » {radioboxes}"
			""
			"print rbContent.selectedIndex"
			"# » {selectedIndex}"
			]
		tabbed: false
		template:
			radioboxes: [rbContainer, 'radioboxes', (v) -> v.length]
			selectedIndex: [rbContainer, 'selectedIndex']
	
	# checkboxes group with start value
	
	rbContainer = new Layer
		x: 16
		y: 24
		backgroundColor: null
	
	for i in _.range(3)
		new Radiobox 
			name: 'Radiobox'
			parent: rbContainer
			checked: i is 2
			
	Utils.offsetY(rbContainer.children)
	Utils.contain(rbContainer)
					
	new ComponentExample
		parent: @content
		title: 'Radiobox Group with Starting Checked'
		content: rbContainer
		text: [
			"rbContainer = new Layer"
			""
			"for i in [0...3]"
			"\tnew Radiobox"
			"\t\tparent: rbContainer"
			""
			"Utils.offsetY(rbContainer.children)"
			"Utils.contain(rbContainer)"
			""
			"rbContainer.checkboxes[2].checked = true"
			]
		tabbed: false
		template:
			radioboxes: [rbContainer, 'radioboxes', (v) -> v.length]
			selectedIndex: [rbContainer, 'selectedIndex']
	
	
	# checkboxes group with labels
	
	rbContainer = new Layer
		x: 16
		y: 24
		backgroundColor: null
	
	for i in _.range(3)
		rb = new Radiobox 
			name: 'Radiobox'
			parent: rbContainer
			width: 200
			
		new Body2
			parent: rb
			x: 40
			y: Align.center()
			text: 'Label ' + i
			
	Utils.offsetY(rbContainer.children)
	Utils.contain(rbContainer)
					
	new ComponentExample
		parent: @content
		title: 'Radiobox Group with Labels'
		content: rbContainer
		text: [
			"rbContainer = new Layer"
			""
			"for i in [0...3]"
			"\trb = new Radiobox"
			"\t\tparent: rbContainer"
			"\t\twidth: 200"
			""
			"\tnew Body2"
			"\t\tparent: rb"
			"\t\ttext: 'Label ' + i"
			""
			"Utils.offsetY(rbContainer.children)"
			"Utils.contain(rbContainer)"
			]
		tabbed: false
		template:
			radioboxes: [rbContainer, 'radioboxes', (v) -> v.length]
			selectedIndex: [rbContainer, 'selectedIndex']
	
	Utils.offsetY(@content.children)
	
	@updateContent()
	addDocsLink(@, 'wiki/Radiobox')

# Steppers View

steppersView = new View
	title: 'Steppers'
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30
	contentInset:
		bottom: 128

steppersView.onLoad ->
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "Stepper"
		body: "A stepper allows a user to increase or decrease a value."
	
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
	
		
	for layer in @children
		continue unless layer instanceof Stepper
		
		new ComponentExample
			parent: @content
			title: layer.name
			content: layer
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
				icon: [layer, 'icon', (v) -> "#{v}"]
				min: [layer, 'min']
				max: [layer, 'max']
				value: [layer, 'value', (v) -> "#{v}"]
				options: [layer, 'options', (v) -> 
					return (v.map (o) -> return "'#{o}'").join(', ')
					]
	
	Utils.offsetY(@content.children)
	@updateContent()
	addDocsLink(@, 'wiki/Stepper')

# Segments View

segmentsView = new View
	title: 'Segments'
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30
	contentInset:
		bottom: 128

segmentsView.onLoad ->
	
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "Segment"
		body: "A segment is a group of two or more buttons, only one of which may be the group's `active` button at a time."
	
	# Segments
		
	new Segment 
		name: 'Default Segment'
		parent: @ 
		
	fw = new Segment 
		name: 'Segment with Set Width'
		parent: @ 
		width: 300
	
	fw.extra = "width: 300"
	
	new Segment 
		name: 'Segment with Active'
		parent: @ 
		active: 1
	
	new Segment 
		name: 'Segment with -1 Active'
		parent: @ 
		active: -1
	
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
		continue unless layer instanceof Segment
	
		new ComponentExample
			parent: @content
			title: layer.name
			content: layer
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
	
	Utils.offsetY(@content.children)
	@updateContent()
	addDocsLink(segmentsView, 'wiki/Segment')

# Toggles View

togglesView = new View
	title: 'Toggles'
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30
	contentInset:
		bottom: 128

togglesView.onLoad ->
	
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "Toggle"
		body: "A toggle is a pair of buttons, used to express a binary choice."
	
	# toggles
	
	new Toggle 
		name: 'Toggle'
		parent: @ 
	
	t = new Toggle 
		name: 'Toggle with Width'
		parent: @ 
		width: 300
	
	t.extra = "width: 300"
	
	new Toggle 
		name: 'Toggled Toggle'
		parent: @ 
		toggled: true
	
	new Toggle 
		name: 'Null Toggle'
		parent: @ 
		toggled: null
	
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
		continue unless layer instanceof Toggle
			
		new ComponentExample
			parent: @content
			title: layer.name
			content: layer
			text: [
				"new Toggle",
				"options: [{options}]"
				"icon: #{layer.icon}"
				"toggled: {toggled}"
				layer.extra ? ""
				]
			template:
				icon: [layer, 'icon']
				toggled: [layer, 'toggled']
				options: [layer, 'options', (v) -> 
					return (v.map (o) -> return "'#{o}'").join(', ')
					]
		
	Utils.offsetY(@content.children)
	@updateContent()		
	addDocsLink(@, 'wiki/Toggle')


# ----------------
# Components

# SortableComponent View

sortableComponentView = new View
	title: 'SortableComponent'
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30
	contentInset:
		bottom: 128

sortableComponentView.onLoad ->
	
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "SortableComponent"
		body: "A Sortable allows the user to drag its children into new positions."
	
	# sortable
	
	sortable = new SortableComponent
		x: Align.center()
		width: @width * .618
	
	for i in _.range(3)
		
		new Layer
			parent: sortable
			name: 'Layer ' + i
			x: 0
			y: 16
			width: sortable.width
			height: 48
	
	Utils.offsetY(sortable.children, 8)
			
	new ComponentExample
		parent: @content
		title: "Sortable Component"
		content: sortable
		tabbed: false
		text: [
			"sortable = new Sortable"
			""
			"for i in [0...3]"
			"\tnew Layer"
			"\t\tparent: sortable"
			"\t\tname: 'Layer ' + i"
			"\t\theight: 40"
			""
			"Utils.offsetY(sortable.children, 8)"
			""
			"print sortable.current"
			""
			"# » [{current}]"
			]
		template:
			current: [sortable, 'current', (arr) -> arr.map( (l) -> "<Layer id:#{l.id} name:#{l.name} >").join(", ")]
	
	# Sortable with handle
	
	sortable = new SortableComponent
		x: Align.center()
		width: @width * .618
		backgroundColor: null
	
	for i in _.range(4)
		
		last = new Layer
			parent: sortable
			y: 0
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
	
	Utils.offsetY(sortable.children, -1)
			
	new ComponentExample
		parent: @content
		title: "Sortable Component with Handles"
		content: sortable
		tabbed: false
		text: [
			"sortable = new Sortable"
			""
			"for i in [0...3]"
			"\trow = new Layer"
			"\t\tparent: sortable"
			"\t\theight: 40"
			""
			"\trow.handle = new Layer"
			"\t\tparent: row"
			"\t\tsize: 40"
			"\t\tx: Align.right()"
			""
			"Utils.offsetY(sortable.children)"
			]
		template: {}
	
	
	# Sortable with dragging states
	
	sortable = new SortableComponent
		parent: @
		x: Align.center()
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
			y: 0
			width: sortable.width
			height: 48
			backgroundColor: green30
			borderColor: green
			borderWidth: 1
	
	Utils.offsetY(sortable.children)
			
	new ComponentExample
		parent: @content
		title: sortable.name
		content: sortable
		tabbed: false
		text: [
			"sortable = new Sortable"
			"\tdraggingState:"
			"\t\tscale: 1.2"
			"\t\tbackgroundColor: blue30"
			"\t\topacity: .8"
			"\tdefaultState:"
			"\t\tscale: 1"
			"\t\tbackgroundColor: green30"
			"\t\topacity: 1"
			""
			"for i in [0...3]"
			"\tnew Layer"
			"\t\tparent: sortable"
			"\t\theight: 40"
			""
			"Utils.offsetY(sortable.children)"
			]
		template: {}
	
		
	
	# Sortable with other content
			
	sortable = new SortableComponent
		parent: @
		x: Align.center()
		width: @width * .618
		backgroundColor: null
	
	for i in _.range(3)
		cb = new Checkbox 
			name: 'Checkbox'
			parent: sortable
			width: sortable.width
			checked: i is 2
			
		new Body2
			parent: cb
			x: 40
			y: Align.center()
			text: 'Label ' + i
		
		cb.handle = new Layer
			parent: cb
			x: Align.right()
			height: cb.height
			width: 40
			backgroundColor: null
			propagateEvents: false
		
		new Icon
			parent: cb.handle
			x: Align.right(-8)
			y: Align.center()
			icon: 'drag'
	
	Utils.offsetY(sortable.children)
	Utils.contain(sortable)
			
	new ComponentExample
		parent: @content
		title: "Sortable with other content"
		content: sortable
		tabbed: false
		text: [
			"sortable = new Sortable"
			""
			"for i in [0...3]"
			"\trow = new Checkbox"
			"\t\tparent: sortable"
			"\t\twidth: 200"
			""
			"\tnew Body2"
			"\t\tparent: row"
			"\t\text: 'Label ' + i"
			""
			"\trow.handle = new Layer"
			"\t\tparent: row"
			"\t\tsize: 40"
			"\t\tx: Align.right()"
			""
			"Utils.offsetY(sortable.children)"
			"Utils.contain(sortable)"
			]
		template: {}
	
	Utils.offsetY(@content.children)
	@updateContent()
	addDocsLink(@, 'wiki/SortableComponent')

# CarouselComponent

carouselComponentView = new View
	title: 'Carousels'

carouselComponentView.onLoad ->
	
	addDocsLink(carouselComponentView, 'wiki/CarouselComponent')

# TabComponent View

tabComponentView = new View
	title: 'TabComponent'
	padding: null

tabComponentView.onLoad ->
	
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "TabComponent"
		body: "A TabComponent manages several layers, called `tabs`. The `active` or `current` tab is placed in front of the other tabs. The user can select a new `active` tab by tapping on the tab's button."
		
			
	# examples
	
	# 1

	t1 = new TabComponent
			
	new ComponentExample
		parent: @content
		title: "Tab Component"
		content: t1
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
				"<Layer id:#{v.id} name:#{v.name}>"
				]
	
	
	# Active
	
	t2 = new TabComponent
		active: 1
			
	new ComponentExample
		parent: @content
		title: "Tab Component with active tab"
		content: t2
		tabbed: false
		text: [
			"t2 = new TabComponent"
			"\ttabs: ['Tab 1', 'Tab 2', 'Tab 3']"
			"\tactive: {active}"
			""
			"print t2.current"
			""
			"# » {current}"
		]
		template:
			active: [t2, 'active']
			current: [t2, 'current', (v) -> 
				"<Layer id:#{v.id} name:#{v.name}>"
				]
	
	# Width

	tw = new TabComponent
		width: 300
			
	new ComponentExample
		parent: @content
		title: "Tab Component with set width"
		content: tw
		tabbed: false
		text: [
			"new TabComponent"
			"\ttabs: ['Tab 1', 'Tab 2']"
			"\twidth: 300"
		]
	
	# content
		
	t3 = new TabComponent
		tabs: ["Fruit", "Veggies", "Liquor"]
		height: 220
		width: 300
		showSublayers: true
		
			
	new ComponentExample
		parent: @content
		title: "Tab Component with content"
		content: t3
		tabbed: false
		text: [
			"t3 = new TabComponent"
			"\ttabs: ['Fruit', 'Vegetables', 'Liquor']"
			""
			"new Body"
			"\tparent: t3.tabs[0]"
			"\ttext: 'In botany, a...'"
			""
			"new Body"
			"\tparent: t3.tabs[1]"
			"\ttext: 'In everyday usage...'"
			""
			"new Body"
			"\tparent: t3.tabs[2]"
			"\ttext: 'A distilled beverage...'"
		]
		template:
			active: [t3, 'active']
			current: [t3, 'current', (v) -> 
				"<Layer id:#{v.id} name:#{v.name}>"
				]
	
	Utils.bind t3.tabs[0], ->
		new Body2
			parent: @
			x: 16
			y: 16
			width: t3.width - 32
			text: "In botany, a fruit is the seed-bearing structure in flowering plants (also known as angiosperms) formed from the ovary after flowering. In common language usage, 'fruit' normally means the fleshy seed-associated structures of a plant that are sweet or sour, and edible in the raw state, such as apples."
	
	Utils.bind t3.tabs[1], ->
		new Body2
			parent: @
			x: 16
			y: 16
			width: t3.width - 32
			text: "In everyday usage, vegetables are certain parts of plants that are consumed by humans as food as part of a savory meal. Modern-day culinary usage of the term vegetable can be largely defined through culinary and cultural tradition."
	
	Utils.bind t3.tabs[2], ->
		new Body2
			parent: @
			x: 16
			y: 16
			width: t3.width - 32
			text: "A distilled beverage, spirit, liquor, hard liquor or hard alcohol is an alcoholic beverage produced by distillation of grains, fruit, or vegetables that have already gone through alcoholic fermentation. As distilled beverages contain significantly more alcohol, they are considered 'harder'."
		
		
	Utils.offsetY @content.children
	@updateContent()
	addDocsLink(tabComponentView, 'wiki/TabComponent')


# ----------------
# Miscellaneous

# Tooltips View

tooltipsView = new View
	title: 'Tooltips'
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30
	contentInset:
		bottom: 128

tooltipsView.onLoad ->
	
	@content.backgroundColor = white
	
	new ComponentHeader
		parent: @content
		y: 0
		title: "Tooltip"
		body: "A tooltip shows some helper text about some other element. It may be `position`ed above, below, left or right of that other element."
	
	# tooltips
	
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
		continue unless layer instanceof Tooltip
			
		new ComponentExample
			parent: @content
			title: layer.name
			content: layer
			text: [
				"new Tooltip",
				"position: '#{layer.position}'",
				"text: '#{layer.text}'",
				layer.extra ? ""
				]
			template:
				position: [layer, 'position']
				text: [layer, 'text']
		
	Utils.offsetY(@content.children)
	@updateContent()
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
	key: '0.0.0'
	padding: {top: 16, left: 0, right: 0}
	backgroundColor: linen ? grey30

homeView.onLoad ->
	
	structure =
		"Foundations":
			Theme: undefined
			Color: colorsView 
			Typography: typographyView
			Icon: iconsView
		"Buttons":
			Button: buttonsView
			Link: linksView
		"Inputs":
			TextInput: textInputsView
			Select: selectsView
			Checkbox: checkboxView
			Radiobox: radioboxView
			Stepper: steppersView
			Segment: segmentsView
			Toggle: togglesView
		"Components":
			DocComponent: undefined
			CarouselComponent: undefined
			SortableComponent: sortableComponentView
			StickyComponent: undefined
			TabComponent: tabComponentView
		"Structure":
			App: undefined
			View: undefined 
			Header: undefined
		"Misc":
			Tooltip: tooltipsView
			Utils: utilsView
			Alert: undefined
	
	links = _.map structure, (value, key) =>
		
		new HomeViewContainer
			parent: @content
			title: key
			links: value
			
	Utils.stack(@content.children, 32)

homeView.onPostload ->
	@updateContent()
	addDocsLink(@, '', 'github-circle')


app.showNext(homeView)

# app.getScreenshot()

# ----------------
# Testing

# app.views.forEach (view, i) ->
# 	Utils.delay i, ->
# 		app.showNext view
