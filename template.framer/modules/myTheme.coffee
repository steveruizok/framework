framework = require "framework"
theme = framework.theme.theme

# -----------------
# myTheme - Example Custom Theme for Framework

# This is an example "theme" for Framework. With themes, you can
# add new components, add fonts, and set style over-rides without 
# modifying the base files, so that you can update Framework layer
# without losing your changes.

# -----------------
# Theme Folder
#
# Where should we look for your modules?


moduleFolder = "myTheme-components"

# -----------------
# Global Modules

# Import general objects into the global namespace (window), so
# that they may be used anywhere, including in your other modules,
# without the need for a separate "require".
#
# A global "Circle" will be processed, and be equal to adding
# { "Circle"} = require "myTheme-components/Circle"
# at the top of app.coffee and each of your modules.

globals = []


# -----------------
# Components

# To bring in your own components, require each of them
# and place the component's name (as a string) into
# the componentNames array.
#
# A component "Circle" will be processed, and be equal to adding
# { "Circle"} = require "myTheme-components/Circle"
# at the top of app.coffee and each of your modules.


componentNames = [
	"Circle"
	]


# -----------------
# Fonts

# You can add fonts to your project by defing your fonts below. Start by 
# placing your font files the font's file in the your theme's fonts folder 
# (e.g. myTheme-components/fonts in the example below), then define the
# font according to the following pattern. These fonts will be available 
# everywhere: in Framer Cloud, offline, and on mobile devices.


localFonts = [
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
	}, 
]

