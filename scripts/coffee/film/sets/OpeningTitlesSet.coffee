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

		# it's good practice to have all of our objects inside one
		# or more containers:
		container = @_makeEl '#openingTitles-container.container'
		.inside @film.display.stageEl

		# Let's add some text to our set:
		bigBlackHorse = @_makeEl '.title'
		# put it inside our container:
		.inside container
		.html 'Big Black Horse'
		.css

			fontSize: 72

		# this will introduce our text element to theatrejs:
		@_setupDomEl 'Opening Titles', 'Big Black Horse', bigBlackHorse, [
			'translation', 'rotation', 'opacity', 'scale', 'skew', 'wysihwyg'
		]