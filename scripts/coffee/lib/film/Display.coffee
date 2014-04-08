El = require 'stupid-dom-interface'
AirBox = require '../tools/AirBox'
Relateur = require '../tools/Relateur'

module.exports = class Display

	constructor: (@film) ->

		@aspectRatio = @film.options.aspectRatio

		@sourceScreen = @film.options.sourceScreen

		@el = El '#display'
		.inside document.body

		@viewEl = El '#view'
		.inside display

		@stageLayerEl = El '#stageLayer'
		.inside @viewEl

		@bgLayer = El '#bgLayer'
		.inside @viewEl

		@stageEl = El '#stage'
		.inside @stageLayerEl

		return if typeof @aspectRatio isnt 'number'

		@airBox = new AirBox @aspectRatio

		@width = @airBox.width
		@height = @airBox.height

		@viewEl
		.width @airBox.width
		.height @airBox.height

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