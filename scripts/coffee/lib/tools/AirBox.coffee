Emitter = require 'utila/scripts/js/lib/Emitter'

module.exports = class AirBox extends Emitter

	constructor: (@ratio) ->

		super

		@width = 0
		@height = 0

		@scale = 1
		@x = 0
		@y = 0

		@_chipAways = new Uint16Array 4

		do @_calculateDims

		window.addEventListener 'resize', @_recalculateTransform

		setTimeout @_recalculateTransform, 0

	chipAwayFromTop: (amount) ->

		@_chipAways[0] = amount

		do @_recalculateTransform

	chipAwayFromRight: (amount) ->

		@_chipAways[1] = amount

		do @_recalculateTransform

	chipAwayFromBottom: (amount) ->

		@_chipAways[2] = amount

		do @_recalculateTransform

	chipAwayFromLeft: (amount) ->

		@_chipAways[3] = amount

		do @_recalculateTransform

	_calculateDims: ->

		{width, height} = window.screen

		screenRatio = width / height

		if @ratio >= screenRatio

			@width = width
			@height = width / @ratio

		else

			@height = height
			@width = @height * @ratio

	_recalculateTransform: =>

		{innerWidth, innerHeight} = window

		innerWidth -= @_chipAways[1] + @_chipAways[3]
		innerHeight -= @_chipAways[0] + @_chipAways[2]

		wScale = innerWidth / @width

		hScale = innerHeight / @height

		scale = Math.min wScale, hScale

		@scale = scale

		@x = @_chipAways[3] + (innerWidth - @width) / 2.0
		@y = @_chipAways[0] + (innerHeight - @height) / 2.0

		@_emit 'transform-change'