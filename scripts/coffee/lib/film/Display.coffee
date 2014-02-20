AirBox = require '../tools/AirBox'
El = require 'stupid-dom-interface'

module.exports = class Display

	constructor: (@film) ->

		@aspectRatio = @film.options.aspectRatio

		@airBox = new AirBox @aspectRatio

		@el = El '#display'
		.inside document.body

		@width = @airBox.width
		@height = @airBox.height

		@viewEl = El '#view'
		.width @airBox.width
		.height @airBox.height
		.inside display

		@stageLayerEl = El '#stageLayer'
		.inside @viewEl

		@bgLayer = El '#bgLayer'
		.inside @viewEl

		@stageEl = El '#stage'
		.perspective 800
		.inside @stageLayerEl

		@airBox.on 'transform-change', =>

			@viewEl
			.scale @airBox.scale
			.x @airBox.x
			.y @airBox.y

			return