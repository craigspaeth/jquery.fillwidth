(function() {
  var $, Li, Row, callQueue, debounce, methods, totalPlugins;

  $ = jQuery;

  totalPlugins = 0;

  callQueue = [];

  Li = (function() {

    function Li(el, settings) {
      var $el, $img;
      $el = $(el);
      this.originalWidth = this.width = $el.outerWidth(false);
      this.originalHeight = this.height = $el.height();
      this.originalMargin = this.margin = $el.outerWidth(true) - $el.outerWidth(false);
      $img = $el.find('img');
      this.imgRatio = $img.width() / $img.height();
      this.$el = $el;
      this.settings = settings;
    }

    Li.prototype.setHeight = function(h) {
      this.width = Math.round(h * (this.width / this.height));
      if (!this.settings.lockedHeight) {
        return this.height = h;
      }
    };

    Li.prototype.setWidth = function(w) {
      this.height = Math.round(w * (this.height / this.width));
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
      return this.$el.css({
        width: this.width,
        height: this.height,
        'margin-right': this.margin
      });
    };

    Li.prototype.reset = function() {
      this.width = this.originalWidth;
      this.height = this.originalHeight;
      this.margin = this.originalMargin;
      return this.$el.css({
        width: this.width,
        height: this.height,
        'margin-right': this.margin
      });
    };

    return Li;

  })();

  Row = (function() {

    function Row(frameWidth, settings) {
      this.frameWidth = frameWidth;
      this.settings = settings;
      this.lis = [];
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
      var i, landscapeGroups, landscapes, li, ratio, _ref;
      landscapeGroups = [];
      _ref = this.settings.landscapeRatios;
      for (i in _ref) {
        ratio = _ref[i];
        landscapes = (function() {
          var _i, _len, _ref1, _results;
          _ref1 = this.lis;
          _results = [];
          for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
            li = _ref1[_i];
            if (li.imgRatio >= ratio) {
              _results.push(li);
            }
          }
          return _results;
        }).call(this);
        landscapeGroups.push(landscapes);
      }
      return landscapeGroups;
    };

    Row.prototype.resizeLandscapes = function() {
      var i, landscapes, li, _i, _j, _k, _len, _len1, _ref, _ref1;
      _ref = this.landscapeGroups(this.settings.landscapeRatios);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        landscapes = _ref[_i];
        if (!(landscapes.length !== 0)) {
          continue;
        }
        for (i = _j = 0, _ref1 = this.settings.resizeLandscapesBy; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          for (_k = 0, _len1 = landscapes.length; _k < _len1; _k++) {
            li = landscapes[_k];
            li.decHeight();
          }
          if (this.width() <= this.frameWidth) {
            break;
          }
        }
        if (this.width() <= this.frameWidth) {
          break;
        }
      }
      return this;
    };

    Row.prototype.adjustMargins = function() {
      var i, li, _i, _j, _len, _ref, _ref1, _results;
      _results = [];
      for (i = _i = 0, _ref = this.settings.adjustMarginsBy; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        _ref1 = this.lis.slice(0, +(this.lis.length - 2) + 1 || 9e9);
        for (_j = 0, _len = _ref1.length; _j < _len; _j++) {
          li = _ref1[_j];
          li.margin--;
          if (this.width() <= this.frameWidth) {
            break;
          }
        }
        if (this.width() <= this.frameWidth) {
          break;
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Row.prototype.resizeHeight = function() {
      var i, li, _results;
      i = 0;
      _results = [];
      while (this.width() > this.frameWidth && i < this.settings.resizeRowBy) {
        i++;
        _results.push((function() {
          var _i, _len, _ref, _results1;
          _ref = this.lis;
          _results1 = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            li = _ref[_i];
            _results1.push(li.decHeight());
          }
          return _results1;
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
      var diff, randIndex, _results,
        _this = this;
      this.roundOff();
      diff = function() {
        return _this.frameWidth - _this.width();
      };
      _results = [];
      while (diff() !== 0) {
        randIndex = Math.round(Math.random() * (this.lis.length - 1));
        if (diff() < 0) {
          _results.push(this.lis[randIndex].decWidth());
        } else {
          _results.push(this.lis[randIndex].incWidth());
        }
      }
      return _results;
    };

    Row.prototype.removeMargin = function() {
      var lastLi;
      lastLi = this.lis[this.lis.length - 1];
      return lastLi.margin = 0;
    };

    Row.prototype.lockHeight = function() {
      var li, tallestHeight, tallestLi, _i, _len, _ref, _results;
      tallestLi = (this.lis.sort(function(a, b) {
        return b.height - a.height;
      }))[0];
      tallestHeight = Math.ceil(tallestLi.height);
      _ref = this.lis;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        li = _ref[_i];
        _results.push(li.height = tallestHeight);
      }
      return _results;
    };

    Row.prototype.hide = function() {
      var li, _i, _len, _ref, _results;
      _ref = this.lis;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        li = _ref[_i];
        _results.push(li.$el.hide());
      }
      return _results;
    };

    Row.prototype.show = function() {
      var li, _i, _len, _ref, _results;
      _ref = this.lis;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        li = _ref[_i];
        _results.push(li.$el.show());
      }
      return _results;
    };

    return Row;

  })();

  debounce = function(func, wait) {
    var timeout;
    timeout = 0;
    return function() {
      var args, throttler,
        _this = this;
      args = arguments;
      throttler = function() {
        timeout = null;
        return func(args);
      };
      clearTimeout(timeout);
      return timeout = setTimeout(throttler, wait);
    };
  };

  methods = {
    init: function(settings) {
      var i, _defaults,
        _this = this;
      _defaults = {
        resizeLandscapesBy: 200,
        resizeRowBy: 30,
        landscapeRatios: ((function() {
          var _i, _results;
          _results = [];
          for (i = _i = 10; _i <= 50; i = _i += 3) {
            _results.push(i / 10);
          }
          return _results;
        })()).reverse(),
        fillLastRow: false,
        beforeFillWidth: null,
        afterFillWidth: null
      };
      this.settings = $.extend(_defaults, settings);
      return this.each(function(i, el) {
        var $el, $imgs, imagesToLoad, initFillWidth;
        $el = $(el);
        methods.initStyling.call(_this, $el);
        initFillWidth = function() {
          methods.fillWidth.call(_this, $el);
          if (!(navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPad/i) || navigator.userAgent.match(/iPod/i) || ($.browser.msie && $.browser.version === "8.0"))) {
            $(window).bind('resize.fillwidth', debounce((function() {
              var fn, _i, _len;
              callQueue.push((function() {
                return methods.fillWidth.call(_this, $el);
              }));
              if (callQueue.length === totalPlugins) {
                for (_i = 0, _len = callQueue.length; _i < _len; _i++) {
                  fn = callQueue[_i];
                  fn();
                }
                return callQueue = [];
              }
            }), 300));
          }
          return totalPlugins++;
        };
        $imgs = $el.find('img');
        if (_this.settings.liWidths != null) {
          initFillWidth();
          return $imgs.load(function() {
            return $(this).height('auto');
          });
        } else {
          imagesToLoad = $imgs.length;
          return $imgs.load(function() {
            imagesToLoad--;
            if (imagesToLoad === 0) {
              return initFillWidth();
            }
          });
        }
      });
    },
    initStyling: function(el) {
      var $el,
        _this = this;
      $el = $(el);
      $el.css({
        'list-style': 'none',
        padding: 0,
        margin: 0,
        overflow: 'hidden'
      });
      if (this.settings.initStyling != null) {
        $el.css(this.settings.initStyling);
      }
      $el.children('li').css({
        'float': 'left',
        'margin-left': 0
      });
      $el.find('*').css({
        'max-width': '100%',
        'max-height': '100%'
      });
      if (this.settings && (this.settings.liWidths != null)) {
        return $el.children('li').each(function(i, el) {
          return $(el).width(_this.settings.liWidths[i]);
        });
      }
    },
    destroy: function() {
      $(window).unbind('resize.fillwidth');
      return this.each(function() {
        var row, _i, _len, _ref;
        _ref = $(this).fillwidth('rowObjs');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          row = _ref[_i];
          row.reset();
        }
        return $(this).removeData('fillwidth.rows');
      });
    },
    fillWidth: function(el) {
      var $el, row, rows, _i, _j, _len, _len1, _ref;
      $el = $(el);
      $el.trigger('fillwidth.beforeFillWidth');
      if (this.settings.beforeFillWidth != null) {
        this.settings.beforeFillWidth();
      }
      if (this.fillwidthRows) {
        _ref = this.fillwidthRows;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          row = _ref[_i];
          row.reset();
        }
      }
      $el.width('auto');
      $el.trigger('fillwidth.beforeNewRows');
      if (this.settings.beforeNewRows != null) {
        this.settings.beforeNewRows();
      }
      this.frameWidth = $el.width();
      rows = methods.breakUpIntoRows.call(this, $el);
      this.fillwidthRows = rows;
      $el.width(this.frameWidth);
      $el.trigger('fillwidth.afterNewRows');
      if (this.settings.afterNewRows != null) {
        this.settings.afterNewRows();
      }
      for (_j = 0, _len1 = rows.length; _j < _len1; _j++) {
        row = rows[_j];
        if (!(row.lis.length > 1)) {
          continue;
        }
        row.removeMargin();
        row.resizeHeight();
        if (this.settings.adjustMarginsBy != null) {
          row.adjustMargins();
        }
        row.resizeLandscapes();
        if (!(row === rows[rows.length - 1] && !this.settings.fillLastRow)) {
          row.fillLeftoverPixels();
        }
        row.lockHeight();
        row.updateDOM();
      }
      $el.trigger('fillwidth.afterFillWidth');
      if (this.settings.afterFillWidth != null) {
        return this.settings.afterFillWidth();
      }
    },
    rowObjs: function() {
      var arr, rows;
      arr = [];
      rows = this.fillwidthRows;
      this.each(function() {
        return arr.push(rows);
      });
      if (arr.length === 1) {
        arr = arr[0];
      }
      return arr;
    },
    rows: function() {
      var arr, li, row, rows, _i, _len;
      rows = methods.rowObjs.call(this);
      arr = [];
      for (_i = 0, _len = rows.length; _i < _len; _i++) {
        row = rows[_i];
        arr.push((function() {
          var _j, _len1, _ref, _results;
          _ref = row.lis;
          _results = [];
          for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
            li = _ref[_j];
            _results.push(li.$el);
          }
          return _results;
        })());
      }
      if (arr.length === 1) {
        arr = arr[0];
      }
      return arr;
    },
    breakUpIntoRows: function(el) {
      var $el, i, rows,
        _this = this;
      $el = $(el);
      i = 0;
      rows = [new Row(this.frameWidth, this.settings)];
      $el.children('li').each(function(j, li) {
        if ($(li).is(':hidden')) {
          return;
        }
        rows[i].lis.push(new Li(li, _this.settings));
        if (rows[i].width() >= $el.width() && j !== $el.children('li').length - 1) {
          rows.push(new Row(_this.frameWidth, _this.settings));
          return i++;
        }
      });
      return rows;
    }
  };

  $.fn.fillwidth = function(method) {
    if (methods[method] != null) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === "object" || !(method != null)) {
      return methods.init.apply(this, arguments);
    } else {
      return $.error("Method " + method + " does not exist on jQuery.fillwidth");
    }
  };

}).call(this);
