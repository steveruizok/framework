#Header

The header simulates either an iOS environment, or the the safari browser of an iOS device.

***

##Constructor

Unlike most components, you won't have to create an instance of the Header component. It is created automatically by the App component.

***

## Properties

### *header.*title <string>

The header's title text. This property is normally set automatically through the App component.

```coffeescript
myHeader.title = 'New Title'
```

------

## Methods

### *header*.updateTitle(title)

Update the header's title, with a fade in and out. This method runs automatically when the App changes to a new View, based on that View's title.

```coffeescript
myHeader.updateTitle('New Title')
```

------

## Events

N/A

***