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

	makeSetContainer: (inside = yes) ->

		el = El '.film-display-view-stageContainer-setContainer'

		if inside then el.inside @stageContainer

		el

	makeBgEl: (inside = yes) ->

		El '.film-display-view-bgEl'

		if inside then el.inside @bgLayer

		el