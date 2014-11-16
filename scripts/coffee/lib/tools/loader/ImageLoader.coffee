Emitter = require 'utila/lib/Emitter'

module.exports = class ImageLoader extends Emitter

	constructor: (@loader, @address, initialSize) ->

		super

		@initialSize = initialSize|0

		if @initialSize < 1 then @initialSize = 50000

		@image = new Image

		@image.src = @address

		@loader._queue @initialSize

		@image.addEventListener 'load', =>

			@loader._unqueue @initialSize