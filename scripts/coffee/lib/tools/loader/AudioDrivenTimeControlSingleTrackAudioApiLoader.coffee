Emitter = require 'utila/lib/Emitter'

module.exports = class AudioDrivenTimeControlSingleTrackAudioApiLoader extends Emitter

	constructor: (@loader, @control, initialSize) ->

		super

		@initialSize = initialSize|0

		if @initialSize < 1 then @initialSize = 500000

		@realSize = 0

		@loader._queue @initialSize

		@req = @control.req

		@_lastLoaded = 0

		@req.addEventListener 'progress', (e) =>

			return if @_lastLoaded >= @initialSize

			diff = e.loaded - @_lastLoaded

			@_lastLoaded = e.loaded

			@loader._unqueue diff

		@req.addEventListener 'load', =>

			@_loader._unqueue @initialSize - @_lastLoaded if @initialSize > @_lastLoaded

			@_lastLoaded = @initialSize