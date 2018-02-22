framework = require "framework"
{ theme } = require 'framework'

# -----------------
# Components

# Require each component
{ Circle } = require 'myTheme-components/Circle'

# Place the names of each component in this array
componentNames = [
	'Circle'
]


# -----------------
# Theme
# Make changes to the default theme. 
# Check components/Theme for the defaults. (But don't modify it).

theme.typography.Serif =
	fontFamily: 'Times New Roman'

theme.typography.Sans =
	fontFamily: 'Avenir'










# -----------------
# Don't change this part!

componentNames.forEach (componentName) =>
	c = eval(componentName)
	window[componentName] = class FrameworkComponent extends c 
		constructor: (options = {}) ->
			@constructorName = componentName

			_.assign(options, {app: framework.app})

			super options