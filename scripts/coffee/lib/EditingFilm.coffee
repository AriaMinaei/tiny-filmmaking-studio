Film = require './Film'
Kilid = require 'kilid'
Grids = require './editingFilm/Grids'
EditingTheatre = require './editingFilm/EditingTheatre'
WysihwygManager = require './editingFilm/WysihwygManager'

module.exports = class EditingFilm extends Film

	constructor: ->

		super

		@kilid = (new Kilid).getRootScope()

		@theatre = new EditingTheatre @

		@moosh = @theatre.view.moosh

		@grids = new Grids @

		@wysihwyg = new WysihwygManager @

		@kilid.on 'ctrl+\\', ->

			document.body.classList.toggle 'debug'

	run: ->

		@theatre.model.run()

		@