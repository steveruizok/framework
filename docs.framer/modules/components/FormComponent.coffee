###

FormComponent

Creates forms out of other components.

@extends {Layer}	
@param 	{Object}		options 				The component's attributes.
@param 	{boolean}		options.warn			Whether to show a warning state for incomplete required fields.
@param 	{boolean}		options.indicators		Whether to show indicators for each required field.
@param 	{Object}		options.target 			An object to use for this form's initial values, and to post changes to.
@param 	{number}		options.delay 			How long to wait after last input before making validation checks.
@param 	{Object}		options.padding 		The padding to use between the form's rows.
	
	padding:
		top: <number>					The space to leave at the top of the form.  
		bottom: <number>				The space to leave at the bottom of the form.
		stack:
			x: <number>					The horizontal space to leave between components on the same row.  
			y: <number>					The vertical space to leave between rows.    


@param 	{array}			options.structure 		The structure of the form's inputs, arranged in an array of rows.
	
	structure: [
		{
			<string>:					The input's name.
				label: <string>			The input's label.
				field: <Component>		The component to use for this input, e.g. TextInput.
				text: <string>			Text to display (instead of a field).
				width: <number>			The width of the input, as a percentage of the form's width (0 to 100).
				validation: <function>	A function that will return true or false, based on the value of the field.
				required: <boolean>		Whether this input is required.
				microText: <string>		Text to display beneath the input when empty. (e.g. "Please enter a valid email address.")
				errorText: <string>		Text to display when the input's value does not pass its validation. (e.g. "The email you've entered is not valid.")
				placeholder: <string>	The placeholder to use for this input's value, when empty.
				options: <array>		An array of options for the input, as strings.
		}
	]


FormComponent.complete
	Returns whether the form is complete or not. 
	Emits a "change:complete" event when any field's value changes.

FormComponent.status
	Returns either "complete" or "incomplete".
	Emits a "change:status" event when any field's value changes.


FormComponent.refresh()	
	Rebuilds all layers.
	Emits a "refresh" event.

FormComponent.post()	
	Updates the target data object with its current values.
	Emits a "post" event.

FormComponent.reset()
	Clears all values from the form's inputs.
	Emits a "reset" event.

###

