EditingFilm = require('tiny-filmmaking-studio').EditingFilm
setupBigBlackHorse = require './lanes/bigBlackHorse'

film = new EditingFilm

	id: 'template'

	lane: 'bigBlackHorse'

	pass: 'qwerty'

	aspectRatio: 1.85

	port: 6543

setupBigBlackHorse film

film.run()