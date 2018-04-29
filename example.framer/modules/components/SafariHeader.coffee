###

Safari Header

A Safari browser frome for iOS devices.

@extends {HeaderBase}
###

Theme = require "components/Theme"
theme = undefined

class exports.SafariHeader extends HeaderBase
	constructor: (options = {}) ->
		theme = Theme.theme

		_.defaults options,
			name: "Safari Header"
			color: black
			backgroundColor: white
			
			title: "Safari Header"
			tint: blue
			hidden: false
			collapsed: false
			collapsedHeight: 40

		super options

		# LAYERS

		@statusBar = new iOSStatusBar
			parent: @
			color: @color


		@addressContainer = new Layer
			name: 'Address'
			parent: @
			width: @width - 20
			height: 29
			x: Align.center()
			y: Align.center(10)
			borderRadius: 8
			backgroundColor: 'rgba(0,0,0,.09)'
			clip: true
			animationOptions: @animationOptions

		@refreshIcon = new Icon
			name: 'Menu Icon'
			parent: @addressContainer
			y: Align.center(1)
			x: Align.right(-6)
			icon: 'refresh'
			rotation: -45
			color: '#333'
			height: 18
			width: 18
			animationOptions: @animationOptions

		@refreshIcon.onTap -> window.location.reload()

		@addressLoadingLayer = new Layer
			name: '.'
			parent: @addressContainer
			x: 0
			y: Align.bottom()
			height: 2
			width: 1
			backgroundColor: "#007AFF"
			visible: false
	
		@titleLayer = new TextLayer
			name: 'Title'
			parent: @addressContainer
			y: Align.center()
			width: @addressContainer.width
			textAlign: 'center'
			text: '{title}'
			fontFamily: "Helvetica Neue"
			fontSize: 15
			fontWeight: 400
			color: '#000'
			animationOptions: @animationOptions


		# DEFINITIONS	


		# EVENTS

		@statusBar.onTap @expand

		@on "change:title",		@_setTitle
		@on "change:viewKey",	@_setViewKey
		@on "change:tint",		@_setTint
		@on "change:color",		@_setColor
		@on "change:hidden",	@_showHidden
		@on "change:collapsed",	@_showCollapsed
		@on "change:loading",	@_showLoading


		# KICKOFF

		delete @_initial

		@title = @app.title


	# PRIVATE METHODS

	_setTitle: (string) =>
		@titleLayer.template = string


	_setViewKey: (string) =>
		@statusBar.viewKey = string


	_setColor: (string) =>


	_setTint: (color) =>


	_showLoading: (bool) =>
		if bool
			_.assign @addressLoadingLayer,
				width: 1
				visible: true

			@addressLoadingLayer.animate
				width: @addressContainer.width
				options:
					time: 1.7
					curve: "linear"
			return

		# loading is false
		_.assign @addressLoadingLayer,
			width: 1
			visible: false


	_showHidden: (bool) =>


	_showCollapsed: (bool) =>
		if bool
			@addressContainer.animate
				midY: @statusBar.height + (@collapsedHeight - @statusBar.height) / 2
				backgroundColor: 'rgba(0,0,0,0)'

			@refreshIcon.animate
				opacity: 0

			@titleLayer.animate
				scale: .75
			
			return


		@addressContainer.animate
			midY: @statusBar.height + (@fullHeight - @statusBar.height) / 2
			backgroundColor: 'rgba(0,0,0,.09)'

		@refreshIcon.animate
			opacity: 1

		@titleLayer.animate
			scale: 1


	# PUBLIC METHODS

	update: (prev, next, options) =>
		@viewKey = next?.viewKey if @app.showKeys
			
		hasPrevious = @app._stack.length > 1
		showPrevLinks = !next?.root and hasPrevious