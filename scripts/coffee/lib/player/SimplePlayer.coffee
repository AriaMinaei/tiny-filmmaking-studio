El = require 'stupid-dom-interface'

module.exports = class RegularPlayer

	constructor: (@film) ->

		@display = @film.display

		@moosh = @film.moosh

		@kilid = @film.kilid

		@timeControl = @film.theatre.model.timeControl

		@audio = @film.theatre.model.audio

		do @_prepareNodes

		do @_layout

		@display.on 'layout', => do @_layout

		@timeControl.on 'play-state-change', => do @_updatePlayState

		@timeControl.on 'time-change', =>

			do @_repositionSeeker

			do @_showPresentTime

		@timeControl.on 'duration-change', =>

			do @_repositionSeeker

			do @_showMovieLength

		@audio.on 'mute-state-change', => do @_updateMuteState

	_prepareNodes: ->

		@node = El '.simplePlayer'
		.inside @display.parent

		@containerNode = El '.simplePlayer-container'
		.inside @node

		do @_preparePlayPause
		do @_prepareMuteUnmute
		do @_prepareSeekbar
		do @_prepareFullscreenRestore
		do @_prepareLoader
		do @_prepareTimeIndicators

	_preparePlayPause: ->

		@playPauseNode = El '.simplePlayer-playPause'
		.inside @containerNode

		@moosh.onClick @playPauseNode
		.onDone =>

			@timeControl.togglePlayState()

	_prepareMuteUnmute: ->

		@muteUnmuteNode = El '.simplePlayer-muteUnmute'
		.inside @containerNode

		@moosh.onClick @muteUnmuteNode
		.onDone =>

			@audio.toggleMuteState()

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

	_prepareTimeIndicators: ->

		@presentTimeNode = El '.simplePlayer-time .now'
		.inside @containerNode

		@presentTimeNode.node.innerHTML = "00:00"

		@movieLength = El '.simplePlayer-time .length'
		.inside @containerNode

	_showPresentTime: ->

		time = @timeControl.t / 60000

		minutes = @_pad(time | 0)
		seconds = @_pad((time % 1 * 60) | 0)

		@presentTimeNode.node.innerHTML = "#{minutes}:#{seconds}"

	_showMovieLength: ->

		length = @timeControl.duration / 60000

		minutes = @_pad(length | 0)
		seconds = @_pad((length % 1 * 60) | 0)

		@movieLength.node.innerHTML = "#{minutes}:#{seconds}"

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

	_updateMuteState: ->

		if @audio.isMuted()

			@muteUnmuteNode.addClass 'muted'

		else

			@muteUnmuteNode.removeClass 'muted'

		return

	_pad: (number) ->

		if number < 10 then return "0#{number}" else return number