class exports.FormComponent extends Layer
	constructor: (options = {}) ->
		@__constructor = true
		
		_.defaults options,
			name: "Form Component"
			color: black
			backgroundColor: null
			x: 0
			height: 32
			width: Screen.width

			padding: {stack: {x: 16, y: 16}, top: 0, bottom: 0}
			target: {}
			structure: exampleStructure
			warn: false
			indicators: true
			delay: .2
		
		super options
		
		_.assign @,
			indicators: options.indicators
			padding: options.padding
			target: options.target
			delay: options.delay
			results: {}
			layers: []
			
		_.defaults @padding,
			bottom: 0
			top: 0
			stack: {}

		_.defaults @padding.stack,
			x: 16
			y: 16

		# EVENTS

		@on "change:size", =>
			return if @__building
			@_createLayers()
		
		# KICKOFF
		
		delete @__constructor
		
		_.assign @,
			warn: options.warn
			structure: options.structure


	# PRIVATE METHODS

	_createLayers: =>
		@__building = true

		layer.destroy() for layer in @children
		@layers = []

		startY = @padding.top

		_.forIn @structure, (row) =>
		
			startX = -@padding.stack.x
			rowStackWidth = 0
			
			_.forIn row, (input, key) =>
				
				_.defaults input,
					field: TextInput
					password: false
					placeholder: ""
					width: 100
					y: 0
					x: undefined
					label: undefined
					required: undefined
					microText: undefined
					errorText: undefined
				
				label = undefined
				indicator = undefined
				layer = undefined
				micro = undefined

				# width
				inputWidth = _.clamp(
					rowStackWidth + (@width * (input.width / 100)),
					1,
					@width - rowStackWidth
					)

				rowStackWidth = inputWidth + @padding.stack.x

				# Label
				if input.label?
					label = new Label
						parent: @
						y: startY
						x: startX + @padding.stack.x
						text: input.label
					
					# Indicator
					if input.required and @indicators
						label.padding = {left: 24}
						indicator = new FormIndicator
							parent: label

				# Text-only
				if input.text?
					layer = new Body2
						parent: @
						y: label?.maxY ? (startY + input.y)
						x: input.x ? (startX + @padding.stack.x)
						text: input.text
						width: inputWidth
					
					startX = layer.maxX
					if key is _.last(_.keys(row))
						startY = @padding.stack.y + (if micro? then micro else layer).maxY
					
					return
					
				# Input
				layer = new input['field']
					parent: @
					x: input.x ? (startX + @padding.stack.x)
					y: label?.maxY ? (startY + input.y)
					placeholder: input.placeholder
					options: input.options
					width: inputWidth
					value: null
					password: input.password

				if input.label is "" then label?.x = layer.x + layer.width - 16
					
				# Microtext
				if input.microText? or input.errorText?
					micro = new Micro
						parent: @
						y: layer.maxY
						x: layer.x
						text: ""
						width: layer.width
				
				# set form data
				layer._formData =
					required: input.required
					referenceValue: key
					micro: micro
					indicator: indicator
					valid: undefined
					microText: input.microText
					errorText: input.errorText
				
				switch input['field']
					when Toggle 
						_.assign layer._formData,
							value: 'toggled'
							validation: input.validation ? (v) -> v?
					when TextInput 
						_.assign layer._formData,
							value: 'value'
							validation: input.validation ? (v) -> v? and v isnt ""
					when Select	 
						_.assign layer._formData,
							value: 'value'
							validation: input.validation ? (v) -> v? and v isnt ""
					when Checkbox	 
						_.assign layer._formData,
							value: 'checked'
							validation: input.validation ? (v) -> true
					else
						_.assign layer._formData,
							value: 'value'
							validation: input.validation ? (v) -> true
				
				# set listeners
				layer.on "change:#{layer._formData.value}", (v, layer) =>
					@emit 'change:fields', @fields, @
					Utils.delay @delay, =>
						if v is layer[layer._formData.value]
							@_updateStatus()
				
				# update positions
				startX = layer.maxX
				if key is _.last(_.keys(row))
					startY = @padding.stack.y + (if micro? then micro else layer).maxY
				
				# add to layers
				@layers.push(layer)
		
		Utils.contain(@, true, 0, @padding.bottom)
		delete @__building

		@_updateLayers()
	

	_updateTarget: =>
		@layers.forEach (layer) =>
			_.set(
				@target, 
				layer._formData.referenceValue, 
				layer[layer._formData.value] ? null
				)
	
	
	_updateLayers: =>
		@layers.forEach (layer) =>
			targetValue = @target[layer._formData.referenceValue] ? null
			layer[layer._formData.value] = targetValue
	
	
	_updateStatus: =>
		@layers.forEach (layer) =>

			value = layer[layer._formData.value]
			valid = layer._formData.validation(value)

			empty = _.isUndefined(value) or value is ""
			
			layer._formData.valid = valid 
			layer._formData.indicator?.status = if valid then 'valid' else if @warn then 'warn' 
			
			layer._formData.micro?.text = if valid then "" else if empty then (layer._formData.microText ? "") else layer._formData.errorText
			layer._formData.micro?.color = if !valid and !empty and @warn then red else new Color(@color).alpha(.8)
		
		required = _.filter(@layers, (l) -> l._formData.required)
		matches = _.map(required, (l) -> l._formData.valid)
		
		@_complete = _.filter(matches).length is required.length
		
		@emit "change:complete", @complete, @fields, @
		@emit "change:status", @status, @fields, @
	
	
	# PUBLIC METHODS
	
	refresh: =>
		@_createLayers()
		@_updateLayers()
		@_updateStatus()
		@emit "refresh", @
	
	post: =>
		@_updateTarget()
		@emit "post", @target, @
		return @target

	reset: =>
		@layers.forEach (layer) =>
			layer[layer._formData.value] = null
		@emit "reset", @

	
	# DEFINITIONS
	
	@define "fields",
		get: ->
			obj = {}
			@layers.forEach (layer) -> obj[layer._formData.referenceValue] = layer[layer._formData.value]
			return obj
			
	
	@define "warn",
		get: -> return @_warn
		set: (bool) ->
			throw 'FormComponent.warn must be an boolean (true or false).' unless _.isBoolean(bool) 
			@_warn = bool
			return if @__constructor
			@_updateStatus()
	
	
	@define "complete",
		get: -> return @_complete
	
	
	@define "status",
		get: -> if @_complete then 'complete' else 'incomplete'
	
	
	@define "structure",
		get: -> return @_structure
		set: (obj) ->
			throw 'FormComponent.data must be an object.' unless _.isObject(obj) 
			return if @__constructor
			@_structure = obj
			@refresh()


# Form Indicator
class FormIndicator extends Icon
	constructor: (options = {}) ->

		parent = options.parent

		_.defaults options,
			name: "Indicator"
			y: Align.center()
			height: 16
			width: 16
			icon: 'checkbox-blank-circle-outline'
	
			status: undefined
	
		super options
	
		Utils.define @, "status", options.status, @_setStatus
	
	_setStatus: (status) =>
		switch status
			when "warn"
				_.assign @, 
					icon: 'checkbox-blank-circle-outline'
					color: red
					scale: .7
			when "valid"
				_.assign @, 
					icon: 'checkbox-marked-circle'
					color: blue
					scale: 1
			when "hidden"
				_.assign @, 
					icon: 'checkbox-blank-circle-outline'
					color: null
					scale: .7
			else
				_.assign @, 
					icon: 'checkbox-blank-circle-outline'
					color: blue
					scale: .7

exampleStructure = [
	{
		name:
			label: "Name"
			field: TextInput
			placeholder: ""
			width: 100
			required: true
	}, {
		email: 
			label: "Email address"
			field: TextInput
			placeholder: "you@email.com"
			width: 100
			required: true
			validation: Utils.isEmail
			microText: "Please enter a valid email address."
			errorText: "The email you've entered is not valid."
	}, {
		_label:
			label: "Contact preferences"
			text: "May we contact you about a car accident that wasn't your fault?"
			width: 56
		gdpr:
			label: ""
			required: true
			field: Toggle
			options: ['No', 'Yes']
			errorText: "Please select."
	}
]