#Typography

Framework adds several new classes for handling text styles. They extend **TextLayer** and, apart from their new default properties, operate in exactly the same way as TextLayers.  

When the project loads, these classes are created based on the styles set in the **Theme.coffee** document, specifically in `Theme.styles`. You can customise a project's text styles by modifying this object: in addition to changing the default styles, removing styles will remove the resulting classes, and adding new styles will lead to new classes being created. 

***

##Constructor

The following styles are included:

- Serif
- Sans
- Mono
- H1
- H2
- H3
- H4
- H5
- H6
- Body1
- Body2
- Body3
- Code
- Label
- Micro

Each of these may be used exactly like TextLayers.

```coffeescript
myHeading = new H1
	text: 'Introduction'
```

***