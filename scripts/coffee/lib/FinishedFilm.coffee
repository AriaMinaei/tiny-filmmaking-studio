_Film = require './_Film'
FinishedTheatre = require './finishedFilm/FinishedTheatre'

module.exports = class FinishedFilm extends _Film

	constructor: ->

		super

		@theatre = new FinishedTheatre @

