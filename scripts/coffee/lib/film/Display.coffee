El = require 'stupid-dom-interface'
AirBox = require '../tools/AirBox'
Relateur = require '../tools/Relateur'

module.exports = class Display

	constructor: (@film) ->

		@aspectRatio = @film.options.aspectRatio

		@sourceScreen = @film.options.sourceScreen

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

		@relateur = new Relateur @height, @airBox._calculateDims(@sourceScreen[0], @sourceScreen[1]).height

		@normalize = @relateur.normalize

		@fromResolution = (n, w, h) =>

			@normalize n, @airBox._calculateDims(w, h).height