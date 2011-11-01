(function() {
  (function($) {
    var Li, Row, currentRows, frameWidth, methods, options, _defaults;
    _defaults = {
      callback: null,
      resizeLandscapesBy: 95,
      landscapeRatios: [3, 2, 1.5, 1.25, 1]
    };
    options = $.extend(_defaults, options);
    frameWidth = 0;
    currentRows = [];
    Li = (function() {
      function Li(el) {
        this.width = $(el).outerWidth();
        this.height = $(el).outerHeight(true);
        this.margin = $(el).outerWidth(true) - $(el).outerWidth();
        this.$el = $(el);
      }
      Li.prototype.setHeight = function(h) {
        this.width = Math.floor(h * (this.width / this.height));
        return this.height = h;
      };
      Li.prototype.setWidth = function(w) {
        this.height = Math.floor(w * (this.height / this.width));
        return this.width = w;
      };
      Li.prototype.decWidth = function() {
        return this.setWidth(this.width - 1);
      };
      Li.prototype.decHeight = function() {
        return this.setHeight(this.height - 1);
      };
      Li.prototype.updateDOM = function() {
        this.$el.width(this.width);
        return this.$el.height(this.height);
      };
      return Li;
    })();
    Row = (function() {
      function Row(lis) {
        var _ref;
        this.lis = lis;
        if ((_ref = this.lis) == null) {
          this.lis = [];
        }
      }
      Row.prototype.width = function() {
        var li, width, _i, _len, _ref;
        width = 0;
        _ref = this.lis;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          li = _ref[_i];
          width += li.width;
        }
        return width;
      };
      Row.prototype.updateDOM = function() {
        var li, _i, _len, _ref, _results;
        _ref = this.lis;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          li = _ref[_i];
          _results.push(li.updateDOM());
        }
        return _results;
      };
      return Row;
    })();
    methods = {
      init: function() {
        return this.each(function() {
          methods.initialStyling.apply(this);
          return methods.lineUp.apply(this);
        });
      },
      initialStyling: function() {
        $(this).css({
          'list-style': 'none',
          padding: 0,
          margin: 0
        });
        $(this).children('li').css({
          float: 'left'
        });
        return $(this).children('li').children('img').css({
          display: 'block',
          'max-width': '100%'
        });
      },
      lineUp: function() {
        var row, _i, _j, _len, _len2, _results;
        frameWidth = $(this).width();
        currentRows = methods.breakUpIntoRows.apply(this);
        for (_i = 0, _len = currentRows.length; _i < _len; _i++) {
          row = currentRows[_i];
          methods.removeMargin(row);
          methods.resizeLandscapes(row);
        }
        _results = [];
        for (_j = 0, _len2 = currentRows.length; _j < _len2; _j++) {
          row = currentRows[_j];
          methods.setRowHeight(row);
          methods.considerMargins(row);
          _results.push(row.updateDOM());
        }
        return _results;
      },
      breakUpIntoRows: function() {
        var i, li, rows, _i, _len, _ref;
        i = 0;
        rows = [new Row()];
        _ref = $(this).children('li');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          li = _ref[_i];
          rows[i].lis.push(new Li(li));
          if (rows[i].width() >= $(this).width() && _i !== $(this).children('li').length - 1) {
            rows.push(new Row());
            i++;
          }
        }
        return rows;
      },
      setRowHeight: function(row) {
        var height, li, sortedLis, unsortedLis, _i, _len, _results;
        unsortedLis = (function() {
          var _i, _len, _ref, _results;
          _ref = row.lis;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            li = _ref[_i];
            _results.push(li);
          }
          return _results;
        })();
        sortedLis = unsortedLis.sort(function(a, b) {
          return b.height - a.height;
        });
        height = sortedLis[0].height;
        _results = [];
        for (_i = 0, _len = sortedLis.length; _i < _len; _i++) {
          li = sortedLis[_i];
          _results.push(li.height = height);
        }
        return _results;
      },
      considerMargins: function(row) {
        var li, _i, _len, _ref, _results;
        _ref = row.lis;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          li = _ref[_i];
          _results.push(li.setWidth(li.width - li.margin));
        }
        return _results;
      },
      removeMargin: function(row) {
        var lastLi;
        lastLi = row.lis[row.lis.length - 1];
        lastLi.margin = 0;
        return lastLi.$el.css({
          "margin-right": 0
        });
      },
      resizeLandscapes: function(row) {
        var i, landscapes, li, ratio, _i, _j, _len, _len2, _ref, _ref2;
        _ref = options.landscapeRatios;
        for (i in _ref) {
          ratio = _ref[i];
          ratio = options.landscapeRatios[i];
          landscapes = (function() {
            var _i, _len, _ref2, _results;
            _ref2 = row.lis;
            _results = [];
            for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
              li = _ref2[_i];
              if ((li.width / li.height) >= ratio) {
                _results.push(li);
              }
            }
            return _results;
          })();
          if (landscapes.length === 0) {
            continue;
          }
          for (i = 1, _ref2 = options.resizeLandscapesBy; 1 <= _ref2 ? i <= _ref2 : i >= _ref2; 1 <= _ref2 ? i++ : i--) {
            for (_i = 0, _len = landscapes.length; _i < _len; _i++) {
              li = landscapes[_i];
              li.decHeight();
            }
            if (row.width() <= frameWidth) {
              break;
            }
          }
          if (row.width() <= frameWidth) {
            break;
          }
        }
        for (_j = 0, _len2 = row.length; _j < _len2; _j++) {
          li = row[_j];
          li.updateWidth();
        }
        return row;
      }
    };
    return $.fn.fillwidth = function(method) {
      if (methods[method] != null) {
        return methods[method].apply(this, Array.prototype.slice.call(arguments).slice(1, (arguments.length + 1) || 9e9));
      } else if (typeof method === "object" || !(method != null)) {
        return methods.init.apply(this, arguments);
      } else {
        return $.error("Method " + method + " does not exist on jQuery.fillwidth");
      }
    };
  })(jQuery);
}).call(this);
