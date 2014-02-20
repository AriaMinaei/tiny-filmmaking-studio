Set = require('tiny-filmmaking-studio').Set

module.exports = class OpeningTitlesSet extends Set

	constructor: ->

		super

		# Every set should have an id
		@id = 'openingTitles'

		# if we need a specific background for our set,
		# we should make an element and put it in the
		# bgLayer:
		greyBg = @_makeEl '#openingTitles-greyBg.bg'
		.inside @film.display.bgLayer

		container = @_makeEl '#lma-container.container'
		.inside @film.display.stageEl



		aNx = @_makeEl '.titular'
		.inside container
		.html 'A&X'
		.css

			fontSize: 68

		@_setupDomEl 'LMA', 'A&X', aNx, [
			'translation', 'wysihwyg', 'rotation', 'opacity', 'scale', 'skew'
		]