# Transitions
# Thanks to @myvo

exports.safari = (app) ->
	return (nav, layerA, layerB, overlay) =>
		options = {time: 0.01}
		transition =
			layerA:
				show: {options: options, x: Align.center(), brightness: 100, y: app.windowFrame.expandY}
				hide: {options: options, x: Align.center(), brightness: 101, y: app.windowFrame.expandY}
			layerB:
				show: {options: options, x: Align.center(), brightness: 100, y: app.windowFrame.expandY}
				hide: {options: options, x: Align.center(), brightness: 101, y: app.windowFrame.expandY}

exports.ios = (app) ->
	return (nav, layerA, layerB, overlay) =>
		options = {curve: "spring(300, 35, 0)"}
		transition =
			layerA:
				show: {options: options, x: Align.center(), y: app.windowFrame.expandY}
				hide: {options: options, x: 0 - layerA?.width / 2, y: app.windowFrame.expandY}
			layerB:
				show: {options: options, x: Align.center(), y: app.windowFrame.expandY}
				hide: {options: options, x: app.width + layerB.width / 2, y: app.windowFrame.expandY}

exports.default = (app) ->
	return (nav, layerA, layerB, overlay) =>
		options = {curve: "spring(300, 35, 0)"}
		transition =
			layerA:
				show: {options: options, x: Align.center(), y: app.windowFrame.expandY}
				hide: {options: options, x: 0 - layerA?.width / 2, y: app.windowFrame.expandY}
			layerB:
				show: {options: options, x: Align.center(), y: app.windowFrame.expandY}
				hide: {options: options, x: app.width + layerB.width / 2, y: app.windowFrame.expandY}


exports.switchInstant = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:0
				y:0

		layerB:
			show:
				x:0
				y:0

			hide:
				x:0
				y:0
					
exports.slideInUp = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:0
				y:0

		layerB:
			show:
				x:0
				y:0

			hide:
				x:0
				y:Screen.height
				
exports.slideInDown = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:0
				y:0

		layerB:
			show:
				x:0
				y:0

			hide:
				x:0
				y:-Screen.height
				
exports.slideInLeft = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:0
				y:0

		layerB:
			show:
				x:0
				y:0

			hide:
				x:-Screen.width
				y:0
				
exports.slideInRight = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:0
				y:0

		layerB:
			show:
				x:0
				y:0

			hide:
				x:Screen.width
				y:0
				
				

exports.slideOutDown = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:0
				y:Screen.height

		layerB:
			show:
				x:0
				y:0
				height: Screen.height

			hide:
				x:0
				y:0
				height:0
				
exports.slideOutRight = (nav, layerA, layerB, overlay) ->
		transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:Screen.width
				y:0

		layerB:
			show:
				x:0
				y:0
				width:Screen.width

			hide:
				x:0
				y:0
				width:0
				
exports.moveInUp = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:0
				y:-Screen.height

		layerB:
			show:
				x:0
				y:0

			hide:
				x:0
				y:Screen.height
				
exports.moveInDown = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:0
				y:Screen.height

		layerB:
			show:
				x:0
				y:0

			hide:
				x:0
				y:-Screen.height
				
exports.moveInLeft = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:Screen.width
				y:0

		layerB:
			show:
				x:0
				y:0

			hide:
				x:-Screen.width
				y:0
				
exports.moveInRight = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:-Screen.width
				y:0

		layerB:
			show:
				x:0
				y:0

			hide:
				x:Screen.width
				y:0

exports.pushInLeft = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0
				
			hide:
				x:Screen.width / 2
				y:0
				

		layerB:
			show:
				x:0
				y:0
				shadowX: 0
				shadowColor: 'rgba(0,0,0,0.6)'
				
			hide:
				x:-Screen.width
				y:0
				shadowX: Screen.width
				shadowColor: 'rgba(0,0,0,0)'
				
				
exports.pushInRight = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:-Screen.width / 2
				y:0

		layerB:
			show:
				x:0
				y:0
				shadowX: 0
				shadowColor: 'rgba(0,0,0,0.6)'

			hide:
				x:Screen.width
				y:0
				shadowX: -Screen.width
				shadowColor: 'rgba(0,0,0,0)'
				
				
exports.pushOutRight = (nav, layerA, layerB, overlay) ->
	transition =
		layerA:
			show:
				x:0
				y:0

			hide:
				x:Screen.width
				y:0

		layerB:
			show:
				x:0
				y:0
				width:Screen.width
				shadowX: Screen.width
				shadowColor: 'rgba(0,0,0,0)'
				shadowType: 'inner'

			hide:
				x:-Screen.width / 2
				y:0
				width:Screen.width/2
				shadowX: Screen.width
				shadowColor: 'rgba(0,0,0,0.6)'
				shadowType: 'inner'
				
exports.fadeIn = (nav, layerA, layerB, overlay) ->
	transition =
		layerB:
			show:
				x:0
				y:0
				opacity: 1

			hide:
				x:0
				y:0
				opacity: 0
				
exports.zoomIn = (nav, layerA, layerB, overlay) ->
	transition =
		layerB:
			show:
				x:0
				y:0
				scale: 1
				opacity: 1

			hide:
				x:0
				y:0
				scale: .9
				opacity: 0
				
exports.zoomOut = (nav, layerA, layerB, overlay) ->
	transition =
		layerB:
			show:
				x:0
				y:0
				scale: 1
				opacity: 1

			hide:
				x:0
				y:0