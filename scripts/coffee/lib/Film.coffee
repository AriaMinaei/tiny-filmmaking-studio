Display = require './film/Display'
HallowText = require './tools/HallowText'
object = require 'utila/scripts/js/lib/object'

module.exports = class Film

	constructor: (options = {}) ->

		@options = self._getDefaultOptions()

		@id = @options.id

		object.overrideOnto @options, options

		do @_initRaf

		@display = new Display @

		@sets = {}

	_initRaf: ->

		listeners = @_listeners = []

		requestAnimationFrame frame = (t) ->

			for listener in listeners

				listener t

			requestAnimationFrame frame

	tick: (listener) ->

		@_listeners.push listener

	addSet: (set) ->

		id = set.id

		if @sets[id]?

			throw Error "Set '#{id}' already exists"

		@sets[id] = set

		@

	_setupDomEl: (groupName, actorName, el, props) ->

		objName = String(groupName + ' ' + actorName).replace(/\s+/g, '-').toLowerCase()

		actor = @theatre.model.graph.getGroup groupName
		.getActor actorName

		@theatre.timeline.addObject objName, el

		shouldAccountForProps = Array.isArray(props) and props.length > 0

		if not shouldAccountForProps or 'opacity' in props

			actor.addPropOfObject 'Opacity', objName, 'opacity', 1

		if not shouldAccountForProps or 'rotation' in props

			actor.addPropOfObject 'Rotation X', objName, 'rotateX', 0
			actor.addPropOfObject 'Rotation Y', objName, 'rotateY', 0
			actor.addPropOfObject 'Rotation Z', objName, 'rotateZ', 0

		if not shouldAccountForProps or 'translation' in props

			actor.addPropOfObject 'X', objName, 'x', 0
			actor.addPropOfObject 'Y', objName, 'y', 0
			actor.addPropOfObject 'Z', objName, 'z', 0

		if not shouldAccountForProps or 'localTranslation' in props

			actor.addPropOfObject 'Local X', objName, 'localX', 0
			actor.addPropOfObject 'Local Y', objName, 'localY', 0
			actor.addPropOfObject 'Local Z', objName, 'localZ', 0

		if not shouldAccountForProps or 'transformOrigin' in props

			actor.addPropOfObject 'Transform Origin X', objName, 'transformOriginX', 0
			actor.addPropOfObject 'Transform Origin Y', objName, 'transformOriginY', 0
			actor.addPropOfObject 'Transform Origin Z', objName, 'transformOriginZ', 0

		if not shouldAccountForProps or 'scale' in props

			actor.addPropOfObject 'Scale X', objName, 'scaleX', 1
			actor.addPropOfObject 'Scale Y', objName, 'scaleY', 1
			actor.addPropOfObject 'Scale Z', objName, 'scaleZ', 1

		if 'skew' in props

			actor.addPropOfObject 'Skew X', objName, 'skewX', 0
			actor.addPropOfObject 'Skew Y', objName, 'skewY', 0

		if not shouldAccountForProps or 'dims' in props

			actor.addPropOfObject 'Width', objName, 'width', 0
			actor.addPropOfObject 'Height', objName, 'height', 0

		if 'hallowText' in props

			hallowText = new HallowText el, 5

			hallowTextObjectName = objName + '-hallowText'

			@theatre.timeline.addObject hallowTextObjectName, hallowText

			hallowActor = @theatre.model.graph.getGroup groupName
			.getActor actorName + ' - HallowText'

			hallowActor.addPropOfObject 'Base Radius', hallowTextObjectName, 'setBaseRadius', 0
			hallowActor.addPropOfObject 'Max Motion Radius', hallowTextObjectName, 'setMaxMotionRadius', 10
			hallowActor.addPropOfObject 'Samples', hallowTextObjectName, 'setSamples', 5


			hallowActor.addPropOfObject 'Velocity X', hallowTextObjectName, 'setVelocityX', 0
			hallowActor.addPropOfObject 'Velocity Y', hallowTextObjectName, 'setVelocityY', 0

		if 'wysihwyg' in props

			@wysihwyg.control el,

				main: actor

		actor

	@_getDefaultOptions: ->

		{
			id: 'no-id'

			lane: 'no-lane'

			debug: no

			aspectRatio: 1.85

			port: 6543

			pass: 'no pass'
		}

	self = @