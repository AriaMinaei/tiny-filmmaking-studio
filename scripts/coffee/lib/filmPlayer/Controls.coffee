El = require 'stupid-dom-interface'

module.exports = class Controls

	constructor: (@player) ->

		@display = @player.display

		do @_prepareNodes

		do @_layout

		@display.on 'layout', => do @_layout

	_prepareNodes: ->

		@node = El '.filmPlayer-controls'
		.inside @display.parent

		@containerNode = El '.filmPlayer-controls-container'
		.inside @node

		do @_preparePlayPause
		do @_prepareSeekbar
		do @_prepareFullscreenRestore

	_preparePlayPause: ->

		@playPauseNode = El '.filmPlayer-controls-playPause'
		.inside @containerNode

	_prepareFullscreenRestore: ->

		@fullscreenRestoreNode = El '.filmPlayer-controls-fullscreenRestore'
		.inside @containerNode

	_prepareSeekbar: ->

		@seekbarNode = El '.filmPlayer-controls-seekbar'
		.inside @containerNode

		@seekerNode = El '.filmPlayer-controls-seekbar-seeker'
		.inside @seekbarNode

	_layout: ->

		dims = @display.currentDims

		@node.width dims.width
		.x parseInt dims.left
		.y parseInt dims.top + dims.height