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
		fontFamily: "Roboto"
		fontWeight: 400
		fontStyle: "normal"
		src: "modules/myTheme-components/fonts/Roboto-Regular.ttf"
	}, {
		fontFamily: "Roboto"
		fontWeight: 500
		fontStyle: "normal"
		src: "modules/myTheme-components/fonts/Roboto-Medium.ttf"
	}, {
		fontFamily: "Roboto"
		fontWeight: 600
		fontStyle: "normal"
		src: "modules/myTheme-components/fonts/Roboto-Bold.ttf"
	}, {
		fontFamily: "Roboto Mono"
		fontWeight: 500
		fontStyle: "normal"
		src: "modules/myTheme-components/fonts/RobotoMono-Medium.ttf"
	}, {
		fontFamily: "Montserrat"
		fontWeight: 700
		fontStyle: "normal"
		src: "modules/myTheme-components/fonts/Montserrat-ExtraBold.ttf"
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
	blue: '#21ccff'
	linen: '#f4f3f1'
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
	# --------------------------
	# Typography
	typography:
		Serif:
			color: black
			fontFamily: 'Montserrat'
		Sans:
			color: black
			fontFamily: 'Roboto'
		Mono:
			color: black40
			fontFamily: 'Roboto Mono'
			style: 
				tabSize: 2
		H1:
			name: 'H1'
			style: 'Serif'
			fontSize: 80
			letterSpacing: -3
			lineHeight: 1
			fontWeight: 600
			color: black
		H2:
			name: 'H2'
			style: 'Serif'
			fontSize: 32
			letterSpacing: -.5
			lineHeight: 1.1
			fontWeight: 500
			color: black
		H3:
			name: 'H3'
			style: 'Sans'
			fontSize: 30
			letterSpacing: -0.01
			lineHeight: 1
			fontWeight: 600
			color: black
		H4:
			name: 'H4'
			style: 'Sans'
			fontSize: 18
			letterSpacing: 0
			lineHeight: 1.2
			fontWeight: 600
			color: black
		H5:
			name: 'H5'
			style: 'Sans'
			fontSize: 16
			lineHeight: 1
			letterSpacing: 0
			fontWeight: 500
			color: black
		# H6:
		# 	name: 'H5'
		# 	style: 'Sans'
		# 	fontSize: 11
		# 	lineHeight: 1.6
		# 	fontWeight: 600
		# 	letterSpacing: 0
		# 	color: black
		Body:
			name: 'Body'
			style: 'Sans'
			fontSize:  16
			lineHeight: 1.25
			fontWeight: 400
			letterSpacing: 0
			color: black
		# Body1:
		# 	name: 'Body1'
		# 	style: 'Sans'
		# 	fontSize:  16
		# 	lineHeight: 1.25
		# 	fontWeight: 500
		# 	letterSpacing: 0
		# 	color: black
		# Body2:
		# 	name: 'Body2'
		# 	style: 'Sans'
		# 	fontSize:  13
		# 	lineHeight: 1.5
		# 	fontWeight: 500
		# 	letterSpacing: 0
		# 	color: black
		# Body3:
		# 	name: 'Body3'
		# 	style: 'Sans'
		# 	fontSize:  11
		# 	lineHeight: 1.6
		# 	fontWeight: 500
		# 	letterSpacing: 0
		# 	color: black
		# Code:
		# 	name: 'Code'
		# 	style: 'Mono'
		# 	fontSize:  12
		# 	lineHeight: 1.3
		# 	fontWeight: 500
		# 	letterSpacing: 0
		# 	color: black
		# 	fontFamily: 'Menlo'
		# 	style:
		# 		'tab-size': '4'
		# Label:
		# 	name: 'Label'
		# 	style: 'Sans'
		# 	fontSize:  13
		# 	lineHeight: 2.5
		# 	fontWeight: 600
		# 	letterSpacing: 0
		# 	color: black40
		# Micro:
		# 	name: 'Micro'
		# 	style: 'Sans'
		# 	fontSize:  11
		# 	lineHeight: 1.6
		# 	fontWeight: 500
		# 	letterSpacing: 0
		# 	padding: {top: 4}
		# 	color: grey






# /////////////////////////////////////////////////////////////////////////
# -------------------------------------------------------------------------
# Blood-Slick Machinery
#
# Don't change this part!
#

# Update Styles

framework.theme.updateTheme(themeStyles)

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

# Update Typography

framework.typography.updateTypography()

# Add Components

componentNames.forEach (componentName) =>
	window[componentName] = class FrameworkComponent extends eval(componentName)
		constructor: (options = {}) ->
			super options