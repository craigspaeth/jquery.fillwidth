(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  (function($) {
    var Li, Row, debounce, frameWidth, i, methods, options, _defaults;
    _defaults = {
      resizeLandscapesBy: 200,
      resizeRowBy: 15,
      landscapeRatios: (function() {
        var _results;
        _results = [];
        for (i = 10; i <= 50; i++) {
          _results.push(i / 10);
        }
        return _results;
      })()
    };
    options = $.extend(_defaults, options);
    frameWidth = 0;
    Li = (function() {
      function Li(el) {
        this.originalWidth = this.width = $(el).outerWidth();
        this.originalHeight = this.height = $(el).outerHeight();
        this.originalMargin = this.margin = $(el).outerWidth(true) - $(el).outerWidth();
        this.$el = $(el);
      }
      Li.prototype.setHeight = function(h) {
        this.width = h * (this.width / this.height);
        return this.height = h;
      };
      Li.prototype.setWidth = function(w) {
        this.height = w * (this.height / this.width);
        return this.width = w;
      };
      Li.prototype.decWidth = function() {
        return this.setWidth(this.width - 1);
      };
      Li.prototype.decHeight = function() {
        return this.setHeight(this.height - 1);
      };
      Li.prototype.incWidth = function() {
        return this.setWidth(this.width + 1);
      };
      Li.prototype.incHeight = function() {
        return this.setHeight(this.height + 1);
      };
      Li.prototype.updateDOM = function() {
        this.$el.width(this.width);
        return this.$el.css({
          'margin-right': this.margin
        });
      };
      Li.prototype.reset = function() {
        this.width = this.originalWidth;
        this.height = this.originalHeight;
        this.margin = this.originalMargin;
        return this.$el.css({
          "margin-right": this.originalMargin,
          width: 'auto',
          height: 'auto'
        });
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
          width += li.width + li.margin;
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
      Row.prototype.reset = function() {
        var li, _i, _len, _ref, _results;
        _ref = this.lis;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          li = _ref[_i];
          _results.push(li.reset());
        }
        return _results;
      };
      Row.prototype.landscapeGroups = function() {
        var i, landscapeGroups, li, ratio, _ref;
        landscapeGroups = [];
        _ref = options.landscapeRatios;
        for (i in _ref) {
          ratio = _ref[i];
          ratio = options.landscapeRatios[i];
          landscapeGroups.push((function() {
            var _i, _len, _ref2, _results;
            _ref2 = this.lis;
            _results = [];
            for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
              li = _ref2[_i];
              if ((li.width / li.height) >= ratio) {
                _results.push(li);
              }
            }
            return _results;
          }).call(this));
        }
        return landscapeGroups;
      };
      Row.prototype.resizeLandscapes = function() {
        var i, landscapes, li, _i, _j, _len, _len2, _ref, _ref2;
        _ref = this.landscapeGroups();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          landscapes = _ref[_i];
          if (landscapes.length === 0) {
            continue;
          }
          for (i = 1, _ref2 = options.resizeLandscapesBy; 1 <= _ref2 ? i <= _ref2 : i >= _ref2; 1 <= _ref2 ? i++ : i--) {
            for (_j = 0, _len2 = landscapes.length; _j < _len2; _j++) {
              li = landscapes[_j];
              li.decHeight();
            }
            if (this.width() <= frameWidth) {
              break;
            }
          }
          if (this.width() <= frameWidth) {
            break;
          }
        }
        return this;
      };
      Row.prototype.resizeHeight = function() {
        var li, _results;
        i = 0;
        _results = [];
        while (this.width() > frameWidth && i < options.resizeRowBy) {
          i++;
          _results.push((function() {
            var _i, _len, _ref, _results2;
            _ref = this.lis;
            _results2 = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              li = _ref[_i];
              _results2.push(li.decHeight());
            }
            return _results2;
          }).call(this));
        }
        return _results;
      };
      Row.prototype.roundOff = function() {
        var li, _i, _len, _ref, _results;
        _ref = this.lis;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          li = _ref[_i];
          _results.push(li.setWidth(Math.floor(li.width)));
        }
        return _results;
      };
      Row.prototype.fillLeftoverPixels = function() {
        var diff, randIndex, _results;
        this.roundOff();
        diff = __bind(function() {
          return frameWidth - this.width();
        }, this);
        if (diff() > 20) {
          return;
        }
        i = 0;
        _results = [];
        while (diff() > 0) {
          randIndex = Math.round(Math.random() * (this.lis.length - 1));
          this.lis[randIndex].incWidth();
          i++;
          _results.push(this.lis.length - 1 === i ? i = 0 : void 0);
        }
        return _results;
      };
      Row.prototype.removeMargin = function() {
        var lastLi;
        lastLi = this.lis[this.lis.length - 1];
        return lastLi.margin = 0;
      };
      return Row;
    })();
    debounce = function(func, wait) {
      var timeout;
      timeout = 0;
      return function() {
        var args, throttler;
        args = arguments;
        throttler = __bind(function() {
          timeout = null;
          return func(args);
        }, this);
        clearTimeout(timeout);
        return timeout = setTimeout(throttler, wait);
      };
    };
    methods = {
      init: function() {
        options = $.extend(options, arguments[0]);
        return this.each(function() {
          var $imgs, imagesToLoad, initLineup, lineup;
          methods.initStyling.apply($(this));
          lineup = __bind(function() {
            return methods.lineUp.apply(this);
          }, this);
          initLineup = __bind(function() {
            $(window).resize(debounce(lineup, 200));
            lineup();
            return console.log('lined up');
          }, this);
          $imgs = $(this).find('img');
          if ((options.imgTargetHeight != null) && (options.liWidths != null)) {
            initLineup();
            return $imgs.css({
              opacity: 0
            }).load(function() {
              return $(this).height('auto').animate({
                opacity: 1
              });
            });
          } else {
            imagesToLoad = $imgs.length;
            return $imgs.load(function() {
              imagesToLoad--;
              if (imagesToLoad === 0) {
                return initLineup();
              }
            });
          }
        });
      },
      initStyling: function() {
        $(this).css({
          'list-style': 'none',
          padding: 0,
          margin: 0,
          overflow: 'hidden'
        });
        $(this).append("<div class='fillwidth-clearfix' style='clear:both'></div>");
        $(this).children('li').css({
          float: 'left'
        });
        $(this).find('img').css({
          display: 'block',
          'max-width': '100%',
          'max-height': '100%'
        });
        if ((options.imgTargetHeight != null) && (options.liWidths != null)) {
          return $(this).children('li').each(function(i) {
            $(this).find('img').height(options.imgTargetHeight);
            return $(this).width(options.liWidths[i]);
          });
        }
      },
      lineUp: function() {
        var row, _i, _j, _len, _len2, _ref, _ref2;
        if ($(this).data('fillwidth.rows') != null) {
          _ref = $(this).data('fillwidth.rows');
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            row = _ref[_i];
            row.reset();
          }
        }
        $(this).width('auto');
        frameWidth = $(this).width();
        $(this).data('fillwidth.rows', methods.breakUpIntoRows.apply(this));
        _ref2 = $(this).data('fillwidth.rows');
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          row = _ref2[_j];
          row.removeMargin();
          row.resizeHeight();
          row.resizeLandscapes();
          row.fillLeftoverPixels();
          row.updateDOM();
        }
        methods.setRowHeights.apply(this);
        methods.firefoxScrollbarBug.apply(this);
        return setTimeout((function() {
          return $(this).width($(this).width());
        }), 2);
      },
      rows: function() {
        return $(this).data('fillwidth.rows');
      },
      breakUpIntoRows: function() {
        var li, rows, _i, _len, _ref;
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
      setRowHeights: function() {
        return setTimeout((__bind(function() {
          var height, li, row, rows, sortedLis, _i, _len, _results;
          rows = methods.rows.apply(this);
          console.log(rows);
          _results = [];
          for (_i = 0, _len = rows.length; _i < _len; _i++) {
            row = rows[_i];
            sortedLis = row.lis.sort(function(a, b) {
              return b.$el.height() - a.$el.height();
            });
            height = sortedLis[0].$el.height();
            _results.push((function() {
              var _j, _len2, _results2;
              _results2 = [];
              for (_j = 0, _len2 = sortedLis.length; _j < _len2; _j++) {
                li = sortedLis[_j];
                _results2.push(li.$el.height(height));
              }
              return _results2;
            })());
          }
          return _results;
        }, this)), 1);
      },
      firefoxScrollbarBug: function() {
        if (!$.browser.mozilla) {
          return;
        }
        return setTimeout((function() {
          var $lastLi, diff, i, index, randomRow, row, rows, _i, _len, _ref, _results;
          rows = methods.rows.apply(this);
          if (rows == null) {
            return;
          }
          _ref = rows.slice(0, (rows.length - 2 + 1) || 9e9);
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            row = _ref[_i];
            $lastLi = row.lis[row.lis.length - 1].$el;
            diff = $(this).width() - ($lastLi.outerWidth(true) + $lastLi.position().left);
            _results.push((function() {
              if (diff === 24) {
                for (i = 1; i <= 15; i++) {
                  index = Math.round(Math.random() * (row.lis.length - 1));
                  randomRow = row.lis[index];
                  randomRow.incWidth();
                }
                return row.updateDOM();
              }
            })());
          }
          return _results;
        }), 1);
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
