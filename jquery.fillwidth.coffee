# Embed images loaded http://imagesloaded.desandro.com/
`
(function(){function e(){}function t(e,t){for(var n=e.length;n--;)if(e[n].listener===t)return n;return-1}function n(e){return function(){return this[e].apply(this,arguments)}}var i=e.prototype,r=this,o=r.EventEmitter;i.getListeners=function(e){var t,n,i=this._getEvents();if("object"==typeof e){t={};for(n in i)i.hasOwnProperty(n)&&e.test(n)&&(t[n]=i[n])}else t=i[e]||(i[e]=[]);return t},i.flattenListeners=function(e){var t,n=[];for(t=0;e.length>t;t+=1)n.push(e[t].listener);return n},i.getListenersAsObject=function(e){var t,n=this.getListeners(e);return n instanceof Array&&(t={},t[e]=n),t||n},i.addListener=function(e,n){var i,r=this.getListenersAsObject(e),o="object"==typeof n;for(i in r)r.hasOwnProperty(i)&&-1===t(r[i],n)&&r[i].push(o?n:{listener:n,once:!1});return this},i.on=n("addListener"),i.addOnceListener=function(e,t){return this.addListener(e,{listener:t,once:!0})},i.once=n("addOnceListener"),i.defineEvent=function(e){return this.getListeners(e),this},i.defineEvents=function(e){for(var t=0;e.length>t;t+=1)this.defineEvent(e[t]);return this},i.removeListener=function(e,n){var i,r,o=this.getListenersAsObject(e);for(r in o)o.hasOwnProperty(r)&&(i=t(o[r],n),-1!==i&&o[r].splice(i,1));return this},i.off=n("removeListener"),i.addListeners=function(e,t){return this.manipulateListeners(!1,e,t)},i.removeListeners=function(e,t){return this.manipulateListeners(!0,e,t)},i.manipulateListeners=function(e,t,n){var i,r,o=e?this.removeListener:this.addListener,s=e?this.removeListeners:this.addListeners;if("object"!=typeof t||t instanceof RegExp)for(i=n.length;i--;)o.call(this,t,n[i]);else for(i in t)t.hasOwnProperty(i)&&(r=t[i])&&("function"==typeof r?o.call(this,i,r):s.call(this,i,r));return this},i.removeEvent=function(e){var t,n=typeof e,i=this._getEvents();if("string"===n)delete i[e];else if("object"===n)for(t in i)i.hasOwnProperty(t)&&e.test(t)&&delete i[t];else delete this._events;return this},i.removeAllListeners=n("removeEvent"),i.emitEvent=function(e,t){var n,i,r,o,s=this.getListenersAsObject(e);for(r in s)if(s.hasOwnProperty(r))for(i=s[r].length;i--;)n=s[r][i],n.once===!0&&this.removeListener(e,n.listener),o=n.listener.apply(this,t||[]),o===this._getOnceReturnValue()&&this.removeListener(e,n.listener);return this},i.trigger=n("emitEvent"),i.emit=function(e){var t=Array.prototype.slice.call(arguments,1);return this.emitEvent(e,t)},i.setOnceReturnValue=function(e){return this._onceReturnValue=e,this},i._getOnceReturnValue=function(){return this.hasOwnProperty("_onceReturnValue")?this._onceReturnValue:!0},i._getEvents=function(){return this._events||(this._events={})},e.noConflict=function(){return r.EventEmitter=o,e},"function"==typeof define&&define.amd?define("eventEmitter/EventEmitter",[],function(){return e}):"object"==typeof module&&module.exports?module.exports=e:this.EventEmitter=e}).call(this),function(e){function t(t){var n=e.event;return n.target=n.target||n.srcElement||t,n}var n=document.documentElement,i=function(){};n.addEventListener?i=function(e,t,n){e.addEventListener(t,n,!1)}:n.attachEvent&&(i=function(e,n,i){e[n+i]=i.handleEvent?function(){var n=t(e);i.handleEvent.call(i,n)}:function(){var n=t(e);i.call(e,n)},e.attachEvent("on"+n,e[n+i])});var r=function(){};n.removeEventListener?r=function(e,t,n){e.removeEventListener(t,n,!1)}:n.detachEvent&&(r=function(e,t,n){e.detachEvent("on"+t,e[t+n]);try{delete e[t+n]}catch(i){e[t+n]=void 0}});var o={bind:i,unbind:r};"function"==typeof define&&define.amd?define("eventie/eventie",o):e.eventie=o}(this),function(e,t){"function"==typeof define&&define.amd?define(["eventEmitter/EventEmitter","eventie/eventie"],function(n,i){return t(e,n,i)}):"object"==typeof exports?module.exports=t(e,require("eventEmitter"),require("eventie")):e.imagesLoaded=t(e,e.EventEmitter,e.eventie)}(window,function(e,t,n){function i(e,t){for(var n in t)e[n]=t[n];return e}function r(e){return"[object Array]"===d.call(e)}function o(e){var t=[];if(r(e))t=e;else if("number"==typeof e.length)for(var n=0,i=e.length;i>n;n++)t.push(e[n]);else t.push(e);return t}function s(e,t,n){if(!(this instanceof s))return new s(e,t);"string"==typeof e&&(e=document.querySelectorAll(e)),this.elements=o(e),this.options=i({},this.options),"function"==typeof t?n=t:i(this.options,t),n&&this.on("always",n),this.getImages(),a&&(this.jqDeferred=new a.Deferred);var r=this;setTimeout(function(){r.check()})}function c(e){this.img=e}function f(e){this.src=e,v[e]=this}var a=e.jQuery,u=e.console,h=u!==void 0,d=Object.prototype.toString;s.prototype=new t,s.prototype.options={},s.prototype.getImages=function(){this.images=[];for(var e=0,t=this.elements.length;t>e;e++){var n=this.elements[e];"IMG"===n.nodeName&&this.addImage(n);var i=n.nodeType;if(i&&(1===i||9===i||11===i))for(var r=n.querySelectorAll("img"),o=0,s=r.length;s>o;o++){var c=r[o];this.addImage(c)}}},s.prototype.addImage=function(e){var t=new c(e);this.images.push(t)},s.prototype.check=function(){function e(e,r){return t.options.debug&&h&&u.log("confirm",e,r),t.progress(e),n++,n===i&&t.complete(),!0}var t=this,n=0,i=this.images.length;if(this.hasAnyBroken=!1,!i)return this.complete(),void 0;for(var r=0;i>r;r++){var o=this.images[r];o.on("confirm",e),o.check()}},s.prototype.progress=function(e){this.hasAnyBroken=this.hasAnyBroken||!e.isLoaded;var t=this;setTimeout(function(){t.emit("progress",t,e),t.jqDeferred&&t.jqDeferred.notify&&t.jqDeferred.notify(t,e)})},s.prototype.complete=function(){var e=this.hasAnyBroken?"fail":"done";this.isComplete=!0;var t=this;setTimeout(function(){if(t.emit(e,t),t.emit("always",t),t.jqDeferred){var n=t.hasAnyBroken?"reject":"resolve";t.jqDeferred[n](t)}})},a&&(a.fn.imagesLoaded=function(e,t){var n=new s(this,e,t);return n.jqDeferred.promise(a(this))}),c.prototype=new t,c.prototype.check=function(){var e=v[this.img.src]||new f(this.img.src);if(e.isConfirmed)return this.confirm(e.isLoaded,"cached was confirmed"),void 0;if(this.img.complete&&void 0!==this.img.naturalWidth)return this.confirm(0!==this.img.naturalWidth,"naturalWidth"),void 0;var t=this;e.on("confirm",function(e,n){return t.confirm(e.isLoaded,n),!0}),e.check()},c.prototype.confirm=function(e,t){this.isLoaded=e,this.emit("confirm",this,t)};var v={};return f.prototype=new t,f.prototype.check=function(){if(!this.isChecked){var e=new Image;n.bind(e,"load",this),n.bind(e,"error",this),e.src=this.src,this.isChecked=!0}},f.prototype.handleEvent=function(e){var t="on"+e.type;this[t]&&this[t](e)},f.prototype.onload=function(e){this.confirm(!0,"onload"),this.unbindProxyEvents(e)},f.prototype.onerror=function(e){this.confirm(!1,"onerror"),this.unbindProxyEvents(e)},f.prototype.confirm=function(e,t){this.isConfirmed=!0,this.isLoaded=e,this.emit("confirm",this,t)},f.prototype.unbindProxyEvents=function(e){n.unbind(e.target,"load",this),n.unbind(e.target,"error",this)},s});
`

