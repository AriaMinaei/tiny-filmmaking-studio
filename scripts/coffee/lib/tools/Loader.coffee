Emitter = require 'utila/scripts/js/lib/Emitter'
ImageLoader = require './loader/ImageLoader'
AudioLoader = require './loader/AudioLoader'

module.exports = class Loader extends Emitter

	constructor: ->

		super

		@total = 0

		@loaded = 0

		@progress = 1.0

	loadImage: (address, size) ->

		new ImageLoader @, address, size

		@

	loadAudio: (address, size) ->

		new AudioLoader @, address, size

		@

	_queue: (bytes) ->

		@total += bytes

		do @_updateProgress

	_unqueue: (bytes) ->

		@loaded += bytes

		do @_updateProgress

	_updateProgress: ->

		@progress = @loaded / @total

		if @progress >= 0.98

			@progress = 1

			@_emit 'done'

		@_emit 'progress'