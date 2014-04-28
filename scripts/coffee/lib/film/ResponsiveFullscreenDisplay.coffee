El = require 'stupid-dom-interface'
_Display = require './_Display'

module.exports = class ResponsiveFullscreenDisplay extends _Display

	constructor: (parentEl = document.body) ->

		super

		@node = El '.film-responsiveFullscreenDisplay'
		@node.inside @parentEl

		@view = El '.film-display-view.responsive'
		.inside @node

		do @_prepareLayers