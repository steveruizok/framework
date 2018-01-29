#View

A view is a page or screen in your project. More specifically, it is a full-sized scroll component with special hooks into the App component.

***

##Constructor

```coffeescript
myView = new View
	#title: 'Getting Started'
	#padding: {top: 16, left: 16, right: 16}
    #load: -> print 'hello world!'
```
***

## Properties

### *view.*title <string>

The view's title. If the App is set to change its title based on the current view, this property will be used for the app's title.

```coffeescript
myView = new View
	title: 'Home'
 
myView.title = 'Home'
```

### *view.*padding <object>

The padding to use for new children. Layers with edges outside of the padding will be adjusted to fit into it. Changing a view's `padding` won't affect children already added to the view. To turn off padding, set a `null` value. When a View is created, its default paddings are `{top: 16, left: 16, right: 16}`.

```coffeescript
myView = new View
	padding: {top: 16, left: 16, right: 16}
	
myView.padding = {top: 16, left: 16, right: 16}
```
### *view.*load <function>

The view's callback function. When the app loads this view as its current view, it will run its current view's `load` function with three arguments: the app instance, the new current view, and the app's previous view. 

```coffeescript
myView = new View
	load: (app, view, prev) -> print 'hello world!'

myView.load = (app, view, prev) -> print 'hello world!'

app.showNext(myView) # prints 'hello world!'
```
A view's `load` property works slightly differently than Framer's usual events: a view may have only one `load` callback at a time, however this callback may be changed without having to remove the previous `load`, making it easier to manage. 

Additional listeners may also be added to the view's `load` using standard events, shown in the **Events** section below.

------

## Methods

### *view*.onLoad(callback <function> )

A Framerish shortcut for setting a view's `load` property.

```coffeescript
myView.onLoad -> print 'Hello world!'
```

------

## Events

### *view*.on "load"

Events may be added to the view using the `"load"` event. Adding listeners will not change or replace the view's `load` property.

```coffeescript
myView.on "load", -> print "view is loaded!"
```

------

