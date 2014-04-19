El = require 'stupid-dom-interface'
Emitter = require 'utila/scripts/js/lib/Emitter'

module.exports = class _Display extends Emitter

	constructor: (parentEl = document.body) ->

		super

		@parentEl = El parentEl

		@el.inside @parentEl

	_prepareLayers: ->

		@stageLayer = El '.film-display-view-stageLayer'
		.inside @view

		@bgLayer = El '.film-display-view-bgLayer'
		.inside @view

		@stageContainer = El '.film-display-view-stageContainer'
		.inside @stageLayer

	makeSetContainer: ->

		El '.film-display-view-stageContainer-setContainer'
		.inside @stageContainer

	makeBgEl: ->

		El '.film-display-view-bgEl'
		.inside @bgLayer