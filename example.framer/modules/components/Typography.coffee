{ theme } = require "components/Theme"

for className, style of theme.typography
	do (className, style) =>
		window[className] = (options = {}) =>
			_.defaults options, _.assign(theme.typography[style.style], style)
			return new TextLayer(options)