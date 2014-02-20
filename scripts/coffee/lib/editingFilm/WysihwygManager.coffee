El = require 'stupid-dom-interface'

module.exports = class WysihwygManager

	constructor: (@film) ->

		@moosh = @film.moosh
		@kilid = @film.kilid

		@timeline = @film.theatre.model.timeline

		@el = null

		@actors = null

		do @_prepareDash

		do @_setupKilid

		do @_setupMoosh

	_prepareDash: ->

		@dash = El '#wysihwyg-dash'

	_setupKilid: ->

		@kilid.on 'ctrl+d', =>

			do @relinquish

		# movement
		@kilid.on 'x+right', => @_adjust 'X', 10
		@kilid.on 'x+alt+right', => @_adjust 'X', 1
		@kilid.on 'x+ctrl+right', => @_adjust 'X', 100

		@kilid.on 'x+left', => @_adjust 'X', -10
		@kilid.on 'x+alt+left', => @_adjust 'X', -1
		@kilid.on 'x+ctrl+left', => @_adjust 'X', -100

		@kilid.on 'x+down', => @_adjust 'Y', 10
		@kilid.on 'x+alt+down', => @_adjust 'Y', 1
		@kilid.on 'x+ctrl+down', => @_adjust 'Y', 100

		@kilid.on 'x+up', => @_adjust 'Y', -10
		@kilid.on 'x+alt+up', => @_adjust 'Y', -1
		@kilid.on 'x+ctrl+up', => @_adjust 'Y', -100

		@kilid.on 'z+down', => @_adjust 'Z', 10
		@kilid.on 'z+alt+down', => @_adjust 'Z', 1
		@kilid.on 'z+ctrl+down', => @_adjust 'Z', 100

		@kilid.on 'z+up', => @_adjust 'Z', -10
		@kilid.on 'z+alt+up', => @_adjust 'Z', -1
		@kilid.on 'z+ctrl+up', => @_adjust 'Z', -100

		#rotation
		@kilid.on 'e+right', => @_adjust 'Rotation Z', 10
		@kilid.on 'e+alt+right', => @_adjust 'Rotation Z', 1
		@kilid.on 'e+ctrl+right', => @_adjust 'Rotation Z', 100

		@kilid.on 'e+left', => @_adjust 'Rotation Z', -10
		@kilid.on 'e+alt+left', => @_adjust 'Rotation Z', -1
		@kilid.on 'e+ctrl+left', => @_adjust 'Rotation Z', -100

		@kilid.on 'q+right', => @_adjust 'Rotation Y', 10
		@kilid.on 'q+alt+right', => @_adjust 'Rotation Y', 1
		@kilid.on 'q+ctrl+right', => @_adjust 'Rotation Y', 100

		@kilid.on 'q+left', => @_adjust 'Rotation Y', -10
		@kilid.on 'q+alt+left', => @_adjust 'Rotation Y', -1
		@kilid.on 'q+ctrl+left', => @_adjust 'Rotation Y', -100

		@kilid.on 'q+up', => @_adjust 'Rotation X', 10
		@kilid.on 'q+alt+up', => @_adjust 'Rotation X', 1
		@kilid.on 'q+ctrl+up', => @_adjust 'Rotation X', 100

		@kilid.on 'q+down', => @_adjust 'Rotation X', -10
		@kilid.on 'q+alt+down', => @_adjust 'Rotation X', -1
		@kilid.on 'q+ctrl+down', => @_adjust 'Rotation X', -100

		# opacity
		@kilid.on '`+up', => @_adjust 'Opacity', 0.1
		@kilid.on '`+alt+up', => @_adjust 'Opacity', 0.01
		@kilid.on '`+ctrl+up', => @_adjust 'Opacity', 0.2

		@kilid.on '`+down', => @_adjust 'Opacity', -0.1
		@kilid.on '`+alt+down', => @_adjust 'Opacity', -0.01
		@kilid.on '`+ctrl+down', => @_adjust 'Opacity', -0.2

		# scale
		@kilid.on 'w+up', => @_adjust 'Scale Y', 0.1
		@kilid.on 'w+alt+up', => @_adjust 'Scale Y', 0.01
		@kilid.on 'w+ctrl+up', => @_adjust 'Scale Y', 0.2

		@kilid.on 'w+down', => @_adjust 'Scale Y', -0.1
		@kilid.on 'w+alt+down', => @_adjust 'Scale Y', -0.01
		@kilid.on 'w+ctrl+down', => @_adjust 'Scale Y', -0.2

		@kilid.on 'w+right', => @_adjust 'Scale X', 0.1
		@kilid.on 'w+alt+right', => @_adjust 'Scale X', 0.01
		@kilid.on 'w+ctrl+right', => @_adjust 'Scale X', 0.2

		@kilid.on 'w+left', => @_adjust 'Scale X', -0.1
		@kilid.on 'w+alt+left', => @_adjust 'Scale X', -0.01
		@kilid.on 'w+ctrl+left', => @_adjust 'Scale X', -0.2

		@kilid.on 's+up', =>

			@_adjust 'Scale Y', 0.1
			@_adjust 'Scale X', 0.1

		@kilid.on 's+alt+up', =>

			@_adjust 'Scale Y', 0.01
			@_adjust 'Scale X', 0.01

		@kilid.on 's+ctrl+up', =>

			@_adjust 'Scale Y', 0.2
			@_adjust 'Scale X', 0.2


		@kilid.on 's+down', =>

			@_adjust 'Scale Y', -0.1
			@_adjust 'Scale X', -0.1

		@kilid.on 's+alt+down', =>

			@_adjust 'Scale Y', -0.01
			@_adjust 'Scale X', -0.01

		@kilid.on 's+ctrl+down', =>

			@_adjust 'Scale Y', -0.2
			@_adjust 'Scale X', -0.2


	_setupMoosh: ->

		# movement
		@moosh.onDrag @dash
		.withKeys 'x'
		.onDrag (e) =>

			@_adjust 'X', e.relX
			@_adjust 'Y', e.relY

		@moosh.onClick @dash
		.withKeys 'x'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'X', 0
			@_set 'Y', 0

		@moosh.onDrag @dash
		.withKeys 'x+shift'
		.onDrag (e) =>

			@_adjust 'X', e.relX

		@moosh.onClick @dash
		.withKeys 'x+shift'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'X', 0

		@moosh.onDrag @dash
		.withKeys 'x+alt'
		.onDrag (e) =>

			@_adjust 'Y', e.relY

		@moosh.onClick @dash
		.withKeys 'x+alt'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Y', 0

		@moosh.onDrag @dash
		.withKeys 'z'
		.onDrag (e) =>

			@_adjust 'Z', e.relY

		@moosh.onClick @dash
		.withKeys 'z'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Z', 0

		# rotation
		@moosh.onDrag @dash
		.withKeys 'e'
		.onDrag (e) =>

			@_adjust 'Rotation Z', e.relY

		@moosh.onClick @dash
		.withKeys 'e'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Rotation Z', 0

		@moosh.onDrag @dash
		.withKeys 'q'
		.onDrag (e) =>

			@_adjust 'Rotation Y', e.relX
			@_adjust 'Rotation X', -e.relY

		@moosh.onClick @dash
		.withKeys 'q'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Rotation Y', 0
			@_set 'Rotation X', 0

		@moosh.onDrag @dash
		.withKeys 'q+shift'
		.onDrag (e) =>

			@_adjust 'Rotation Y', e.relX

		@moosh.onClick @dash
		.withKeys 'q+shift'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Rotation Y', 0

		@moosh.onDrag @dash
		.withKeys 'q+alt'
		.onDrag (e) =>

			@_adjust 'Rotation X', -e.relY

		@moosh.onClick @dash
		.withKeys 'q+alt'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Rotation X', 0

		# opacity
		@moosh.onDrag @dash
		.withKeys '`'
		.onDrag (e) =>

			@_adjust 'Opacity', -e.relY / 300

		@moosh.onClick @dash
		.withKeys '`'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Opacity', 1

		# scale
		@moosh.onDrag @dash
		.withKeys 's'
		.onDrag (e) =>

			@_adjust 'Scale X', -e.relY / 100
			@_adjust 'Scale Y', -e.relY / 100

		@moosh.onClick @dash
		.withKeys 's'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Scale X', 1
			@_set 'Scale Y', 1

		@moosh.onDrag @dash
		.withKeys 'w'
		.onDrag (e) =>

			@_adjust 'Scale X',  e.relX / 100
			@_adjust 'Scale Y', -e.relY / 100

		@moosh.onClick @dash
		.withKeys 'w'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Scale X', 1
			@_set 'Scale Y', 1

		@moosh.onDrag @dash
		.withKeys 'w+shift'
		.onDrag (e) =>

			@_adjust 'Scale X',  e.relX / 100

		@moosh.onClick @dash
		.withKeys 'w+shift'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Scale X', 1

		@moosh.onDrag @dash
		.withKeys 'w+alt'
		.onDrag (e) =>

			@_adjust 'Scale Y', -e.relY / 100

		@moosh.onClick @dash
		.withKeys 'w+alt'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Scale Y', 1

		# skew
		@moosh.onDrag @dash
		.withKeys 'r'
		.onDrag (e) =>

			@_adjust 'Skew X',  e.relX / 10
			@_adjust 'Skew Y', -e.relY / 10

		@moosh.onClick @dash
		.withKeys 'r'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Skew X', 0
			@_set 'Skew Y', 0

		# all
		@moosh.onClick @dash
		.withKeys 'f'
		.repeatedBy 2
		.onDone (e) =>

			@_set 'Skew X', 0
			@_set 'Skew Y', 0

			@_set 'Scale X', 1
			@_set 'Scale Y', 1

			@_set 'Rotation X', 0
			@_set 'Rotation Y', 0
			@_set 'Rotation Z', 0

			@_set 'X', 0
			@_set 'Y', 0
			@_set 'Z', 0


	control: (el, actors) ->

		@moosh.onClick el, => @_takeControl el, actors

		setTimeout =>

			@_takeControl el, actors

		, 50

		return

	_takeControl: (el, actors) ->

		do @relinquish

		@el = el

		@actors = actors

		@dash.inside @el

	_adjust: (propName, amount, actorName = 'main') ->

		@__set propName, amount, actorName, yes

	_set: (propName, amount, actorName = 'main') ->

		@__set propName, amount, actorName, no

	__set: (propName, amount, actorName = 'main', adjust) ->

		prop = @actors[actorName].props[propName]

		return unless prop?

		point = prop.timelineProp.pacs.getOrMakePointOnOrInVicinity @timeline.t, 16

		if adjust

			point.setValue point.value + amount

		else

			point.setValue amount

		point.pacs.done()

		@timeline.tick @timeline.t

	relinquish: ->

		return unless @el?

		@dash.detach()

		return

###

`	Opacity

X	Movement X/Y (shift: X, Alt: Y)
Z	Movement Z

Q	Rotation X/Y (shift: X, Alt: Y)
E	Rotation Z

S	Scale Both Synchronized
W	Scale Both Separately

R Skew

###