El = require 'stupid-dom-interface'
AirBox = require '../tools/AirBox'
Relateur = require '../tools/Relateur'
_Display = require './_Display'

module.exports = class FixedRatioFullscreenDisplay extends _Display

	constructor: (parent = document.body, @aspectRatio, @sourceScreen = [1920, 1080]) ->

		super

		@parent = El parent

		@node = display = El '.film-fixedRatioFullscreenDisplay'
		@node.inside @parent

		@view = El '.film-display-view.fixedRatio'
		.inside @node

		do @_prepareLayers

		@airBox = new AirBox @aspectRatio

		@width = @airBox.width
		@height = @airBox.height

		@view
		.width @airBox.width
		.height @airBox.height

		@airBox.on 'transform-change', =>

			@view
			.scale @airBox.scale
			.x @airBox.x
			.y @airBox.y

			return

		@relateur = new Relateur @height, @airBox._calculateDims(@sourceScreen[0], @sourceScreen[1]).height

		@normalize = @relateur.normalize

		@fromResolution = (n, w, h) =>

			@normalize n, @airBox._calculateDims(w, h).height