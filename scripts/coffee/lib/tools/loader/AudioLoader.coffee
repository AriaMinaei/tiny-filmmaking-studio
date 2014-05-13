Emitter = require 'utila/scripts/js/lib/Emitter'

module.exports = class AudioLoader extends Emitter

	constructor: (@loader, elOrAddress, initialSize) ->

		super

		@initialSize = initialSize|0

		if @initialSize < 1 then @initialSize = 500000

		@realSize = 0

		if elOrAddress instanceof HTMLAudioElement

			@el = elOrAddress

		else

			@el = document.createElement 'audio'

			@el.src = elOrAddress

		@el.preload = 'auto'

		@loader._queue @initialSize

		@lastLoadedDuration = 0

		events = [
			'progress', 'canplaythrough', 'loadeddata'
		]

		@el.addEventListener e, @_recalculateProgress for e in events

	_recalculateProgress: =>

		duration =  @el.duration

		return if isNaN(duration)

		buffered = 0

		for i in [0...@el.buffered.length]

			buffered += @el.buffered.end(i) - @el.buffered.start(i)

		diff = buffered - @lastLoadedDuration

		@lastLoadedDuration = buffered

		@loader._unqueue (diff/duration) * @initialSize