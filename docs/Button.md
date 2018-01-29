#Header

A button will run a callback function when it is selected.

***

##Constructor

```coffeescript
myButton = new Button
	#text: 'Get Started'
	#disabled: false
	#secondary: false
    #dark: false
    #select: -> null
```
***

## Properties

### *button.*text <string>

The button's text label. Note that, if the button's width is left `undefined`, the button will automatically set its width based on the length of its text content.

```coffeescript
myButton = new Button
	text: 'Click here!'

myButton.text = 'Click here!'
```

### *button.*icon <string>

The button's icon. If the button has a value for both `text` and `icon`, it will show the icon to the left of the text. If `text` is set to null or `''`, the icon will be shown on its own. For more on icons, and which string names are valid, see the **Icons** documentation. Constructor only. 

```coffeescript
myButton = new Button
	icon: 'star'
```

### *button.*dark <bool>

Whether the button should be set to its dark display mode. Dark buttons work the same as light buttons, but are meant for dark backgrounds. Constructor only.

```coffeescript
myButton = new Button
	dark: true
```

### *button.*secondary <bool>

Whether the button should be set to its secondary display mode. Secondary buttons work the same as primary buttons. Constructor only.

```coffeescript
myButton = new Button
	secondary: true
```

### *button.*disabled <bool>

Whether the button should be disabled. Buttons will not respond to interactions while they are disabled.

```coffeescript
myButton = new Button
	disabled: true
	
myButton.disabled = true
```
### *button.*select <function>

The button's callback function. This will run (or `try` to) when a non-disabled button is tapped. 

```coffeescript
myButton = new Button
	select: -> print 'hello world!'

myButton.select = -> print 'hello world!'
```
A button's `select` property works slightly differently than Framer's usual events: a button may have only one `select` callback at a time, however this callback may be changed without without having to remove the previous `select`, making it easier to manage. 

Additional listeners may also be added to the button's `select` using standard events, shown in the **Events** section below.

------

## Methods

### *button*.onSelect(callback <function> )

A Framerish shortcut for setting a button's `select` property.

```coffeescript
myButton.onSelect -> print 'Hello world!'
```

------

## Events

###*button*.on "select"

Events may be added to the button using the `"select"` event. Adding listeners will not change or replace the button's `select` property.

```coffeescript
myButton.on "select", -> print "hello world!"
```
***

