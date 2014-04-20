El = require 'stupid-dom-interface'

module.exports = class RegularPlayer

	constructor: (@film) ->

		@display = @film.display

		@timeControl = @film.theatre.model.timeControl

		do @_prepareNodes

		do @_layout

		@display.on 'layout', => do @_layout

		@timeControl.on 'play-state-change', => do @_updatePlayState

		@timeControl.on 'time-change', => do @_repositionSeeker

		@timeControl.on 'duration-change', => do @_repositionSeeker

	_prepareNodes: ->

		@node = El '.simplePlayer'
		.inside @display.parent

		@containerNode = El '.simplePlayer-container'
		.inside @node

		do @_preparePlayPause
		do @_prepareSeekbar
		do @_prepareFullscreenRestore

	_preparePlayPause: ->

		@playPauseNode = El '.simplePlayer-playPause'
		.inside @containerNode

		@playPauseNode.node.addEventListener 'click', =>

			@timeControl.togglePlayState()

	_prepareFullscreenRestore: ->

		@fullscreenRestoreNode = El '.simplePlayer-fullscreenRestore'
		.inside @containerNode

		@fullscreenRestoreNode.node.addEventListener 'click', =>

			@display.toggle()

	_prepareSeekbar: ->

		@seekbarNode = El '.simplePlayer-seekbar'
		.inside @containerNode

		@seekerNode = El '.simplePlayer-seekbar-seeker'
		.inside @seekbarNode

	_layout: ->

		dims = @display.currentDims

		@node.width dims.width
		.x parseInt dims.left
		.y parseInt dims.top + dims.height

	_updatePlayState: ->

		if @timeControl.isPlaying()

			@playPauseNode.addClass 'playing'

		else

			@playPauseNode.removeClass 'playing'

		return

	_repositionSeeker: ->

		percent = @timeControl.t / @timeControl.duration

		@seekerNode.css left: "#{percent * 100.0}%"