# jQuery.fillwidth
#
# A plugin that given a `ul` with images inside their `lis` will do some things to line them up so
# that everything fits inside their container nice and flush to the edges while retaining the
# integrity of the original images (no cropping or skewing).
#
# Markup should be something like:
# <ul>
#   <li>
#     <img>
#
$ = jQuery

# Plugin globals
totalPlugins = 0
callQueue = []

# In memory row and li objects
# ----------------------------
class Li

  constructor: (el, settings) ->
    $el = $(el)
    @originalWidth = @width = $el.outerWidth(false)
    @originalHeight = @height = $el.height()
    @originalMargin = @margin = $el.outerWidth(true) - $el.outerWidth(false)
    $img = $el.find('img')
    @imgRatio = $img.width() / $img.height()
    @$el = $el
    @settings = settings

  setHeight: (h) ->
    @width = Math.round(h * (@width / @height))
    @height = h unless @settings.lockedHeight # comment if locked height

  setWidth: (w) ->
    @height = Math.round(w * (@height / @width))
    @width = w

  decWidth: -> @setWidth @width - 1

  decHeight: -> @setHeight @height - 1

  incWidth: -> @setWidth @width + 1

  incHeight: -> @setHeight @height + 1

  updateDOM: ->
    @$el.css
      width          : @width
      height         : @height
      'margin-right' : @margin
    @$el.find('img').height 'auto'

  reset: ->
    @width = @originalWidth
    @height = @originalHeight
    @margin = @originalMargin
    @$el.css
      width          : @width
      height         : @height
      'margin-right' : @margin

