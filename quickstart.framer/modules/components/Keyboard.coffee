###

Keyboard

A module to capture keyboard events.

# Methods

Keyboard.on(key <string>, handler <function>[, throttleTime <number>])	
	Adds a handler to the given key, optionally throttled.

Keyboard.off(key <string>, handler <function>[, throttleTime <number>])	
	Removes a handler to the given keypress.

Keyboard.printKey(event <event>)	
	When used as a callback, prints the key pressed.
	e.g. window.addEventListener 'keydown', Keyboard.printKey

Keyboard.preventDefault <bool>	
	When set to true, will prevent key pressed from triggering their default action.

###

keyHandlers = {}
enabled = false

enable = ->
	window.addEventListener 'keydown', (event) ->
		event.preventDefault() if exports.preventDefault 
		try keyHandlers[event.key]()

	enabled = true

_.assign exports,
	on: (key, handler, throttleTime) ->
		enable() unless enabled
		keyHandlers[key] = Utils.throttle throttleTime, handler

	off: (key, handler, throttleTime) ->
		enable() unless enabled
		delete keyHandlers[key]

	printKey: (event) -> print event.key

	preventDefault: true