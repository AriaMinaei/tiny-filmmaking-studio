Controls = require './filmPlayer/Controls'

module.exports = class FilmPlayer

	constructor: (@display) ->

		@controls = new Controls @