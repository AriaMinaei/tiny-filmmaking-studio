Emitter = require 'utila/scripts/js/lib/Emitter'
ImageLoader = require './loader/ImageLoader'

module.exports = class Loader extends Emitter

	constructor: ->

		super

		@total = 0

		@loaded = 0

		@progress = 1.0

	loadImage: (address, size) ->

		new ImageLoader @, address, size

		@

	_queue: (bytes) ->

		@total += bytes

		do @_updateProgress

	_unqueue: (bytes) ->

		@loaded += bytes

		do @_updateProgress

	_updateProgress: ->

		@progress = @loaded / @total

		@_emit 'progress'

		if @progress >= 0.999

			@_emit 'done'