class Row

  constructor: (@frameWidth, @settings) ->
    @lis = []

  width: ->
    width = 0
    width += (li.width + li.margin) for li in @lis
    width

  updateDOM: ->
    li.updateDOM() for li in @lis

  # Resets the styling of the lis to be able to run calculations on a clean slate
  reset: -> li.reset() for li in @lis

  # Get an array of groups of landscapes in order of @settings.landscapeRatios
  # e.g. [[li,li],[li,li,li]]
  landscapeGroups: ->
    landscapeGroups = []
    for i, ratio of @settings.landscapeRatios
      landscapes = (li for li in @lis when li.imgRatio >= ratio)
      landscapeGroups.push landscapes
    landscapeGroups

  # Resize the landscape's height so that it fits the frame
  resizeLandscapes: ->
    for landscapes in @landscapeGroups(@settings.landscapeRatios) when landscapes.length isnt 0

      # Reduce the landscapes until we are within the frame or beyond our threshold
      for i in [0..@settings.resizeLandscapesBy]
        li.decHeight() for li in landscapes
        break if @width() <= @frameWidth
      break if @width() <= @frameWidth
    @

  # Adjust the margins between list items to try an reach the frame
  adjustMargins: ->
    for i in [0..@settings.adjustMarginsBy]
      for li in @lis[0..@lis.length - 2]
        li.margin--
        break if @width() <= @frameWidth
      break if @width() <= @frameWidth

  # Resize the entire row height by a maximum ammount in an attempt make the margins
  resizeHeight: ->
    i = 0
    while @width() > @frameWidth and i < @settings.resizeRowBy
      i++
      li.decHeight() for li in @lis

  # Round off all of the li's width
  roundOff: ->
    li.setWidth(Math.floor li.width) for li in @lis

  # Arbitrarily extend lis to fill in any pixels that got rounded off
  fillLeftoverPixels: ->
    @roundOff()
    diff = => @frameWidth - @width()

    while diff() isnt 0
      randIndex = Math.round Math.random() * (@lis.length - 1)
      if diff() < 0
        @lis[randIndex].decWidth()
      else
        @lis[randIndex].incWidth()

  # Removes the right margin from the last row element
  removeMargin: ->
    lastLi = @lis[@lis.length - 1]
    lastLi.margin = 0

  # Make sure all of the lis are the same height (the tallest li in the group)
  lockHeight: ->
    tallestLi = (@lis.sort (a, b) -> b.height - a.height)[0]
    tallestHeight = Math.ceil tallestLi.height
    li.height = tallestHeight for li in @lis

  # Go through the lis and hide them
  hide: -> li.$el.hide() for li in @lis

  # Go through the lis and show them
  show: -> li.$el.show() for li in @lis

# Debounce stolen from underscore.js
# ----------------------------------
debounce = (func, wait) ->
  timeout = 0
  return ->
    args = arguments
    throttler = =>
      timeout = null
      func args

    clearTimeout timeout
    timeout = setTimeout(throttler, wait)

