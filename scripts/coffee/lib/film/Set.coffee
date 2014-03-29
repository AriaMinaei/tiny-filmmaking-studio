El = require 'stupid-dom-interface'

module.exports = class Set

	constructor: (@film, @id) ->

		@_pieceBoundriesEventControllerTypesCount = 0

		@_normalize = @film.display.normalize

		@_fromResolution = @film.display.fromResolution

	_setupDomEl: ->

		@film._setupDomEl.apply @film, arguments

	_makeEl: (s) ->

		El s

	_onTime: (t, cb) ->

		typeId = @id + (@_pieceBoundriesEventControllerTypesCount++)

		@film.theatre.pieceBoundriesEventController.defineType typeId,

			fn: (forward, last, supposedT, currentT, args) ->

				cb forward

				return

		@film.theatre.pieceBoundriesEventController.events.add typeId, t