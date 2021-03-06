HallowText = require './tools/HallowText'
object = require 'utila/lib/object'
Loader = require './tools/Loader'

module.exports = class _Film

	constructor: (options = {}) ->

		@options = self._getDefaultOptions()

		@id = @options.id

		object.overrideOnto @options, options

		do @_initRaf

		@sets = {}

		@loader = new Loader

	_initRaf: ->

		listeners = @_tickListeners = []

		requestAnimationFrame frame = (t) ->

			for listener in listeners

				listener t

			requestAnimationFrame frame

	onTick: (listener) ->

		@_tickListeners.push listener

	addSet: (set) ->

		id = set.id

		if @sets[id]?

			throw Error "Set '#{id}' already exists"

		@sets[id] = set

		@

	run: ->

		@theatre.run()

		@

	_addNormalizedAlternative: (obj, methodName, newMethodName) ->

		unless @display.normalize?

			obj[newMethodName] = obj[methodName]

			return

		normalize = @display.normalize

		func = obj[methodName]

		obj[newMethodName] = (n) -> func.call @, normalize n

		return

	_setupObject: (groupName, actorName, obj, methods) ->

		objName = String(groupName + ' ' + actorName).replace(/\s+/g, '-').toLowerCase()

		actor = @theatre.model.graph.getGroup groupName
		.getActor actorName

		@theatre.timeline.addObject objName, obj

		for name in methods

			actor.addPropOfObject name, objName, name, 0

		return

	_setupTangled: (groupName, actorName, propName, originalObject, props) ->

		objName = String(groupName + ' ' + actorName + ' ' + propName).replace(/\s+/g, '-').toLowerCase()

		actor = @theatre.model.graph.getGroup groupName
		.getActor actorName

		obj = applyProgress: (prog) ->

			for name, range of props

				originalObject[name] range[0] + prog * (range[1] - range[0])

		@theatre.timeline.addObject objName, obj

		for name, range of props

			props[name] = new Float32Array range

		actor.addPropOfObject propName, objName, 'applyProgress', 0

		return

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

		else

			if 'rotationX' in props

				actor.addPropOfObject 'Rotation X', objName, 'rotateX', 0

			if 'rotationY' in props

				actor.addPropOfObject 'Rotation Y', objName, 'rotateY', 0

			if 'rotationZ' in props

				actor.addPropOfObject 'Rotation Z', objName, 'rotateZ', 0


		if not shouldAccountForProps or 'translation' in props

			@_addNormalizedAlternative el, 'x', 'xNormalized'
			@_addNormalizedAlternative el, 'y', 'yNormalized'
			@_addNormalizedAlternative el, 'z', 'zNormalized'

			actor.addPropOfObject 'X', objName, 'xNormalized', 0
			actor.addPropOfObject 'Y', objName, 'yNormalized', 0
			actor.addPropOfObject 'Z', objName, 'zNormalized', 0

		else if 'xy' in props

			@_addNormalizedAlternative el, 'x', 'xNormalized'
			@_addNormalizedAlternative el, 'y', 'yNormalized'

			actor.addPropOfObject 'X', objName, 'xNormalized', 0
			actor.addPropOfObject 'Y', objName, 'yNormalized', 0

		else

			if 'x' in props

				@_addNormalizedAlternative el, 'x', 'xNormalized'

				actor.addPropOfObject 'X', objName, 'xNormalized', 0

			if 'y' in props

				@_addNormalizedAlternative el, 'y', 'yNormalized'

				actor.addPropOfObject 'Y', objName, 'yNormalized', 0

			if 'z' in props

				@_addNormalizedAlternative el, 'z', 'zNormalized'

				actor.addPropOfObject 'Z', objName, 'zNormalized', 0

		if not shouldAccountForProps or 'localTranslation' in props

			@_addNormalizedAlternative el, 'localX', 'localXNormalized'
			@_addNormalizedAlternative el, 'localY', 'localYNormalized'
			@_addNormalizedAlternative el, 'localZ', 'localZNormalized'

			actor.addPropOfObject 'Local X', objName, 'localXNormalized', 0
			actor.addPropOfObject 'Local Y', objName, 'localYNormalized', 0
			actor.addPropOfObject 'Local Z', objName, 'localZNormalized', 0

		if not shouldAccountForProps or 'transformOrigin' in props

			actor.addPropOfObject 'Transform Origin X', objName, 'transformOriginX', 0
			actor.addPropOfObject 'Transform Origin Y', objName, 'transformOriginY', 0
			actor.addPropOfObject 'Transform Origin Z', objName, 'transformOriginZ', 0

		if not shouldAccountForProps or 'scale' in props

			actor.addPropOfObject 'Scale X', objName, 'scaleX', 1
			actor.addPropOfObject 'Scale Y', objName, 'scaleY', 1
			actor.addPropOfObject 'Scale Z', objName, 'scaleZ', 1

		if 'scaleAll' in props

			actor.addPropOfObject 'Scale', objName, 'scale', 1

		if 'skew' in props

			actor.addPropOfObject 'Skew X', objName, 'skewX', 0
			actor.addPropOfObject 'Skew Y', objName, 'skewY', 0

		if not shouldAccountForProps or 'dims' in props

			@_addNormalizedAlternative el, 'width', 'widthNormalized'
			@_addNormalizedAlternative el, 'height', 'heightNormalized'

			actor.addPropOfObject 'Width', objName, 'widthNormalized', 0
			actor.addPropOfObject 'Height', objName, 'heightNormalized', 0

		if 'hallowText' in props

			hallowText = new HallowText el, 5

			hallowTextObjectName = objName + '-hallowText'

			@theatre.timeline.addObject hallowTextObjectName, hallowText

			hallowActor = @theatre.model.graph.getGroup groupName
			.getActor actorName + ' - HallowText'

			@_addNormalizedAlternative hallowText, 'setBaseRadius', 'setBaseRadiusNormalized'
			@_addNormalizedAlternative hallowText, 'setMaxMotionRadius', 'setMaxMotionRadiusNormalized'
			@_addNormalizedAlternative hallowText, 'setVelocityX', 'setVelocityXNormalized'
			@_addNormalizedAlternative hallowText, 'setVelocityY', 'setVelocityYNormalized'

			hallowActor.addPropOfObject 'Base Radius', hallowTextObjectName, 'setBaseRadiusNormalized', 0
			hallowActor.addPropOfObject 'Max Motion Radius', hallowTextObjectName, 'setMaxMotionRadiusNormalized', 10
			hallowActor.addPropOfObject 'Samples', hallowTextObjectName, 'setSamples', 5

			hallowActor.addPropOfObject 'Velocity X', hallowTextObjectName, 'setVelocityXNormalized', 0
			hallowActor.addPropOfObject 'Velocity Y', hallowTextObjectName, 'setVelocityYNormalized', 0

		if 'wysihwyg' in props and @wysihwyg?

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

			passphrase: 'no pass'

			sourceScreen: [1680, 1050]

		}

	self = @