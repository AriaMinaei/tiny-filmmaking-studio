El = require 'stupid-dom-interface'
Emitter = require('utila/scripts/js/lib/Emitter')

module.exports = class DullSlideshow extends Emitter

	constructor: (@film, @groupName, @actorName, @bgPrefix = null, @bgPostfix = '') ->

		super

		@currentProgress = 0

		@currentValue = null

		@steps = []

		if @bgPrefix

			@el = El '.dullSlideshow.bg'
			.inside @film.display.bgLayer

			@on 'change', (value) =>

				@el.css 'background-image', "url(#{String(@bgPrefix)}#{value}#{String(@bgPostfix)})"

		@objName = String(@groupName + ' ' + @actorName).replace(/\s+/g, '-').toLowerCase()

		@actor = @film.theatre.model.graph.getGroup @groupName
		.getActor @actorName

		@film.theatre.timeline.addObject @objName, @

		@actor.addPropOfObject 'Slide', @objName, 'setProgress', 0

	add: (name) ->

		@steps.push name

		@

	setProgress: (pr) ->

		# round it down to an integer
		pr = pr|0

		@currentProgress = pr

		@currentValue = @steps[pr]

		@_emit 'change', @currentValue

		return