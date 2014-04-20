_Film = require './_Film'
Loader = require './finishedFilm/Loader'
FinishedTheatre = require './finishedFilm/FinishedTheatre'

module.exports = class FinishedFilm extends _Film

	constructor: ->

		super

		@theatre = new FinishedTheatre @

		@loader = new Loader