webFonts = [
	{
		fontFamily: "Montserrat"
		fontWeight: 700
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
	# # --------------------------
	# # Link
	# link:
	# 	default:
	# 		color: black
	# 	hovered:
	# 		color: grey80
	# 	touched:
	# 		color: grey60
	# 	disabled:
	# 		color: grey30
	# # --------------------------
	# # Text Input
	# textInput:
	# 	default:
	# 		color: black
	# 		borderColor: grey40
	# 		backgroundColor: white
	# 		shadowBlur: 0
	# 		shadowColor: 'rgba(0,0,0,.16)'
	# 		borderWidth: 1
	# 		borderRadius: 2
	# 	hovered:
	# 		color: black30
	# 		borderColor: grey
	# 		backgroundColor: white
	# 		shadowBlur: 0
	# 		shadowColor: 'rgba(0,0,0,.16)'
	# 	focused:
	# 		color: black
	# 		borderColor: black20
	# 		backgroundColor: white
	# 		shadowBlur: 6
	# 		shadowColor: 'rgba(0,0,0,.16)'
	# 	disabled:
	# 		color: grey20
	# 		borderColor: grey30
	# 		backgroundColor: white
	# 		shadowBlur: 0
	# 		shadowColor: 'rgba(0,0,0,0)'
	# 		borderWidth: 1
	# 		borderRadius: 2
	# # --------------------------
	# # Select
	# select:
	# 	default:
	# 		color: black
	# 		borderColor: grey40
	# 		backgroundColor: white
	# 		shadowBlur: 0
	# 		shadowColor: 'rgba(0,0,0,.16)'
	# 		borderWidth: 1
	# 		borderRadius: 2
	# 	hovered:
	# 		color: black30
	# 		borderColor: grey
	# 		backgroundColor: white
	# 		shadowBlur: 0
	# 		shadowColor: 'rgba(0,0,0,.16)'
	# 	focused:
	# 		color: black
	# 		borderColor: black20
	# 		backgroundColor: white
	# 		shadowBlur: 6
	# 		shadowColor: 'rgba(0,0,0,.16)'
	# 	disabled:
	# 		color: grey30
	# 		borderColor: grey30
	# 		backgroundColor: white
	# 		shadowBlur: 0
	# 		shadowColor: 'rgba(0,0,0,0)'
	# 		borderWidth: 1
	# 		borderRadius: 2
	# # --------------------------
	# # Option
	# option:
	# 	default:
	# 		color: grey40
	# 		borderColor: grey40
	# 		backgroundColor: white
	# 		shadowBlur: 0
	# 	hovered:
	# 		color: grey
	# 		borderColor: grey
	# 		backgroundColor: grey30
	# # --------------------------
	# # Stepper
	# stepper:
	# 	height: 48
	# 	borderRadius: 4
	# 	shadowY: 2
	# 	shadowBlur: 6
	# 	fontSize: 14
	# 	shadowColor: 'rgba(0,0,0,.16)'
	# 	backgroundColor: white
	# # --------------------------
	# # Tooltip
	# tooltip:
	# 	default:
	# 		backgroundColor: black
	# 		borderRadius: 3
	# # --------------------------
	# # Radiobox
	# radiobox:
	# 	default:
	# 		color: black
	# 		opacity: 1
	# 	disabled:
	# 		color: black
	# 		opacity: .1
	# 	hovered:
	# 		color: grey
	# 		opacity: 1
	# 	error:
	# 		color: red
	# 		opacity: 1
	# # --------------------------
	# # Checkbox
	# checkbox:
	# 	default:
	# 		color: black
	# 		opacity: 1
	# 	disabled:
	# 		color: black
	# 		opacity: .1
	# 	hovered:
	# 		color: grey
	# 		opacity: 1
	# 	error:
	# 		color: red
	# 		opacity: 1
	# # --------------------------
	# # Tab
	# tab:			
	# 	active:
	# 		default:
	# 			color: black
	# 			borderColor: grey40
	# 			backgroundColor: white
	# 			borderWidth: 1
	# 			borderRadius: 4
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 			shadowY: 0
	# 			shadowBlur: 0
	# 		disabled:
	# 			color: black
	# 			borderColor: grey40
	# 			backgroundColor: white
	# 		touched:
	# 			color: black
	# 			borderColor: grey40
	# 			backgroundColor: white
	# 		hovered:
	# 			color: black
	# 			borderColor: grey40
	# 			backgroundColor: white
	# 	default:
	# 		default:
	# 			color: black30
	# 			borderColor: grey40
	# 			backgroundColor: yellow30.lighten(7)
	# 			borderWidth: 1
	# 			borderRadius: 4
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 			shadowY: 0
	# 			shadowBlur: 0
	# 		disabled:
	# 			color: black30
	# 			borderColor: grey40
	# 			backgroundColor: yellow30.lighten(7)
	# 		touched:
	# 			color: black
	# 			borderColor: grey40
	# 			backgroundColor: yellow30.lighten(7)
	# 		hovered:
	# 			color: black
	# 			borderColor: grey40
	# 			backgroundColor: yellow30.lighten(4)
	# # --------------------------
	# # Segment
	# segment:
	# 	active:
	# 		default:
	# 			color: black
	# 			borderColor: yellow60
	# 			backgroundColor: yellow50
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 			borderWidth: 1
	# 			shadowY: 2
	# 			shadowBlur: 6
	# 		disabled:
	# 			color: grey
	# 			borderColor: grey40
	# 			backgroundColor: grey30
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 		touched:
	# 			color: black
	# 			borderColor: yellow70
	# 			backgroundColor: yellow70
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 		hovered:
	# 			color: black
	# 			borderColor: yellow70
	# 			backgroundColor: yellow60
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 	default:
	# 		default:
	# 			color: black
	# 			borderColor: grey40
	# 			backgroundColor: white
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 			borderWidth: 1
	# 			shadowY: 2
	# 			shadowBlur: 6
	# 		disabled:
	# 			color: grey
	# 			borderColor: grey40
	# 			backgroundColor: grey30
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 		touched:
	# 			color: black
	# 			borderColor: grey40
	# 			backgroundColor: white
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 		hovered:
	# 			color: black30
	# 			borderColor: grey40
	# 			backgroundColor: grey30
	# 			shadowColor: 'rgba(0,0,0,0)'
	# # --------------------------
	# # Button
	# button:
	# 	light_primary:
	# 		default:
	# 			color: black
	# 			borderColor: yellow60
	# 			backgroundColor: yellow50
	# 			shadowColor: 'rgba(0,0,0,.16)'
	# 			borderRadius: 4
	# 			borderWidth: 1
	# 			shadowY: 2
	# 			shadowBlur: 6
	# 		disabled:
	# 			color: new Color(black).alpha(.15)
	# 			borderColor: new Color(black).alpha(.15)
	# 			backgroundColor: new Color(yellow50).alpha(0)
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 		touched:
	# 			color: black
	# 			borderColor: yellow70
	# 			backgroundColor: yellow70
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 		hovered:
	# 			color: black
	# 			borderColor: yellow70
	# 			backgroundColor: yellow60
	# 			shadowColor: 'rgba(0,0,0,.16)'
	# 	light_secondary:
	# 		default:
	# 			color: black
	# 			borderColor: beige60
	# 			backgroundColor: beige50
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 			borderRadius: 4
	# 			borderWidth: 1
	# 			shadowY: 2
	# 			shadowBlur: 6
	# 		disabled:
	# 			color: new Color(black).alpha(.15)
	# 			borderColor: new Color(black).alpha(.15)
	# 			backgroundColor: new Color(beige50).alpha(0)
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 		touched:
	# 			color: black
	# 			borderColor: beige70
	# 			backgroundColor: beige70
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 		hovered:
	# 			color: black
	# 			borderColor: beige70
	# 			backgroundColor: beige60
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 	dark_primary:
	# 		default:
	# 			color: black
	# 			borderColor: null
	# 			backgroundColor: white
	# 			opacity: 1
	# 			shadowColor: 'rgba(0,0,0,.16)'
	# 			borderRadius: 4
	# 			borderWidth: 1
	# 			shadowY: 2
	# 			shadowBlur: 6
	# 		disabled:
	# 			color: grey40
	# 			borderColor: null
	# 			backgroundColor: grey30
	# 			opacity: .5
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 		touched:
	# 			color: black40
	# 			borderColor: null
	# 			backgroundColor: grey30
	# 			opacity: 1
	# 			shadowColor: 'rgba(0,0,0,.16)'
	# 		hovered:
	# 			color: black40
	# 			borderColor: null
	# 			backgroundColor: grey30
	# 			opacity: 1
	# 			shadowColor: 'rgba(0,0,0,.16)'
	# 	dark_secondary:
	# 		default:
	# 			color: white
	# 			borderColor: white
	# 			backgroundColor: null
	# 			opacity: 1
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 			borderRadius: 4
	# 			borderWidth: 1
	# 			shadowY: 2
	# 			shadowBlur: 6
	# 		disabled:
	# 			color: grey
	# 			borderColor: grey
	# 			backgroundColor: null
	# 			opacity: .5
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 		touched:
	# 			color: grey40
	# 			borderColor: grey40
	# 			backgroundColor: null
	# 			opacity: 1
	# 			shadowColor: 'rgba(0,0,0,0)'
	# 		hovered:
	# 			color: grey40
	# 			borderColor: grey40
	# 			backgroundColor: null
	# 			opacity: 1
	# 			shadowColor: 'rgba(0,0,0,0)'






# /////////////////////////////////////////////////////////////////////////
# -------------------------------------------------------------------------
# Blood-Slick Machinery
#
# Don't change this part!
#

# Update Styles

framework.theme.updateTheme(themeStyles)

fontloader = require 'components/fontloader'

# Update Styles

framework.theme.updateTheme(themeStyles)

# Add Fonts

if localFonts.length > 0
	fontloader.loadLocalFonts(localFonts)

if webFonts.length > 0
	fontloader.loadWebFonts(webFonts)

# Update Typography

framework.typography.updateTypography()

# Add Globals

globals.forEach (variable) ->
	mod = require "#{moduleFolder}/#{variable}"
	window[variable] = mod[variable]

# { User } = require 'thornbury-components/User'
# window["User"] = User

# Add Components

componentNames.forEach (componentName) ->
	mod = require "#{moduleFolder}/#{componentName}"
	component = mod[componentName]

	window[componentName] = class FrameworkComponent extends component
		constructor: (options = {}) ->
			@app = framework.app
			super options