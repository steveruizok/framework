# Custom Fonts

# Utils.insertCSS("""

# 	*:focus { outline: 0; }
# 	textarea { resize: none; }

# 	input::-webkit-input-placeholder { /* Chrome/Opera/Safari */
# 	  -webkit-text-fill-color: rgba(0,0,0,.5);
# 	}

# 	@font-face {
# 		font-family: 'Aktiv Grotesk';
# 		font-weight: 200;
# 		src: url('modules/cs-components/fonts/AktivGrotesk_W_Hair.woff'); 
# 	}

# 	@font-face {
# 		font-family: 'Aktiv Grotesk';
# 		font-weight: 300;
# 		src: url('modules/cs-components/fonts/AktivGrotesk_W_Lt.woff'); 
# 	}

# 	@font-face {
# 		font-family: 'Aktiv Grotesk';
# 		font-weight: 400;
# 		src: url('modules/cs-components/fonts/AktivGrotesk_W_Rg.woff'); 
# 	}

# 	@font-face {
# 		font-family: 'Aktiv Grotesk';
# 		font-weight: 500;
# 		src: url('modules/cs-components/fonts/AktivGrotesk_W_Md.woff'); 
# 	}

# 	""")

styles =
	Serif:
		color: '#000'
		fontFamily: 'Georgia'
	Sans:
		color: '#000'
		fontFamily: 'Helvetica'
	Mono:
		color: '#333'
		fontFamily: 'Menlo'
	H1:
		name: 'H1'
		style: 'Sans'
		fontSize: 80
		letterSpacing: -3
		lineHeight: 1
		fontWeight: 600
		color: black
	H2:
		name: 'H2'
		style: 'Sans'
		fontSize: 40
		letterSpacing: -1
		lineHeight: 1.1
		fontWeight: 600
		color: black
	H3:
		name: 'H3'
		style: 'sans'
		fontSize: 30
		letterSpacing: -0.01
		lineHeight: 1
		fontWeight: 600
		color: black
	H4:
		name: 'H4'
		style: 'Sans'
		fontSize: 30
		letterSpacing: -0.01
		lineHeight: 1
		fontWeight: 600
		color: black
	H4:
		name: 'H4'
		style: 'Sans'
		fontSize: 16
		lineHeight: 1.25
		letterSpacing: 0
		fontWeight: 600
		color: black
	H5:
		name: 'H5'
		style: 'Sans'
		fontSize: 13
		lineHeight: 1.5
		letterSpacing: 0
		fontWeight: 600
		color: black
	H6:
		name: 'H5'
		style: 'Sans'
		fontSize: 11
		lineHeight: 1.6
		fontWeight: 600
		letterSpacing: 0
		color: black
	Body:
		name: 'Body1'
		style: 'Sans'
		fontSize:  16
		fontWeight: 500
		letterSpacing: 0
		color: black
	Body1:
		name: 'Body1'
		style: 'Sans'
		fontSize:  16
		lineHeight: 1.25
		fontWeight: 500
		letterSpacing: 0
		color: black
	Body2:
		name: 'Body2'
		style: 'Sans'
		fontSize:  13
		lineHeight: 1.5
		fontWeight: 500
		letterSpacing: 0
		color: black
	Body3:
		name: 'Body3'
		style: 'Sans'
		fontSize:  11
		lineHeight: 1.6
		fontWeight: 500
		letterSpacing: 0
		color: black
	Code:
		name: 'Code'
		style: 'Mono'
		fontSize:  12
		lineHeight: 1.3
		fontWeight: 500
		letterSpacing: 0
		color: black

# Screen size dependent styles
# if Screen.width <= 768
# 	_.assign styles,
# 		H1:
# 			name: 'H1'
# 			style: 'sans'
# 			fontSize:  20
# 			fontWeight: 500
# 			color: black

{ theme } = require "components/Theme"

for className, style of theme.typography
	do (className, style) =>
		window[className] = (options = {}) =>
			_.defaults options, _.assign(styles[style.style], style)
			return new TextLayer(options)

exports.styles = styles