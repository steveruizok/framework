require 'moreutils'

require 'components/Colors'
require 'components/Typography'

{ Header } = require 'components/Header'
{ Footer } = require 'components/Footer'
{ Link } = require 'components/Link'
{ Icon } = require 'components/Icon'
{ View } = require 'components/View'
{ Button } = require 'components/Button'
{ Carousel } = require 'components/Carousel'
{ Separator } = require 'components/Separator'
{ TransitionPage } = require 'components/PageTransitionComponent'
{ PageTransitionComponent } = require 'components/PageTransitionComponent'


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
			'Header', 
			'Link', 
			'Icon', 
			'View', 
			'Button', 
			'Separator', 
			'Carousel', 
			'TransitionPage', 
			'PageTransitionComponent'
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
		if next?.onLoad?
			next.onLoad()
			
		hasPrevious = prev? and next isnt @_stack[0]?.layer

		if not @header.safari
			@header.backIcon.visible = hasPrevious
			@header.backText.visible = hasPrevious
			if next?.title 
				@header.updateTitle(next?.title)
			return

		@footer.hasPrevious = hasPrevious
	
	# Reset the previous View while transitioning
	resetPrevious: (prev, next) =>
		if prev?.reset?
			prev.reset()