Foxie = require 'foxie'

module.exports = class RegularPlayer

	constructor: (@film) ->

		@display = @film.display

		@moosh = @film.moosh

		@kilid = @film.kilid

		@timeControl = @film.theatre.model.timeControl

		@audio = @film.theatre.model.audio

		@parent = @display.parent

		do @_prepareNodes

		do @_layout

		@display.on 'layout', => do @_layout

		@display.on 'fullscreen', =>

			@moosh.disableScrolling()
			@kilid.disableScrolling()

		@display.on 'restore', =>

			@moosh.enableScrolling()
			@kilid.enableScrolling()

		@timeControl.on 'play-state-change', => do @_updatePlayState

		@timeControl.on 'time-change', =>

			do @_repositionSeeker

			do @_showPresentTime

		@timeControl.on 'duration-change', =>

			do @_repositionSeeker

			do @_showMovieLength

		# @audio.on 'mute-state-change', => do @_updateMuteState

	_prepareNodes: ->

		do @_preparePlayPause
		# do @_prepareMuteUnmute
		do @_prepareSeekbar
		do @_prepareFullscreenRestore
		# do @_prepareLoader
		do @_prepareTimeIndicators

	_preparePlayPause: ->

		@playPauseNode = Foxie '.simplePlayer-playPause.icon-play-2'
		.trans 400
		.putIn @parent

		@moosh.onClick @playPauseNode
		.onDone =>

			@timeControl.togglePlayState()

		@kilid.on 'space', =>

			@timeControl.togglePlayState()

	_relayPlayPause: ->

		dims = @display.currentDims

		@playPauseNode
		.moveXTo parseInt dims.left + 50
		.moveYTo parseInt dims.top + dims.height - 60
		.moveZTo 1

	_prepareMuteUnmute: ->

		@muteUnmuteNode = Foxie '.simplePlayer-muteUnmute'
		.trans 400
		.putIn @containerNode

		@moosh.onClick @muteUnmuteNode
		.onDone =>

			@audio.toggleMuteState()

	_prepareFullscreenRestore: ->

		@fullscreenRestoreNode = Foxie '.simplePlayer-fullscreenRestore.icon-resize-full'
		.trans 400
		.putIn @parent

		@moosh.onClick @fullscreenRestoreNode
		.onDone =>

			@display.toggle()

		@kilid.on 'esc', =>

			if @display.state is 'fullscreen'

				@display.restore()

	_relayFullscreenRestore: ->

		dims = @display.currentDims

		@fullscreenRestoreNode
		.moveXTo parseInt dims.left + dims.width - 80
		.moveYTo parseInt dims.top + dims.height - 60
		.moveZTo 1

	_prepareSeekbar: ->

		@seekbarNode = Foxie '.simplePlayer-seekbar'
		.putIn @parent
		.trans 400

		seekbarWidth = 0
		startingPos = 0

		@_seekbarDims =

			left: 0
			top: 0
			width: 0

		@moosh.onDrag @seekbarNode
		.onDown (e) =>

			seekbarWidth = @_seekbarDims.width
			startingPos = e.layerX

			@timeControl.tick (startingPos) / seekbarWidth * @timeControl.duration

		.onDrag (e) =>

			@timeControl.tick (e.absX + startingPos) / seekbarWidth * @timeControl.duration

		@kilid.on 'right', =>

			@timeControl.seekBy 5000

		@kilid.on 'left', =>

			@timeControl.seekBy -5000

		@kilid.on 'alt+right', =>

			@timeControl.seekBy 1000

		@kilid.on 'alt+left', =>

			@timeControl.seekBy -1000

		do @_prepareSeeker

	_relaySeekbar: ->

		dims = @display.currentDims

		@_seekbarDims.width = parseInt dims.width - 150 - 164

		@_seekbarDims.left = parseInt dims.left + 150

		@_seekbarDims.top = parseInt dims.top + dims.height - 60

		@seekbarNode
		.moveXTo @_seekbarDims.left
		.moveYTo @_seekbarDims.top
		.scaleXTo @_seekbarDims.width / 1000
		.moveZTo 1

		percent = @timeControl.t / @timeControl.duration

		@seekerNode
		.moveXTo @_seekbarDims.left + (percent * @_seekbarDims.width)
		.moveYTo @_seekbarDims.top + 3
		.moveZTo 1

	_prepareSeeker: ->

		@seekerNode = Foxie '.simplePlayer-seekbar-seeker'
		.trans 400
		.putIn @parent

	_prepareTimeIndicators: ->

		@presentTimeNode = Foxie '.simplePlayer-now'
		.trans 400
		.putIn @parent

		@presentTimeNode.node.innerHTML = "00:00"

		@movieLength = Foxie '.simplePlayer-length'
		.trans 400
		.putIn @parent

	_relayTimeIndicators: ->

		dims = @display.currentDims

		@presentTimeNode
		.moveXTo parseInt dims.left + 100
		.moveYTo parseInt dims.top + dims.height - 74
		.moveZTo 1

		@movieLength
		.moveXTo parseInt dims.left + dims.width - 150
		.moveYTo parseInt dims.top + dims.height - 74
		.moveZTo 1

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

		do @_relayFullscreenRestore
		do @_relayPlayPause
		do @_relayTimeIndicators
		do @_relaySeekbar

	_updatePlayState: ->

		if @timeControl.isPlaying()

			@playPauseNode
			.removeClass 'icon-play-2'
			.addClass 'icon-pause-2'

		else

			@playPauseNode
			.removeClass 'icon-pause-2'
			.addClass 'icon-play-2'

		return

	_repositionSeeker: ->

		do @_relaySeekbar

	_prepareLoader: ->

		@loadBar = Foxie '.simplePlayer-loadbar'
		.trans 400
		.putIn @containerNode

		@loadIndicator = Foxie '.simplePlayer-loadBar-loadIndicator'
		.trans 400
		.putIn @loadBar

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