# Methods
# -------
methods =

  # Called on initialization of the plugin
  init: (settings) ->

    # Settings
    _defaults =
      resizeLandscapesBy: 200
      resizeRowBy: 30
      landscapeRatios: (i / 10 for i in [10..50] by 3).reverse()
      fillLastRow: false
      beforeFillWidth: null
      afterFillWidth: null
    @settings = $.extend _defaults, settings

    @each (i, el) =>
      $el = $(el)
      methods.initStyling.call @, $el

      # Decide to run fillWidth after all of the child images have loaded, or before hand depending
      # on whether the @settings to do the latter have been specified.
      initFillWidth = =>
        methods.fillWidth.call @, $el
        # work around for iOS and IE8 continuous resize bug
        # Cause: in iOS changing document height triggers a resize event
        unless navigator.userAgent.match(/iPhone/i) or
               navigator.userAgent.match(/iPad/i) or
               navigator.userAgent.match(/iPod/i) or
               navigator.userAgent.match(/MSIE 8\.0/i)
          $(window).bind 'resize.fillwidth', debounce (=>
            callQueue.push (=> methods.fillWidth.call @, $el)
            if callQueue.length is totalPlugins
              fn() for fn in callQueue
              callQueue = []
          ), 300
        totalPlugins++

      $imgs = $el.find('img')

      if @settings.imageDimensions?
        initFillWidth()
      else
        imagesLoaded $el, -> initFillWidth()

  # Initial styling applied to the element to get lis to line up horizontally and images to be
  # contained well in them.
  initStyling: (el) ->
    $el = $ el
    $el.css
      'list-style': 'none'
      padding: 0
      margin: 0
      overflow: 'hidden'
    $el.css @settings.initStyling if @settings.initStyling?
    $el.find('> li').css
      'float': 'left'
      'margin-left': 0
    $el.find('img').css
      'max-width': '100%'
      'max-height': '100%'

    # Set the initial width and height of the lis if passed in
    if @settings and @settings.imageDimensions?
      $el.find('> li').each (i, el) =>
        $img = $(el).find('img').first()
        $img.width @settings.imageDimensions[i].width
        $img.height @settings.imageDimensions[i].height

  # Removes the fillwidth functionality completely. Returns the element back to it's state
  destroy: ->
    $(window).unbind 'resize.fillwidth'
    @each ->
      row.reset() for row in $(@).fillwidth('rowObjs')
      $(@).removeData('fillwidth.rows')

  # Combines all of the magic and lines the lis up
  fillWidth: (el) ->
    $el = $ el
    $el.trigger 'fillwidth.beforeFillWidth'
    @settings.beforeFillWidth() if @settings.beforeFillWidth?

    # Reset the list items & unfreeze the container
    if @fillwidthRows
      row.reset() for row in @fillwidthRows #$el.data 'fillwidth.rows'
    $el.width 'auto'

    $el.trigger 'fillwidth.beforeNewRows'
    @settings.beforeNewRows() if @settings.beforeNewRows?

    # Store the new row in-memory objects and re-freeze the container
    @frameWidth = $el.width()
    rows = methods.breakUpIntoRows.call @, $el
    @fillwidthRows = rows
    $el.width @frameWidth

    $el.trigger 'fillwidth.afterNewRows'
    @settings.afterNewRows() if @settings.afterNewRows?

    # Go through each row and try various things to line up
    for row in rows
      continue unless row.lis.length > 1
      row.removeMargin()
      row.resizeHeight()
      row.adjustMargins() if @settings.adjustMarginsBy?
      row.resizeLandscapes()
      row.fillLeftoverPixels() unless row is rows[rows.length - 1] and not @settings.fillLastRow
      row.lockHeight()
      row.updateDOM()

    $el.trigger 'fillwidth.afterFillWidth'
    @settings.afterFillWidth() if @settings.afterFillWidth?

  # Returns the current in-memory row objects
  rowObjs: ->
    arr = []
    rows = @fillwidthRows
    @each ->
      arr.push rows
    arr = arr[0] if arr.length is 1
    arr

  # Returns an array of groups of li elements that make up a row
  rows: ->
    rows = methods.rowObjs.call @
    arr = []
    for row in rows
      arr.push (li.$el for li in row.lis)
    arr = arr[0] if arr.length is 1
    arr

  # Determine which set of lis go over the edge of the container, and store their
  # { width, height, el, etc.. } in an array. Storing the width and height in objects helps run
  # calculations without waiting for render reflows.
  breakUpIntoRows: (el) ->
    $el = $ el
    i = 0
    rows = [new Row(@frameWidth, @settings)]
    $el.find('> li').each (j, li) =>
      return if $(li).is(':hidden')
      rows[i].lis.push new Li li, @settings
      if rows[i].width() >= $el.width() and j isnt $el.find('> li').length - 1
        rows.push new Row(@frameWidth, @settings)
        i++
    rows

# Either call a method if passed a string, or call init if passed an object
$.fn.fillwidth = (method) ->
  if methods[method]?
    methods[method].apply @, Array::slice.call(arguments, 1)
  else if typeof method is "object" or not method?
    methods.init.apply @, arguments
  else
    $.error "Method #{method} does not exist on jQuery.fillwidth"
