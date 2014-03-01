module.exports = class ShyText

	constructor: (parent) ->

		@_parent = parent.node

		do @_prepareElements

	_prepareThenReturnChars: ->

		dims = @_parent.getBoundingClientRect()
		chars = @_parent.innerHTML.replace(/^\s+/, '').replace(/\s+$/, '').replace(/\s+/g, ' ')

		@_count = chars.length
		@_lefts = new Float32Array(@_count + 3)

		@_left = 0
		@_right = 0
		@_topOffset = dims.height
		@_lefts[1] = dims.left

		@_parent.innerHTML = null

		chars

	_prepareElements: () ->

		chars = do @_prepareThenReturnChars

		for c, i in chars

			if c is ' ' then c = '&nbsp;'

			@_lefts[i + 2] = @_lefts[i + 1] + @_createEl(c, i + 1).getBoundingClientRect().width

		return

	_createEl: (text, index) ->

		el = @_parent.appendChild(document.createElement('div'))

		el.innerHTML = text

		el.style.position = 'absolute'

		el.style.left = @_lefts[index] + 'px'

		el

	showFrom: (from) ->

		int = Math.floor(from)
		fract = from%1

		@_left = @_lefts[int] * (1 - fract) + (fract) * @_lefts[int + 1]

		do @_update

		@

	showTo: (to) ->

		int = Math.floor(to) + 1
		fract = to%1

		@_right = @_lefts[int] * (1 - fract) + (fract) * @_lefts[int + 1]

		do @_update

		@

	_update: ->

		@_parent.style.clip = "rect(0 #{@_right}px #{@_topOffset}px #{@_left}px)"

		return
