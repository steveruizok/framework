{ theme } = require "components/Theme"
{ Link } = require 'components/Link'
framework = require 'framework'

for className, style of theme.typography
	do (className, style) =>

		window[className] = class FrameworkComponent extends TextLayer 
			constructor: (options = {}) ->
				@constructorName = className

				_.assign(options, {app: framework.app})
				_.defaults options, style
		
				for key, value of theme.typography[style.style]
					options[key] = value

				super options

		window[className + 'Link'] = class FrameworkComponent extends Link 
			constructor: (options = {}) ->
				@constructorName = className

				_.assign(options, {app: framework.app})
				_.defaults options, style

				for key, value of theme.typography[style.style]
					options[key] = value
		
				super options
