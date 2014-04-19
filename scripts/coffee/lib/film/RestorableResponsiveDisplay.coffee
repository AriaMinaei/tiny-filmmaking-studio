El = require 'stupid-dom-interface'
Emitter = require 'utila/scripts/js/lib/Emitter'

module.exports = class RestorableResponsiveDisplay extends Emitter

	constructor: (restoreTarget, parent = document.body) ->

		super

		@parent = El parent

		@state = 'restored'

		@restoreTarget = El restoreTarget

		@_dummy = El '.film-display-dummy'
		.inside @parent

		@fullscreenDims = width: 0, height: 0, top: 0, left: 0, scale: 1
		@restoredDims = width: 0, height: 0, top: 0, left: 0, scaleX: 1, scaleY: 1
		@currentDims = @restoredDims

		@el = El '.film-display.responsive.restorable'
		.inside @parent

		@view = El '.film-display-view.responsive'
		.inside @el

		window.addEventListener 'resize', => do @_layout

		@restore no

		@el.node.addEventListener 'click', =>

			do @toggle

		do @_prepareLayers

	_prepareLayers: ->

		@_stageLayer = El '.film-display-view-stageLayer'
		.inside @view

		@bg = El '.film-display-view-bg'
		.inside @view

		@stage = El '.film-display-view-stage'
		.inside @_stageLayer

	_layout: (emit = yes) ->

		@fullscreenDims.width = @_dummy.node.clientWidth
		@fullscreenDims.height = @_dummy.node.clientHeight

		@el.width @fullscreenDims.width
		@el.height @fullscreenDims.height

		if @state is 'restored'

			do @_layoutRestoreTarget

			do @_reposAsRestored

		else

			do @_reposAsFullscreen

		@_emit 'layout' if emit

	_reposAsFullscreen: ->

		@fullscreenDims.left = window.scrollX
		@fullscreenDims.top = window.scrollY

		@el.x @fullscreenDims.left
		@el.y @fullscreenDims.top
		@el.scale @fullscreenDims.scale

	_layoutRestoreTarget: ->

		@restoredDims.width = @restoreTarget.node.clientWidth
		@restoredDims.height = @restoreTarget.node.clientHeight

	_reposAsRestored: ->

		rect = @restoreTarget.node.getBoundingClientRect()

		@restoredDims.scaleX = @restoredDims.width / @fullscreenDims.width
		@restoredDims.scaleY = @restoredDims.height / @fullscreenDims.height
		@restoredDims.left = rect.left + window.scrollX
		@restoredDims.top = rect.top + window.scrollY

		@el.x @restoredDims.left
		@el.y @restoredDims.top
		@el.scaleX @restoredDims.scaleX
		@el.scaleY @restoredDims.scaleY

	restore: (animated = yes) ->

		if animated

			@el.addClass 'film-animatedDisplay'

		else

			@el.removeClass 'film-animatedDisplay'

		@parent.removeClass 'film-unscrollableDisplayParent'

		@_layout no

		@state = 'restored'

		do @_reposAsRestored

		@currentDims = @restoredDims

		@_emit 'restore'

		@_emit 'layout'

	fullscreen: (animated = yes) ->

		if animated

			@el.addClass 'film-animatedDisplay'

		else

			@el.removeClass 'film-animatedDisplay'

		@parent.addClass 'film-unscrollableDisplayParent'

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