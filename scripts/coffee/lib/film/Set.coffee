El = require 'stupid-dom-interface'

module.exports = class Set

	constructor: (@film, @id) ->

		@_setBoundriesEventControllerTypesCount = 0

		@_normalize = @film.display.normalize

		@_fromResolution = @film.display.fromResolution

	_setupDomEl: ->

		@film._setupDomEl.apply @film, arguments

	_setupObject: ->

		@film._setupObject.apply @film, arguments

	_makeEl: (s) ->

		El s

	_onTime: (t, cb) ->

		typeId = @id + (@_setBoundriesEventControllerTypesCount++)

		@film.theatre.setBoundriesEventController.defineType typeId,

			fn: (forward, last, supposedT, currentT, args) ->

				cb forward

				return

		@film.theatre.setBoundriesEventController.events.add typeId, t

	makeSetContainer: (range) ->

		el = @film.display.makeSetContainer no
		inside = @film.display.stageContainer

		@_appendElementOnTime el, inside, range

		el

	makeBgEl: (range) ->

		el = @film.display.makeBgEl no
		inside = @film.display.bgLayer

		@_appendElementOnTime el, inside, range

		el

	_appendElementOnTime: (el, inside, range) ->

		if not Array.isArray(range) or range.length is 0

			el.inside inside

			return

		@_onTime range[0], (forward) ->

			if forward

				el.inside inside

			else

				el.detach()

			return

		return unless range[1]?

		@_onTime range[1], (forward) ->

			unless forward

				el.inside inside

			else

				el.detach()

			return

		return