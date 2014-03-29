module.exports = class Relateur

	constructor: (@target, @defaultSource) ->

	normalize: (n, source = @defaultSource) =>

		@target / source * n