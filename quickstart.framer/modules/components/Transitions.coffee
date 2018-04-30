###

Transitions
(thanks to @myvo)

A collection of common transitions.

To use for a single transition:
	app = new App
	app.showNext(myView, null, {transition: Transitions.pushInRight})

To set an App instance's default for all transitions:
	app = new App
	app.defaultTransition = Transitions.slideInUp 

###


exports.switchInstant = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0

			hide:
				x:0

		layerB:
			show:
				x:0

			hide:
				x:0
					
exports.slideInUp = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0

			hide:
				x:0

		layerB:
			show:
				x:0

			hide:
				x:0
				y:Screen.height
				
exports.slideInDown = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0

			hide:
				x:0

		layerB:
			show:
				x:0

			hide:
				x:0
				y:-Screen.height
				
exports.slideInLeft = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0

			hide:
				x:0

		layerB:
			show:
				x:0

			hide:
				x:-Screen.width
				
exports.slideInRight = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0

			hide:
				x:0

		layerB:
			show:
				x:0

			hide:
				x:Screen.width
				
				

exports.slideOutDown = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0

			hide:
				x:0
				y:Screen.height

		layerB:
			show:
				x:0
				height: Screen.height

			hide:
				x:0
				height:0
				
exports.slideOutRight = (nav, layerA, layerB, overlay) ->
		transition =
		layerA:
			show:
				x:0

			hide:
				x:Screen.width

		layerB:
			show:
				x:0
				width:Screen.width

			hide:
				x:0
				width:0
				
exports.moveInUp = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0

			hide:
				x:0
				y:-Screen.height

		layerB:
			show:
				x:0

			hide:
				x:0
				y:Screen.height
				
exports.moveInDown = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0

			hide:
				x:0
				y:Screen.height

		layerB:
			show:
				x:0

			hide:
				x:0
				y:-Screen.height
				
exports.moveInLeft = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0

			hide:
				x:Screen.width

		layerB:
			show:
				x:0
			hide:
				x:-Screen.width
				
exports.moveInRight = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0

			hide:
				x:-Screen.width

		layerB:
			show:
				x:0

			hide:
				x:Screen.width

exports.pushInLeft = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				
			hide:
				x:Screen.width / 2

		layerB:
			show:
				x:0
				shadowX: 0
				shadowColor: 'rgba(0,0,0,0.6)'
				
			hide:
				x:-Screen.width
				shadowX: Screen.width
				shadowColor: 'rgba(0,0,0,0)'
				
				
exports.pushInRight = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0

			hide:
				x:-Screen.width / 2

		layerB:
			show:
				x:0
				shadowX: 0
				shadowColor: 'rgba(0,0,0,0.6)'

			hide:
				x:Screen.width
				shadowX: -Screen.width
				shadowColor: 'rgba(0,0,0,0)'
				
				
exports.pushOutRight = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0

			hide:
				x:Screen.width

		layerB:
			show:
				x:0
				width:Screen.width
				shadowX: Screen.width
				shadowColor: 'rgba(0,0,0,0)'
				shadowType: 'inner'

			hide:
				x:-Screen.width / 2
				width:Screen.width/2
				shadowX: Screen.width
				shadowColor: 'rgba(0,0,0,0.6)'
				shadowType: 'inner'
				
exports.fadeIn = (nav, layerA, layerB, overlay) ->
	transition =
		layerB:
			show:
				x:0
				opacity: 1

			hide:
				x:0
				opacity: 0
				
exports.zoomIn = (nav, layerA, layerB, overlay) ->
	transition =
		layerB:
			show:
				x:0
				scale: 1
				opacity: 1

			hide:
				x:0
				scale: .9
				opacity: 0
				
exports.zoomOut = (nav, layerA, layerB, overlay) ->
	transition =
		layerB:
			show:
				x:0
				scale: 1
				opacity: 1

			hide:
				x:0