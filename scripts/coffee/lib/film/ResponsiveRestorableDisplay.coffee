El = require 'stupid-dom-interface'
Foxie = require 'foxie'
_Display = require './_Display'

module.exports = class ResponsiveRestorableDisplay extends _Display

	constructor: (parent, restoreTarget) ->

		super

		@node = Foxie '.film-responsiveRestorableDisplay'
		.putIn @parentEl
		.z 1

		@parent = El parent

		@state = 'restored'

		@restoreTarget = El restoreTarget

		@fullscreenDims = width: 0, height: 0, top: 0, left: 0, scale: 1
		@restoredDims = width: 0, height: 0, top: 0, left: 0, scaleX: 1, scaleY: 1
		@currentDims = @restoredDims

		@view = El '.film-display-view.responsive'
		.inside @node

		@_relayoutTimeout = -1

		window.addEventListener 'resize', => do @_scheduleToRelayout

		window.addEventListener 'load', => do @_scheduleToRelayout

		do @_scheduleToRelayout

		@restore no

		do @_prepareLayers

	_layout: (emit = yes) ->

		@fullscreenDims.width = window.innerWidth
		@fullscreenDims.height = window.innerHeight

		@node.setWidth @fullscreenDims.width
		@node.setHeight @fullscreenDims.height

		if @state is 'restored'

			do @_layoutRestoreTarget

			do @_reposAsRestored

		else

			do @_reposAsFullscreen

		@_emit 'layout' if emit

	_reposAsFullscreen: ->

		@fullscreenDims.left = (window.scrollX or window.pageXOffset)
		@fullscreenDims.top = (window.scrollY or window.pageYOffset)

		@node.moveXTo @fullscreenDims.left
		@node.moveYTo @fullscreenDims.top
		@node.moveZTo 1
		@node.scaleAllTo @fullscreenDims.scale

	_layoutRestoreTarget: ->

		@restoredDims.width = @restoreTarget.node.clientWidth
		@restoredDims.height = @restoreTarget.node.clientHeight

	_reposAsRestored: ->

		rect = @restoreTarget.node.getBoundingClientRect()

		@restoredDims.scaleX = @restoredDims.width / @fullscreenDims.width
		@restoredDims.scaleY = @restoredDims.height / @fullscreenDims.height
		@restoredDims.left = rect.left + (window.scrollX or window.pageXOffset)
		@restoredDims.top = rect.top + (window.scrollY or window.pageYOffset)

		@node.moveXTo parseInt @restoredDims.left
		@node.moveYTo parseInt @restoredDims.top
		@node.moveZTo 1
		@node.scaleXTo @restoredDims.scaleX
		@node.scaleYTo @restoredDims.scaleY

	_setAnimated: (animated) ->

		if animated

			@node.trans 400

		else

			@node.noTrans()

		return

	restore: (animated = yes) ->

		@_setAnimated animated

		# @parent.removeClass 'film-unscrollableDisplayParent'

		@_layout no

		@state = 'restored'

		do @_reposAsRestored

		@currentDims = @restoredDims

		@_emit 'restore'

		@_emit 'layout'

	fullscreen: (animated = yes) ->

		@_setAnimated animated

		# @parent.addClass 'film-unscrollableDisplayParent'

		@_layout no

		@state = 'fullscreen'

		do @_reposAsFullscreen

		@currentDims = @fullscreenDims

		@_emit 'fullscreen'

		@_emit 'layout'

	toggle: (animated) ->

		if @state is 'fullscreen'

			@restore animated

		else

			@fullscreen animated

	_scheduleToRelayout: ->

		if @_relayoutTimeout is -1

			clearTimeout @_relayoutTimeout

			@_relayoutTimeout = -1

		@_relayoutTimeout = setTimeout =>

			do @_layout

		, 200