var OpeningTitlesSet;

OpeningTitlesSet = require('../sets/OpeningTitlesSet');

module.exports = function(film) {
  return film.addSet(new OpeningTitlesSet(film));
};
