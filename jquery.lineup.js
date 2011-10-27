(function() {
  (function($) {
    var currentRows, frameWidth, methods, options, _defaults;
    _defaults = {
      shuffle: false,
      resizeRowBy: 15,
      resizeLandscapesBy: 95,
      landscapeRatios: [3, 2, 1.5, 1.25, 1],
      adjustMarginsBy: 15,
      callback: null
    };
    options = $.extend(_defaults, options);
    frameWidth = 0;
    currentRows = [];
    methods = {
      init: function() {
        return this.each(function() {
          $(this).find('img').css({
            'max-width': '100%',
            'max-height': '100%',
            display: 'block',
            'height': 'auto'
          });
          return methods.lineUp($(this));
        });
      },
      rows: function() {
        var row, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = currentRows.length; _i < _len; _i++) {
          row = currentRows[_i];
          _results.push(_.pluck(row, 'el'));
        }
        return _results;
      },
      lineUp: function($el) {
        var row, _i, _len, _results;
        frameWidth = $el.width();
        currentRows = methods.breakUpIntoRows.apply($el);
        _results = [];
        for (_i = 0, _len = currentRows.length; _i < _len; _i++) {
          row = currentRows[_i];
          methods.resizeRowHeight.apply($el, [row]);
          if (methods.rowWidth(row) <= frameWidth) {
            continue;
          }
          methods.resizeLandscapes.apply($el, [row]);
          if (methods.rowWidth(row) <= frameWidth) {
            continue;
          }
        }
        return _results;
      },
      resizeLandscapes: function(row) {
        var i, landscapes, li, ratio, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _results;
        _ref = options.landscapeRatios;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          ratio = _ref[_i];
          landscapes = _.select(row, function(li) {
            var _ref2, _ref3;
            return (((_ref3 = options.landscapeRatios[_i - 1]) != null ? _ref3 : 9999) >= (_ref2 = li.width / li.height) && _ref2 > ratio);
          });
          if (landscapes.length === 0) {
            continue;
          }
          for (i = 1, _ref2 = options.resizeLandscapesBy; 1 <= _ref2 ? i <= _ref2 : i >= _ref2; 1 <= _ref2 ? i++ : i--) {
            for (_j = 0, _len2 = landscapes.length; _j < _len2; _j++) {
              li = landscapes[_j];
              li.decHeight();
            }
            if (methods.rowWidth(row) <= frameWidth) {
              break;
            }
          }
          if (methods.rowWidth(row) <= frameWidth) {
            break;
          }
        }
        _results = [];
        for (_k = 0, _len3 = row.length; _k < _len3; _k++) {
          li = row[_k];
          _results.push(li.updateWidth());
        }
        return _results;
      },
      resizeRowHeight: function(row) {
        var i, li, _i, _j, _len, _len2, _ref, _results;
        for (i = 0, _ref = options.resizeRowBy; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
          for (_i = 0, _len = row.length; _i < _len; _i++) {
            li = row[_i];
            li.decHeight();
            if (methods.rowWidth(row) <= frameWidth) {
              break;
            }
          }
        }
        _results = [];
        for (_j = 0, _len2 = row.length; _j < _len2; _j++) {
          li = row[_j];
          _results.push(li.updateWidth());
        }
        return _results;
      },
      breakUpIntoRows: function() {
        var i, lastLi, li, rows, _i, _len, _ref;
        rows = [[]];
        i = 0;
        _ref = this.children('li');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          li = _ref[_i];
          rows[i].push({
            width: $(li).outerWidth(true),
            height: $(li).height(),
            margin: $(li).outerWidth(true) - $(li).outerWidth(false),
            el: $(li),
            setHeight: function(h) {
              this.width = Math.ceil(h * (this.width / this.height));
              return this.height = h;
            },
            setWidth: function(w) {
              this.height = Math.ceil(w * (this.height / this.width));
              return this.width = w;
            },
            decWidth: function() {
              return this.setWidth(this.width - 1);
            },
            decHeight: function() {
              return this.setHeight(this.height - 1);
            },
            updateWidth: function() {
              return this.el.width(this.width - this.margin);
            },
            updateHeight: function() {
              return this.el.height(this.height);
            }
          });
          if (methods.rowWidth(rows[i]) > this.width()) {
            lastLi = rows[i][rows[i].length - 1];
            lastLi.width -= lastLi.margin;
            lastLi.margin = 0;
            i++;
            rows[i] = [];
            $(li).css({
              'margin-right': '0px'
            });
          }
        }
        return rows;
      },
      rowWidth: function(row) {
        return _.reduce(_.pluck(row, 'width'), (function(memo, num) {
          return memo + num;
        }), 0);
      }
    };
    return $.fn.fillwidth = function(method) {
      if (methods[method] != null) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
      } else if (typeof method === "object" || !(method != null)) {
        return methods.init.apply(this, arguments);
      } else {
        return $.error("Method " + method + " does not exist on jQuery.fillwidth");
      }
    };
  })(jQuery);
}).call(this);
