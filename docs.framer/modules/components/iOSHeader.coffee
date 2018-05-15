###

iOS Header

A header for iOS devices.

@extends {HeaderBase}


iOSHeader.update()	
	Updates the header's title, viewKey, and Back link.

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
				backgroundColor: 'rgba(0,0,0,.44)'
				borderRadius: 8
				opacity: .8
				backgroundBlur: 30

			@iconLayer = new SVGLayer 
				parent: @loadingContainer
				height: 24
				width: 24
				point: Align.center()
				svg: loadingSVG
				color: white

		@loadingAnim = new Animation @loadingLayer.iconLayer,
			rotation: 360
			options:
				curve: "linear"
				looping: true
				time: 1

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


		# CLEANUP

		child.name = '.' for child in @children unless options.showSublayers


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
		@statusBar.color = string


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


loadingSVG = """<svg viewBox="0 0 100 100"><path d="M49.7168708,0 C51.5578199,-3.38176876e-16 53.0502041,1.49238417 53.0502041,3.33333333 L53.0502041,21.6666667 C53.0502041,23.5076158 51.5578199,25 49.7168708,25 C47.8759216,25 46.3835374,23.5076158 46.3835374,21.6666667 L46.3835374,3.33333333 C46.3835374,1.49238417 47.8759216,3.38176876e-16 49.7168708,0 Z M79.1061334,9.54915028 C80.5954925,10.6312331 80.9256553,12.7157986 79.8435725,14.2051578 L69.0675096,29.037136 C67.9854268,30.5264952 65.9008612,30.8566579 64.4115021,29.7745751 C62.9221429,28.6924924 62.5919802,26.6079268 63.6740629,25.1185677 L74.4501259,10.2865894 C75.5322087,8.79723026 77.6167742,8.46706751 79.1061334,9.54915028 Z M97.2696966,34.5491503 C97.8385812,36.299997 96.8804115,38.1805107 95.1295648,38.7493953 L77.6935287,44.4147069 C75.942682,44.9835915 74.0621682,44.0254218 73.4932837,42.2745751 C72.9243991,40.5237284 73.8825687,38.6432147 75.6334154,38.0743301 L93.0694515,32.4090185 C94.8202982,31.840134 96.700812,32.7983036 97.2696966,34.5491503 Z M97.2696966,65.4508497 C96.700812,67.2016964 94.8202982,68.159866 93.0694515,67.5909815 L75.6334154,61.9256699 C73.8825687,61.3567853 72.9243991,59.4762716 73.4932837,57.7254249 C74.0621682,55.9745782 75.942682,55.0164085 77.6935287,55.5852931 L95.1295648,61.2506047 C96.8804115,61.8194893 97.8385812,63.700003 97.2696966,65.4508497 Z M79.1061334,90.4508497 C77.6167742,91.5329325 75.5322087,91.2027697 74.4501259,89.7134106 L63.6740629,74.8814323 C62.5919802,73.3920732 62.9221429,71.3075076 64.4115021,70.2254249 C65.9008612,69.1433421 67.9854268,69.4735048 69.0675096,70.962864 L79.8435725,85.7948422 C80.9256553,87.2842014 80.5954925,89.3687669 79.1061334,90.4508497 Z M49.7168708,100 C47.8759216,100 46.3835374,98.5076158 46.3835374,96.6666667 L46.3835374,78.3333333 C46.3835374,76.4923842 47.8759216,75 49.7168708,75 C51.5578199,75 53.0502041,76.4923842 53.0502041,78.3333333 L53.0502041,96.6666667 C53.0502041,98.5076158 51.5578199,100 49.7168708,100 Z M20.3276081,90.4508497 C18.838249,89.3687669 18.5080862,87.2842014 19.590169,85.7948422 L30.366232,70.962864 C31.4483147,69.4735048 33.5328803,69.1433421 35.0222395,70.2254249 C36.5115986,71.3075076 36.8417614,73.3920732 35.7596786,74.8814323 L24.9836156,89.7134106 C23.9015329,91.2027697 21.8169673,91.5329325 20.3276081,90.4508497 Z M2.16404494,65.4508497 C1.59516037,63.700003 2.55332998,61.8194893 4.30417668,61.2506047 L21.7402128,55.5852931 C23.4910595,55.0164085 25.3715733,55.9745782 25.9404579,57.7254249 C26.5093424,59.4762716 25.5511728,61.3567853 23.8003261,61.9256699 L6.36428998,67.5909815 C4.61344328,68.159866 2.73292952,67.2016964 2.16404494,65.4508497 Z M2.16404494,34.5491503 C2.73292952,32.7983036 4.61344328,31.840134 6.36428998,32.4090185 L23.8003261,38.0743301 C25.5511728,38.6432147 26.5093424,40.5237284 25.9404579,42.2745751 C25.3715733,44.0254218 23.4910595,44.9835915 21.7402128,44.4147069 L4.30417668,38.7493953 C2.55332998,38.1805107 1.59516037,36.299997 2.16404494,34.5491503 Z M20.3276081,9.54915028 C21.8169673,8.46706751 23.9015329,8.79723026 24.9836156,10.2865894 L35.7596786,25.1185677 C36.8417614,26.6079268 36.5115986,28.6924924 35.0222395,29.7745751 C33.5328803,30.8566579 31.4483147,30.5264952 30.366232,29.037136 L19.590169,14.2051578 C18.5080862,12.7157986 18.838249,10.6312331 20.3276081,9.54915028 Z" id="Rectangle" fill="#D8D8D8">
<animateTransform attributeName="transform"
	attributeType="XML"
	type="rotate"
	from="0 50 50"
	to="360 50 50"
	dur="5s"
	repeatCount="indefinite"/>
</path>

</svg>"""