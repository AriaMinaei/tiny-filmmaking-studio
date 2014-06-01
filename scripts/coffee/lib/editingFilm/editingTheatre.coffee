EditorModel = require 'theatrejs/scripts/js/lib/EditorModel'
EditorView = require 'theatrejs/scripts/js/lib/EditorView'
DynamicTimeline = require 'theatrejs/scripts/js/lib/DynamicTimeline'

module.exports = class EditingTheatre

	constructor: (@film) ->

		@timeline = new DynamicTimeline 60

		@model = new EditorModel @film.id, @timeline, @film.options.debug is yes
		@view = new EditorView @model, document.body

		mainBox = @model.mainBox

		mainBox.toggleVisibility()

		mainBox.on 'visibility-toggle', @_resetAirbox

		mainBox.on 'height-change', @_resetAirbox

		@film.onTick @view.tick

		@model.communicateWith 'http://localhost:' + @film.options.port, @film.options.lane, @film.options.passphrase

		@setBoundriesEventController = @timeline.addEventController 'Set Boundries'

		@film.kilid.on 'ctrl+shift+=', @_toggleDisplayFittingMethod

		@_fitDisplayWithMainBox = yes

		if @_retrieve('fitDisplayWithMainBox') is 'no'

			do @_toggleDisplayFittingMethod

	run: ->

		@model.run()

	_toggleDisplayFittingMethod: =>

		@_fitDisplayWithMainBox = not @_fitDisplayWithMainBox

		@_memorize 'fitDisplayWithMainBox', if @_fitDisplayWithMainBox then 'yes' else 'no'

		do @_resetAirbox

	_resetAirbox: =>

		return unless @film.display.airBox?

		unless @_fitDisplayWithMainBox

			@film.display.airBox.chipAwayFromBottom 0

			return

		if @model.mainBox._isVisible

			@film.display.airBox.chipAwayFromBottom @model.mainBox.height

		else

			@film.display.airBox.chipAwayFromBottom 0

	_memorize: (key, val) ->

		window.localStorage.setItem @film.id + '-editingTheatre-' + key, val

	_retrieve: (key) ->

		window.localStorage.getItem @film.id + '-editingTheatre-' + key