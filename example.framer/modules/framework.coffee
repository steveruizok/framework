require 'moreutils'

require 'components/Colors'
require 'components/Theme'
require 'components/Typography'

{ Button } = require 'components/Button'
{ Carousel } = require 'components/Carousel'
{ Radiobox } = require 'components/Radiobox'
{ Checkbox } = require 'components/Checkbox'
{ Footer } = require 'components/Footer'
{ Header } = require 'components/Header'
{ Segment } = require 'components/Segment'
{ Toggle } = require 'components/Toggle'
{ Icon } = require 'components/Icon'
{ Link } = require 'components/Link'
{ PageTransitionComponent } = require 'components/PageTransitionComponent'
{ Separator } = require 'components/Separator'
{ Stepper } = require 'components/Stepper'
{ Sortable } = require 'components/Sortable'
{ TextInput } = require 'components/TextInput'
{ TransitionPage } = require 'components/PageTransitionComponent'
{ View } = require 'components/View'


class window.App extends FlowComponent
	constructor: (options = {}) ->

		_.defaults options,
			backgroundColor: white
			title: 'www.framework.com'
			chrome: 'ios'

		if not options.safari
			options.title = ''

		# Add general components to window
		for componentName in [
			'Button', 
			'Carousel', 
			'Header', 
			'Radiobox',
			'Checkbox',
			'Toggle',
			'Icon', 
			'Stepper', 
			'Segment',
			'TextInput',
			'Link', 
			'PageTransitionComponent'
			'Separator', 
			'Sortable'
			'TransitionPage', 
			'View', 
		]
			c = eval(componentName)
			do (componentName, c) =>
				window[componentName] = (options = {}) =>
					_.assign(options, {app: @})
					return new c(options)

		super options

		@chrome = options.chrome

		@views = []

		if @chrome
			@header = new Header
				app: @
				safari: @chrome is 'safari'
				title: options.title
		
		if @chrome is 'safari'
			@footer = new Footer 
				app: @

		# when transition starts, change the header's title
		@onTransitionStart @_updateNext
		
		# when transition ends, reset the previous view
		@onTransitionEnd @_resetPrevious

		Screen.on Events.EdgeSwipeLeftEnd, @showPrevious
	

	# Update the next View while transitioning
	_updateNext: (prev, next) =>
		return if not next
		
		try next.load(@, next, prev)
			
		hasPrevious = prev? and next isnt @_stack[0]?.layer

		return if not @header

		if @header.safari
			@footer.hasPrevious = hasPrevious
			return

		@header.backIcon.visible = hasPrevious
		@header.backText.visible = hasPrevious
		if next.title 
			@header.updateTitle(next.title)
		return
	
	# Reset the previous View while transitioning
	_resetPrevious: (prev, next) =>
		if prev?.reset?
			prev.reset()