var OpeningTitlesSet, Set,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Set = require('tiny-filmmaking-studio').Set;

module.exports = OpeningTitlesSet = (function(_super) {
  __extends(OpeningTitlesSet, _super);

  function OpeningTitlesSet() {
    var aact, bigBlackHorse, container, greyBg;
    OpeningTitlesSet.__super__.constructor.apply(this, arguments);
    this.id = 'openingTitles';
    greyBg = this._makeEl('#openingTitles-greyBg.bg').inside(this.film.display.bgLayer);
    container = this._makeEl('#openingTitles-container.container').inside(this.film.display.stageEl);
    bigBlackHorse = this._makeEl('.title').inside(container).html('Big Black Horse').css({
      fontSize: 72
    });
    this._setupDomEl('Opening Titles', 'Big Black Horse', bigBlackHorse, ['translation', 'rotation', 'opacity', 'scale', 'skew', 'wysihwyg']);
    aact = this._makeEl('.title').inside(container).html('And A Cherry Tree').css({
      fontSize: 36
    });
    this._setupDomEl('Opening Titles', 'And a Cherry Tree', aact, ['translation', 'rotation', 'opacity', 'scale', 'skew', 'wysihwyg']);
  }

  return OpeningTitlesSet;

})(Set);
