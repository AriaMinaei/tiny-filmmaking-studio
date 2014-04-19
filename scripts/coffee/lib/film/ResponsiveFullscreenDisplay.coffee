El = require 'stupid-dom-interface'
_Display = require './_Display'

module.exports = class ResponsiveFullscreenDisplay extends _Display

	constructor: (parentEl = document.body) ->

		@el = El '.film-responsiveFullscreenDisplay'

		super

		@view = El '.film-display-view.responsive'
		.inside @el

		do @_prepareLayers