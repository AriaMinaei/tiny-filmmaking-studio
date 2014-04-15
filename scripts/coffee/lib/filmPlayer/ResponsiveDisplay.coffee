El = require 'stupid-dom-interface'
Emitter = require 'utila/scripts/js/lib/Emitter'

module.exports = class ResponsiveDisplay extends Emitter

	constructor: (restoreTarget, parent = document.body) ->

		super

		@parent = El parent

		@state = 'restored'

		@restoreTarget = El restoreTarget

		@_dummy = El '.film-display-dummy'
		.inside @parent

		@fullscreenDims = width: 0, height: 0, top: 0, left: 0, scale: 1
		@restoredDims = width: 0, height: 0, top: 0, left: 0, scale: 1

		@el = El '.film-display.responsive'
		.inside @parent

		@view = El '.film-display-view.responsive'
		.inside @el

		window.addEventListener 'resize', => do @_redim

		@restore no

		@el.node.addEventListener 'click', =>

			do @toggle

	_redim: ->

		@fullscreenDims.width = @_dummy.node.clientWidth
		@fullscreenDims.height = @_dummy.node.clientHeight

		@el.width @fullscreenDims.width
		@el.height @fullscreenDims.height

		if @state is 'restored'

			do @_redimRestoreTarget

			do @_reposAsRestored

		else

			do @_reposAsFullscreen

		@_emit 'redim'

	_reposAsFullscreen: ->

		@fullscreenDims.left = window.scrollX
		@fullscreenDims.top = window.scrollY

		@el.x @fullscreenDims.left
		@el.y @fullscreenDims.top
		@el.scale @fullscreenDims.scale

	_redimRestoreTarget: ->

		@restoredDims.width = @restoreTarget.node.clientWidth

		rel = @restoredDims.width / @fullscreenDims.width

		@restoreTarget.height @restoredDims.height = rel * @fullscreenDims.height

	_reposAsRestored: ->

		rect = @restoreTarget.node.getBoundingClientRect()

		@restoredDims.scale = @restoredDims.width / @fullscreenDims.width
		@restoredDims.left = rect.left + window.scrollX
		@restoredDims.top = rect.top + window.scrollY

		@el.x @restoredDims.left
		@el.y @restoredDims.top
		@el.scale @restoredDims.scale

	restore: (animated = yes) ->

		if animated

			@el.addClass 'film-animatedDisplay'

		else

			@el.removeClass 'film-animatedDisplay'

		@parent.removeClass 'film-unscrollableDisplayParent'

		do @_redim

		@state = 'restored'

		do @_reposAsRestored

	fullscreen: (animated = yes) ->

		if animated

			@el.addClass 'film-animatedDisplay'

		else

			@el.removeClass 'film-animatedDisplay'

		@parent.addClass 'film-unscrollableDisplayParent'

		do @_redim

		@state = 'fullscreen'

		do @_reposAsFullscreen

	toggle: (animated) ->

		if @state is 'fullscreen'

			@restore animated

		else

			@fullscreen animated