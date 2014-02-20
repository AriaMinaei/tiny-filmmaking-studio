module.exports = class HallowText

	constructor: (@el, @_samples = 1) ->

		@el.set 'hallow-text', @

		@_baseRadius = 0

		@_maxMotionRadius = 10

		@_currentMotionRadius = 0

		@_colorPrepend = ""

		@_color = new Uint8Array 3

		@_velocity = new Float32Array 2

		@setColor 255, 255, 255

	setSamples: (n) ->

		@_samples = n|0

		return

	setColor: (r, g, b) ->

		@_color[0] = r
		@_color[1] = g
		@_color[2] = b

		@el._style.color = "rgba(#{@_color[0]}, #{@_color[1]}, #{@_color[2]}, 0)"

		@_colorPrepend = "rgba(#{@_color[0]}, #{@_color[1]}, #{@_color[2]}, "

		do @_apply

	setBaseRadius: (b) ->

		@_baseRadius = +b

		do @_apply

	setMaxMotionRadius: (b) ->

		@_maxMotionRadius = +b

		do @_apply

	setVelocityX: (amount) ->

		@_velocity[0] = - amount

		vel = Math.sqrt(Math.pow(@_velocity[0], 2) + Math.pow(@_velocity[1], 2))

		@_currentMotionRadius = Math.min(vel, @_maxMotionRadius / 1.5)

		do @_apply

	setVelocityY: (amount) ->

		@_velocity[1] = - amount

		vel = Math.sqrt(Math.pow(@_velocity[0], 2) + Math.pow(@_velocity[1], 2))

		@_currentMotionRadius = Math.min(vel, @_maxMotionRadius / 1.5)

		do @_apply

	_apply: ->

		shadow = ""

		for i in [0...@_samples]

			prog = i / @_samples

			if i isnt 0 then shadow += ", "

			opacityProg = (0.1 + prog * 0.9)

			opacityProg = Math.sin opacityProg * Math.PI / 2

			opacity = 1.0 - opacityProg

			prog = 1 - Math.cos prog * Math.PI / 2

			shadow += "#{@_colorPrepend} #{opacity})

				#{prog * @_velocity[0]}px

				#{prog * @_velocity[1]}px

				#{(@_baseRadius + @_currentMotionRadius)}px"

		@el._style.textShadow = shadow