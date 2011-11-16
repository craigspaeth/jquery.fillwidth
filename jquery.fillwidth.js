(function() {
  var $, Li, Row, debounce, methods;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  $ = jQuery;
  Li = (function() {
    function Li(el) {
      var $img;
      this.originalWidth = this.width = $(el).outerWidth();
      this.originalHeight = this.height = $(el).outerHeight();
      this.originalMargin = this.margin = $(el).outerWidth(true) - $(el).outerWidth();
      $img = $(el).find('img');
      this.imgRatio = $img.width() / $img.height();
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
      this.$el.height(this.height);
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
        width: this.originalWidth,
        height: this.height
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
          var _i, _len, _ref2, _results;
          _ref2 = this.lis;
          _results = [];
          for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
            li = _ref2[_i];
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
      var i, landscapes, li, _i, _j, _len, _len2, _ref, _ref2;
      _ref = this.landscapeGroups(this.settings.landscapeRatios);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        landscapes = _ref[_i];
        if (landscapes.length !== 0) {
          for (i = 0, _ref2 = this.settings.resizeLandscapesBy; 0 <= _ref2 ? i <= _ref2 : i >= _ref2; 0 <= _ref2 ? i++ : i--) {
            for (_j = 0, _len2 = landscapes.length; _j < _len2; _j++) {
              li = landscapes[_j];
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
      }
      return this;
    };
    Row.prototype.adjustMargins = function() {
      var i, li, _i, _len, _ref, _ref2, _results;
      _results = [];
      for (i = 0, _ref = this.settings.adjustMarginsBy; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        _ref2 = this.lis.slice(0, (this.lis.length - 2 + 1) || 9e9);
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          li = _ref2[_i];
          li.margin--;
          if (this.width() <= this.frameWidth) {
            break;
          }
        }
        if (this.width() <= this.frameWidth) {
          break;
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
        return this.frameWidth - this.width();
      }, this);
      _results = [];
      while (diff() !== 0) {
        randIndex = Math.round(Math.random() * (this.lis.length - 1));
        _results.push(diff() < 0 ? this.lis[randIndex].decWidth() : this.lis[randIndex].incWidth());
      }
      return _results;
    };
    Row.prototype.removeMargin = function() {
      var lastLi;
      lastLi = this.lis[this.lis.length - 1];
      return lastLi.margin = 0;
    };
    Row.prototype.lockHeight = function() {
      var li, tallestHeight, _i, _len, _ref, _results;
      tallestHeight = Math.floor((this.lis.sort(function(a, b) {
        return b.height - a.height;
      }))[0].height);
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
    init: function(settings) {
      var i, _defaults;
      _defaults = {
        resizeLandscapesBy: 200,
        resizeRowBy: 15,
        landscapeRatios: ((function() {
          var _results;
          _results = [];
          for (i = 10; i <= 50; i += 3) {
            _results.push(i / 10);
          }
          return _results;
        })()).reverse(),
        fillLastRow: false,
        beforeFillWidth: null,
        afterFillWidth: null
      };
      this.settings = $.extend(_defaults, settings);
      return this.each(__bind(function(i, el) {
        var $imgs, imagesToLoad, initFillWidth;
        methods.initStyling.call(this, el);
        initFillWidth = __bind(function() {
          var fillWidth;
          fillWidth = __bind(function() {
            return methods.fillWidth.call(this, el);
          }, this);
          fillWidth();
          return $(window).bind('resize.fillwidth', debounce(fillWidth, 300));
        }, this);
        $imgs = $(el).find('img');
        if (this.settings.liWidths != null) {
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
      }, this));
    },
    initStyling: function(el) {
      $(el).css({
        'list-style': 'none',
        padding: 0,
        margin: 0,
        overflow: 'hidden'
      });
      if (this.settings.initStyling != null) {
        $(el).css(this.settings.initStyling);
      }
      $(el).children('li').css({
        'float': 'left',
        'margin-left': 0
      });
      $(el).find('*').css({
        'max-width': '100%',
        'max-height': '100%'
      });
      if (this.settings && (this.settings.liWidths != null)) {
        return $(el).children('li').each(__bind(function(i, el) {
          return $(el).width(this.settings.liWidths[i]);
        }, this));
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
      var margin, max, min, row, rows, width, _i, _j, _len, _len2, _ref, _ref2, _ref3;
      if (this.settings.beforeFillWidth != null) {
        this.settings.beforeFillWidth();
      }
      if ($(el).data('fillwidth.rows') != null) {
        _ref = $(el).data('fillwidth.rows');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          row = _ref[_i];
          row.reset();
        }
      }
      $(el).width('auto');
      if (this.settings.marginBreakPoints != null) {
        _ref2 = this.settings.marginBreakPoints;
        for (width in _ref2) {
          margin = _ref2[width];
          min = parseInt(width.split('-')[0]);
          max = parseInt(width.split('-')[1]);
          if ((min < (_ref3 = $(window).width()) && _ref3 < max)) {
            $(el).children().each(function() {
              return $(this).css({
                'margin-right': margin
              });
            });
          }
        }
      }
      this.frameWidth = $(el).width();
      rows = methods.breakUpIntoRows.call(this, el);
      $(el).data('fillwidth.rows', rows);
      $(el).width(this.frameWidth);
      for (_j = 0, _len2 = rows.length; _j < _len2; _j++) {
        row = rows[_j];
        row.removeMargin();
        row.resizeHeight();
        if (this.settings.adjustMarginsBy) {
          row.adjustMargins();
        }
        row.resizeLandscapes();
        if (!(row === rows[rows.length - 1] && !this.settings.fillLastRow)) {
          row.fillLeftoverPixels();
        }
        row.lockHeight();
        row.updateDOM();
      }
      methods.firefoxScrollbarBug.call(this, el);
      if (this.settings.afterFillWidth != null) {
        return this.settings.afterFillWidth();
      }
    },
    rowObjs: function() {
      var arr;
      arr = [];
      this.each(function() {
        return arr.push($(this).data('fillwidth.rows'));
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
          var _j, _len2, _ref, _results;
          _ref = row.lis;
          _results = [];
          for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
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
      var i, rows;
      i = 0;
      rows = [new Row(this.frameWidth, this.settings)];
      $(el).children('li').each(__bind(function(j, li) {
        rows[i].lis.push(new Li(li));
        if (rows[i].width() >= $(el).width() && j !== $(el).children('li').length - 1) {
          rows.push(new Row(this.frameWidth, this.settings));
          return i++;
        }
      }, this));
      return rows;
    },
    firefoxScrollbarBug: function(el) {
      if (!$.browser.mozilla) {
        return;
      }
      return setTimeout((function() {
        var $lastLi, diff, i, index, randomRow, row, rows, _i, _len, _ref, _results;
        rows = $(el).data('fillwidth.rows');
        if (rows == null) {
          return;
        }
        _ref = rows.slice(0, (rows.length - 2 + 1) || 9e9);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          row = _ref[_i];
          $lastLi = row.lis[row.lis.length - 1].$el;
          diff = $(el).width() - ($lastLi.outerWidth(true) + $lastLi.position().left);
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
