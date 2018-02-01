require 'moreutils'

require 'components/Colors'
require 'components/Typography'

{ Button } = require 'components/Button'
{ Carousel } = require 'components/Carousel'
{ Radiobox } = require 'components/Radiobox'
{ Checkbox } = require 'components/Checkbox'
{ Footer } = require 'components/Footer'
{ Header } = require 'components/Header'
{ Toggle } = require 'components/Toggle'
{ Icon } = require 'components/Icon'
{ Link } = require 'components/Link'
{ PageTransitionComponent } = require 'components/PageTransitionComponent'
{ Separator } = require 'components/Separator'
{ Sortable } = require 'components/Sortable'
{ TextInput } = require 'components/TextInput'
{ TransitionPage } = require 'components/PageTransitionComponent'
{ View } = require 'components/View'


class window.App extends FlowComponent
	constructor: (options = {}) ->

		_.defaults options,
			backgroundColor: '#FFF'
			title: 'www.framework.com'
			safari: true

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

		@views = []
		@header = new Header
			app: @
			safari: options.safari
			title: options.title
		
		if options.safari
			@footer = new Footer 
				app: @

		# when transition starts, change the header's title
		@onTransitionStart @updateNext
		
		# when transition ends, reset the previous view
		@onTransitionEnd @resetPrevious

		Screen.on Events.EdgeSwipeLeftEnd, @showPrevious
	

	# Update the next View while transitioning
	updateNext: (prev, next) =>
		return if not next
		
		try next.load(@, next, prev)
			
		hasPrevious = prev? and next isnt @_stack[0]?.layer

		if not @header.safari
			@header.backIcon.visible = hasPrevious
			@header.backText.visible = hasPrevious
			if next.title 
				@header.updateTitle(next.title)
			return

		@footer.hasPrevious = hasPrevious
	
	# Reset the previous View while transitioning
	resetPrevious: (prev, next) =>
		if prev?.reset?
			prev.reset()