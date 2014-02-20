# Each lane consists of a few sets.
# One set may be used by multiple lanes

OpeningTitlesSet = require '../sets/OpeningTitlesSet'

module.exports = (film) ->

	# here, we simply add all of the sets
	# needed by this lane, to the film:
	film.addSet new OpeningTitlesSet film