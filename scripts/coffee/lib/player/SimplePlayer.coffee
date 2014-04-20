El = require 'stupid-dom-interface'

module.exports = class RegularPlayer

	constructor: (@film) ->

		@display = @film.display

		@moosh = @film.moosh

		@kilid = @film.kilid

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
		do @_prepareLoader

	_preparePlayPause: ->

		@playPauseNode = El '.simplePlayer-playPause'
		.inside @containerNode

		@moosh.onClick @playPauseNode
		.onDone =>

			@timeControl.togglePlayState()

	_prepareFullscreenRestore: ->

		@fullscreenRestoreNode = El '.simplePlayer-fullscreenRestore'
		.inside @containerNode

		@moosh.onClick @fullscreenRestoreNode
		.onDone =>

			@display.toggle()

	_prepareSeekbar: ->

		@seekbarNode = El '.simplePlayer-seekbar'
		.inside @containerNode

		seekbarWidth = 0
		startingPos = 0

		@moosh.onDrag @seekbarNode
		.onDown (e) =>

			seekbarWidth = @seekbarNode.node.clientWidth
			startingPos = e.layerX

			@timeControl.tick (startingPos) / seekbarWidth * @timeControl.duration

		.onDrag (e) =>

			@timeControl.tick (e.absX + startingPos) / seekbarWidth * @timeControl.duration

		do @_prepareSeeker

	_prepareSeeker: ->

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

	_prepareLoader: ->

		@loadBar = El '.simplePlayer-loadbar'
		.inside @containerNode

		@loadIndicator = El '.simplePlayer-loadBar-loadIndicator'
		.inside @loadBar

		@film.loader.on 'progress', => do @_updateLoadProgress

	_updateLoadProgress: ->

		progress = @film.loader.progress

		@loadIndicator.css width: "#{progress * 100.0}%"