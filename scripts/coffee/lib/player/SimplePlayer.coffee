Foxie = require 'foxie'
El = require 'stupid-dom-interface'

module.exports = class RegularPlayer

	constructor: (@film) ->

		@autoFullscreen = yes

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
			do @_updateDisplayState

		@display.on 'restore', =>

			@moosh.enableScrolling()
			@kilid.enableScrolling()
			do @_updateDisplayState

		@timeControl.on 'play-state-change', => do @_updatePlayState

		@timeControl.on 'time-change', =>

			do @_repositionSeeker

			do @_updateNowIndicator

		@timeControl.on 'duration-change', =>

			do @_repositionSeeker

			do @_updateDurationIndicator

		@_isHidden = no

		@_hideTimeout = -1

		@_mouseIsHidden = no

		@_mouseHideTimeout = -1

		do @_prepareAutoHide

	_prepareNodes: ->

		do @_preparePlayPause
		do @_prepareSeekbar
		do @_prepareFullscreenRestore
		do @_prepareLoader
		do @_prepareTimeIndicators

	_preparePlayPause: ->

		@playPauseNode = Foxie '.simplePlayer-playPause.icon-play-2'
		.trans 520
		.putIn @parent

		done = no

		setTimeout =>

			if @film.loader.progress is 1

				done = yes

		, 50

		@film.loader.on 'done', -> done = yes

		toggle = =>

			# return unless done

			@timeControl.togglePlayState()

		@moosh.onClick @playPauseNode
		.onDone toggle

		@kilid.on 'space', toggle unless @film.constructor._editing

	_relayPlayPause: ->

		dims = @display.currentDims

		@playPauseNode
		.moveXTo parseInt dims.left + 55
		.moveYTo parseInt dims.top + dims.height - 63
		.moveZTo 1

	_updatePlayState: ->

		if @timeControl.isPlaying()

			@display.fullscreen() if @autoFullscreen

			@playPauseNode
			.removeClass 'icon-play-2'
			.addClass 'icon-pause-2'

		else

			@playPauseNode
			.removeClass 'icon-pause-2'
			.addClass 'icon-play-2'

		return

	_prepareTimeIndicators: ->

		@nowNode = Foxie '.simplePlayer-now'
		.trans 460
		.putIn @parent

		@nowNodeContent = El '.content'
		.inside @nowNode

		@nowNodeContent.html "00:00"

		@durationNode = Foxie '.simplePlayer-duration'
		.trans 460
		.putIn @parent

		@durationNodeContent = El '.content'
		.inside @durationNode

	_relayTimeIndicators: ->

		dims = @display.currentDims

		top = parseInt dims.top + dims.height - 72

		@nowNode
		.moveXTo parseInt dims.left + 98
		.moveYTo top
		.moveZTo 1

		@durationNode
		.moveXTo parseInt dims.left + dims.width - 147
		.moveYTo top
		.moveZTo 1

	_updateNowIndicator: ->

		time = @timeControl.t / 60000

		minutes = @_pad(time | 0)
		seconds = @_pad((time % 1 * 60) | 0)

		@nowNodeContent.html "#{minutes}:#{seconds}"

	_updateDurationIndicator: ->

		length = @timeControl.duration / 60000

		minutes = @_pad(length | 0)
		seconds = @_pad((length % 1 * 60) | 0)

		@durationNodeContent.html "#{minutes}:#{seconds}"

	_prepareSeekbar: ->

		@seekbarNode = Foxie '.simplePlayer-seekbar'
		.putIn @parent
		.moveZTo 1
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

		do @_prepareSeeker

		return unless @film.constructor._editing

		@kilid.on 'right', =>

			@timeControl.seekBy 5000

		@kilid.on 'left', =>

			@timeControl.seekBy -5000

		@kilid.on 'alt+right', =>

			@timeControl.seekBy 1000

		@kilid.on 'alt+left', =>

			@timeControl.seekBy -1000

	_relaySeekbar: ->

		dims = @display.currentDims

		@_seekbarDims.width = parseInt dims.width - 150 - 164

		@_seekbarDims.left = parseInt dims.left + 150

		@_seekbarDims.top = parseInt dims.top + dims.height - 56

		@seekbarNode
		.moveXTo @_seekbarDims.left
		.moveYTo @_seekbarDims.top
		.scaleXTo @_seekbarDims.width / 1000

		percent = @timeControl.t / @timeControl.duration

		percent = 0.0 unless 0 <= percent <= 1

		@seekerNode
		.moveXTo @_seekbarDims.left + (percent * @_seekbarDims.width)
		.moveYTo @_seekbarDims.top + 3

	_prepareSeeker: ->

		@seekerNode = Foxie '.simplePlayer-seekbar-seeker'
		.trans 400
		.putIn @parent
		.moveZTo 3

	_repositionSeeker: ->

		do @_relaySeekbar

	_prepareFullscreenRestore: ->

		@fullscreenRestoreNode = Foxie '.simplePlayer-fullscreenRestore.icon-resize-full'
		.trans 520
		.putIn @parent

		@moosh.onClick @fullscreenRestoreNode
		.onDone =>

			@display.toggle()

		return unless @film.constructor._editing

		@kilid.on 'esc', =>

			if @display.state is 'fullscreen'

				@display.restore()

	_relayFullscreenRestore: ->

		dims = @display.currentDims

		@fullscreenRestoreNode
		.moveXTo parseInt dims.left + dims.width - 90
		.moveYTo parseInt dims.top + dims.height - 63
		.moveZTo 1

	_updateDisplayState: ->

		if @display.state is 'fullscreen'

			@fullscreenRestoreNode.removeClass 'icon-resize-full'
			@fullscreenRestoreNode.addClass 'icon-resize-small'

		else

			@timeControl.pause() if @autoFullscreen
			@fullscreenRestoreNode.addClass 'icon-resize-full'
			@fullscreenRestoreNode.removeClass 'icon-resize-small'

	_layout: ->

		do @_relayFullscreenRestore
		do @_relayPlayPause
		do @_relayTimeIndicators
		do @_relaySeekbar
		do @_relayLoader

	_prepareLoader: ->

		@loadIndicator = Foxie '.simplePlayer-loadIndicator'
		.moveZTo 2
		.trans 400
		.putIn @parent

		@film.loader.on 'progress', => do @_updateLoadProgress

	_relayLoader: ->

		dims = @display.currentDims

		progress = @film.loader.progress

		width = (parseInt dims.width - 150 - 164) * progress

		left = parseInt dims.left + 150

		top = parseInt dims.top + dims.height - 56

		@loadIndicator
		.moveXTo left
		.moveYTo top
		.scaleXTo width / 1000

	_updateLoadProgress: ->

		do @_relayLoader

	_pad: (number) ->

		if number < 10 then return "0#{number}" else return number

	_prepareAutoHide: ->

		@display.on 'restore', =>

			do @_goVisible

			do @_makeMouseVisible

		@moosh.onHover document.body
		.onMove (e) =>

			return if @display.state is 'restored'

			do @_makeMouseVisible

			if @display.fullscreenDims.height - e.clientY > 100

				do @_scheduleToHide

				do @_scheduleToHideMouse

			else

				do @_goVisible

			return

		do @_makeNodesAnimateInOrder

	_makeNodesAnimateInOrder: ->

		nodes = [
			2
			@playPauseNode
			@fullscreenRestoreNode
			3
			@nowNode
			@durationNode
			@loadIndicator
			4
			@seekbarNode
			@seekerNode
		]

		n = 0

		for node in nodes

			if typeof node is 'number'

				n = node

				continue

			node.addClass 'n-' + n

		return

	_scheduleToHide: ->

		return if @_isHidden

		return if @_hideTimeout isnt -1

		@_hideTimeout = setTimeout =>

			@_hideTimeout = -1

			@_isHidden = yes

			do @_actuallyHide

		, 1000

	_actuallyHide: ->

		@playPauseNode.addClass 'hidden'
		@seekbarNode.addClass 'hidden'
		@seekerNode.addClass 'hidden'
		@fullscreenRestoreNode.addClass 'hidden'
		@nowNode.addClass 'hidden'
		@durationNode.addClass 'hidden'
		@loadIndicator.addClass 'hidden'

	_goVisible: ->

		if @_hideTimeout isnt -1

			clearTimeout @_hideTimeout

			@_hideTimeout = -1

		return unless @_isHidden

		@_isHidden = no

		@playPauseNode.removeClass 'hidden'
		@seekbarNode.removeClass 'hidden'
		@seekerNode.removeClass 'hidden'
		@fullscreenRestoreNode.removeClass 'hidden'
		@nowNode.removeClass 'hidden'
		@durationNode.removeClass 'hidden'
		@loadIndicator.removeClass 'hidden'

	_scheduleToHideMouse: ->

		return if @_mouseIsHidden

		return if @_mouseHideTimeout isnt -1

		@_mouseHideTimeout = setTimeout =>

			@_mouseHideTimeout = -1

			@_mouseIsHidden = yes

			do @_actuallyHideMouse

		, 1100

	_actuallyHideMouse: ->

		document.body.style.cursor = 'none'

	_makeMouseVisible: ->

		if @_mouseHideTimeout isnt -1

			clearTimeout @_mouseHideTimeout

			@_mouseHideTimeout = -1

		return unless @_mouseIsHidden

		@_mouseIsHidden = no

		document.body.style.cursor = ''