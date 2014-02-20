Griddly = require '../tools/Griddly'
El = require 'stupid-dom-interface'

module.exports = class Grids

	constructor: (@film) ->

		@overlay = null
		@showing = no

		@film.kilid.on 'ctrl+;', @toggle

		if @_retrieve() is 'yes' then do @show

		window.g = @toggle.bind @

	_memorize: (val) ->

		window.localStorage.setItem @film.id + '-grid-showing', val

	_retrieve: ->

		window.localStorage.getItem @film.id + '-grid-showing'

	show: ->

		unless @overlay?

			do @_makeOverlay

		@overlay.addClass 'visible'

		@showing = yes

		@_memorize 'yes'

	hide: ->

		@overlay.removeClass 'visible'

		@showing = no

		@_memorize 'no'

	toggle: =>

		if @showing then do @hide else do @show

	_makeOverlay: ->

		@overlay = El '#view-gridOverlay'
		.inside @film.display.viewEl

		g = new Griddly

			width: @film.display.width
			height: @film.display.height

			horizontalSpacing: '70 10'
			verticalSpacing: '38 10'

			color: [0.1, 0.1, 0.1, 0.9]

		url = g.getUrl()

		self.addStylesheetRules

			'#view-gridOverlay':

				'background-image': 'url(' + url + ')'

		return

	@addStylesheetRules: (rules) ->

		styleEl = document.createElement('style')

		document.head.appendChild(styleEl)

		s = styleEl.sheet

		for selector, props of rules

			propStr = ''

			for propName, propVal of props

				propImportant = ''

				if propVal[1] is true

					# propVal is an array of value/important, rather than a string.
					propVal = propVal[0]

					propImportant = ' !important'

				propStr += propName + ':' + propVal + propImportant + ';\n'

				s.insertRule(selector + '{' + propStr + '}', s.cssRules.length)

		return

	self = @