framework = require "framework"
theme = framework.theme.theme



# -----------------
# myTheme - Example Custom Theme for Framework

# This is an example "theme" for Framework. With themes, you can
# add new components, add fonts, and set style over-rides without 
# modifying the base files, so that you can update Framework layer
# without losing your changes.



# -----------------
# Components

# To bring in your own components, require each of them
# and place the component's name (as a string) into
# the componentNames array.


{ Circle } = require 'myTheme-components/Circle'
# { Square } = require 'myTheme-components/Square'

componentNames = [
	'Circle'
#	'Square'
	]



# -----------------
# Fonts

# You can add fonts to your project by defing your fonts below. Start by 
# placing your font files the font's file in the your theme's fonts folder 
# (e.g. myTheme-components/fonts in the example below), then define the
# font according to the following pattern. These fonts will be available 
# everywhere: in Framer Cloud, offline, and on mobile devices.


fonts = [
	{
		fontFamily: "Mukta Mahee"
		fontWeight: 500
		fontStyle: "normal"
		src: "modules/myTheme-components/fonts/MuktaMahee-Regular.ttf"
	}, {
		fontFamily: "Mukta Mahee"
		fontWeight: 600
		fontStyle: "normal"
		src: "modules/myTheme-components/fonts/MuktaMahee-SemiBold.ttf"
	}, {
		fontFamily: "Mukta Mahee"
		fontWeight: 700
		fontStyle: "normal"
		src: "modules/myTheme-components/fonts/MuktaMahee-Bold.ttf"
	}
]



# -----------------
# Colors

# You can make changes to the default colors here.
# The colors you make will each get the "shade" treatment,
# so you'll be able to use colorName10, colorName20, etc as
# global variables. You can (and should!) use these colors
# in your custom components.

# You can change the value of the default colors (commented out
# in the list below), but you can't remove them.

shadeColors =
	# black: '#252729'
	# grey: '#c1c1c2'
	# yellow: '#ffd16d'
	# white: '#FFF'
	# red: '#d96161'
	# beige: '#eae5e0'
	# blue: '#5399c3'
	# green: '#599FA0'


# You can also add colors without giving them the full shade treatment.
# These colors will still be available as global variables in your project,
# but they won't have shade50, shade40, etc.

soloColors =
	orange: "#dcaa74"
	green: "#dcaa74"
	blue: "#547190"



# do not change ////////////////////////////////////////////////////////////
# -------------------------------------------------------------------------
framework.colors.updateColors(shadeColors, soloColors)
# -------------------------------------------------------------------------



# -----------------
# Component Styles

# You can make changes to the default component styling here. The changes 
# you make will be _merged_ into the defaults in modules/components/Theme.coffee. 
# For example, if there's a borderRadius of 2 in the defaults that you want to 
# change, you can over-write it with a different value. If you want to get rid 
# of it, you'll  have to over-write it below with a value of zero.

# Use those the Theme.coffee defaults as a reference -- but don't modify Theme.coffee!


themeStyles = 
	typography: 
		Serif:
			fontFamily: 'Times New Roman'
		Sans:
			fontFamily: 'Mukta Mahee'






# /////////////////////////////////////////////////////////////////////////
# -------------------------------------------------------------------------
# Blood-Slick Machinery
#
# Don't change this part!
#

# Update Styles

framework.theme.updateTheme(themeStyles)
framework.typography.updateTypography()

# Add Fonts

fontCSS = fonts.map( (font) ->
	
	"""
@font-face {
	font-family: #{font.fontFamily};
	font-weight: #{font.fontWeight};
	font-style: #{font.fontStyle};
	src: url(#{font.src});
}

""").join('\n')

Utils.insertCSS(fontCSS)

# Add Components

componentNames.forEach (componentName) =>
	window[componentName] = class FrameworkComponent extends eval(componentName)
		constructor: (options = {}) ->
			super options