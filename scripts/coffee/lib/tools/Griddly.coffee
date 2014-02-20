Gila = require 'gila'
object = require 'utila/scripts/js/lib/object'

module.exports = class Griddly

	constructor: (options) ->

		@_url = null

		@options = self.getDefaultOptions()

		object.overrideOnto @options, options

		do @_draw

	_draw: ->

		canvas = document.createElement 'canvas'
		canvas.width = @options.width
		canvas.height = @options.height

		@gila = new Gila canvas, yes

		@gila.setClearColor 0, 0, 0, 0
		@gila.clear()



		vert = @gila.getVertexShader 'v', vertSource

		frag = @gila.getFragmentShader 'f', fragSource

		@program = @gila.getProgram vert, frag

		@gila.blending.enable()

		@gila.blend
		.src.srcAlpha()
		.dst.oneMinusSrcAlpha()
		.update()

		@program.activate()

		@gila.makeArrayBuffer().staticData rectangleVx

		@program.attr('vx').enable().readAsFloat 2, no, 8, 0

		@program.uniform('2f', 'dims').set @options.width, @options.height
		@program.uniform('4f', 'color').fromArray new Float32Array @options.color

		do @_drawGrids

		@_url = @gila.canvas.toDataURL()

	_drawGrids: ->

		do @_drawHorizontalGrid

		do @_drawVerticalGrid

	_drawHorizontalGrid: ->

		@program.uniform('1i', 'direction').set 1

		@_drawLines @options.horizontalSpacing

	_drawVerticalGrid: ->

		@program.uniform('1i', 'direction').set 0

		@_drawLines @options.verticalSpacing

	_drawLines: (str) ->

		stride = 0

		offset = 0

		lines = []

		for num in str.split(/\s+/)

			num = parseInt num

			offset += num

			lines.push offset

		stride = offset

		@program.uniform('1f', 'stride').set stride

		for offset in lines

			@program.uniform('1f', 'offset').set offset

			@gila.drawTriangles 0, 6

		return

	getUrl: ->

		@_url

	applyTo: (el) ->

		el.css 'background-image', 'url(' + @getUrl() + '), ' + el.computedStyle('background-image')

		@

	@getDefaultOptions: ->

		{
			width: 0
			height: 0

			horizontalSpacing: '10 30'
			verticalSpacing: '10 50'

			color: [1, 1, 1, 1]
		}

	self = @

rectangleVx = new Float32Array [
	-1, -1,
	-1,  1,
	 1, -1,

	 1, -1,
	-1,  1,
	 1,  1
]

vertSource = """
	attribute vec2 vx;
	varying vec2 vTexCoord;

	void main() {
		gl_Position = vec4(vx, 0.0, 1.0);
		vTexCoord = vx / 2.0 + 0.5;
	}
"""

fragSource = """
	precision highp float;

	varying vec2 vTexCoord;

	uniform vec2 dims;

	uniform int direction;
	const int HORIZONTAL = int(0);
	const int VERTICAL = int(1);

	uniform float stride;
	uniform float offset;

	uniform vec4 color;

	void main() {

		float pos, curOffset;

		if (direction == VERTICAL) {
			pos = dims.x * vTexCoord.x;

			curOffset = mod(pos, stride);

		} else {

			pos = dims.y * (1.0 - vTexCoord.y);

			curOffset = mod(pos, stride);
		}

		if (curOffset >= (offset - 1.0) && curOffset <= offset) {
			gl_FragColor = color;
		}

	}

"""