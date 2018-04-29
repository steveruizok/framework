###

iOS Header

A header for iOS devices.

@extends {HeaderBase}
###

Theme = require "components/Theme"
theme = undefined

class exports.iOSHeader extends HeaderBase
	constructor: (options = {}) ->
		theme = Theme.theme

		_.defaults options,
			name: "iOS Header"
			color: black
			backgroundColor: white
			
			title: "iOS Header"
			tint: blue
			hidden: false
			collapsed: false
			collapsedHeight: 20

		super options

		# LAYERS

		@statusBar = new iOSStatusBar
			parent: @
			color: @color


		@leftHitArea = new Layer
			name: 'Left Hit Area'
			parent: @
			height: @height - @statusBar.height
			width: @width / 3
			x: 0
			y: @statusBar.height
			backgroundColor: null
			visible: false
			animationOptions: @animationOptions


		@backText = new TextLayer
			name: 'Back Text'
			parent: @leftHitArea
			y: Align.center()
			x: 8
			width: 100
			fontSize: 16
			fontFamily: "Helvetica"
			color: @tint
			text: 'Back'
			animationOptions: @animationOptions

		@backText.textIndent = 24


		@backIcon = new Icon
			name: 'Back Icon'
			parent: @backText
			y: Align.center(1)
			icon: 'ios-back'
			color: @tint
			animationOptions: @animationOptions


		@titleLayer = new TextLayer
			name: 'Title'
			parent: @
			width: @width * .618
			x: Align.center()
			y: Align.center(@statusBar.height/2)
			fontSize: 16
			fontFamily: "Helvetica"
			color: @color
			textAlign: 'center'
			padding: {left: 32, right: 32, top: 8, bottom: 8}
			text: '{title}'
			animationOptions: @animationOptions


		Utils.bind @loadingLayer, ->
			
			@loadingContainer = new Layer
				name: '.'
				parent: @
				x: Align.center()
				y: Align.center()
				size: 48
				backgroundColor: 'rgba(0,0,0,.64)'
				borderRadius: 8
				opacity: .8
				backgroundBlur: 30

			@iconLayer = new Icon 
				parent: @loadingContainer
				height: 32
				width: 32
				point: Align.center()
				style:
					lineHeight: 1
				color: white
				icon: "loading"

		@loadingAnim = new Animation @loadingLayer.iconLayer,
			rotation: 360
			options:
				curve: "linear"
				looping: true

		# DEFINITIONS	


		# EVENTS

		@statusBar.onTap @expand
		
		@leftHitArea.onTouchEnd =>
			return if not @backIcon.visible
			@app.showPrevious()

		@on "change:title",		@_setTitle
		@on "change:viewKey",	@_setViewKey
		@on "change:hidden",	@_showHidden
		@on "change:collapsed",	@_showCollapsed
		@on "change:tint",		@_setTint
		@on "change:color",		@_setColor

		# KICKOFF

		delete @_initial

		@title = ''


	# PRIVATE METHODS

	_setTitle: (string) =>
		@titleLayer.template = string


	_setViewKey: (string) =>
		@statusBar.viewKey = string


	_setColor: (string) =>
		@titleLayer.color = string


	_setTint: (color) =>
		@backText.color = color
		@backIcon.color = color


	_showHidden: (bool) =>
		@titleLayer.animateStop()
		@backText.animateStop()

		props = if bool then { opacity: 0, options: { time: .2 } }
		else 				 { opacity: 1, options: { time: .3 } }

		Utils.setOrAnimateProps @titleLayer, @_initial, props
		Utils.setOrAnimateProps @backText, 	 @_initial, props


	_showCollapsed: (bool) =>
		props = if bool
			midY: @fullHeight - 40
			opacity: 0
			scale: .9
		else
			midY: @fullHeight - 24
			opacity: 1
			scale: 1

		for child in _.without(@children, @statusBar)
			Utils.setOrAnimateProps child, @_initial, props


	# PUBLIC METHODS

	update: (prev, next, options) =>
		@title = next?.title ? ""
		@viewKey = next?.viewKey if @app.showKeys

		hasPrevious = @app._stack.length > 1
		showPrevLinks = !next?.root and hasPrevious
		@leftHitArea.visible = showPrevLinks
