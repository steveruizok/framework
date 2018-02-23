Theme = require "components/Theme"
theme = Theme.theme

{ Link } = require 'components/Link'
framework = require 'framework'

updateTypography = ->
	for className, style of theme.typography
		do (className, style) =>

			window[className] = class FrameworkComponent extends TextLayer 
				constructor: (options = {}) ->
					theme = Theme.theme
					@app = framework.app
					_.defaults options, style
			
					for key, value of theme.typography[style.style]
						options[key] = value

					super options

			window[className + 'Link'] = class FrameworkComponent extends Link 
				constructor: (options = {}) ->
					theme = Theme.theme
					@app = framework.app
					_.defaults options, style

					for key, value of theme.typography[style.style]
						options[key] = value
			
					super options

exports.updateTypography = updateTypography
updateTypography()