El = require 'stupid-dom-interface'
_Display = require './_Display'

module.exports = class ResponsiveFullscreenDisplay extends _Display

	constructor: (parent = document.body) ->

		super

		@parent = El parent

		@node = El '.film-responsiveFullscreenDisplay'
		@node.inside @parent

		@view = El '.film-display-view.responsive'
		.inside @node

		do @_prepareLayers