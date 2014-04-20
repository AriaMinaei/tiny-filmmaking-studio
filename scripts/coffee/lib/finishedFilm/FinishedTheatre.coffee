DynamicTimeline = require 'theatrejs/scripts/js/lib/DynamicTimeline'
StaticPlayerModel = require 'theatrejs/scripts/js/lib/StaticPlayerModel'

module.exports = class FinishedTheatre

	constructor: (@film) ->

		laneData = @film.options.lane

		@timeline = new DynamicTimeline 60

		@model = new StaticPlayerModel @film.id, @timeline, laneData

		@film.onTick @model.tick

	run: ->

		@model.run()