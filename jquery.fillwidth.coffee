# Embed images loaded http://imagesloaded.desandro.com/
imagesLoaded = null
`(function(){function e(){}function i(e,t){var n=e.length;while(n--){if(e[n].listener===t){return n}}return-1}function s(e){return function(){return this[e].apply(this,arguments)}}var t=e.prototype;var n=this;var r=n.EventEmitter;t.getListeners=function(t){var n=this._getEvents();var r;var i;if(typeof t==="object"){r={};for(i in n){if(n.hasOwnProperty(i)&&t.test(i)){r[i]=n[i]}}}else{r=n[t]||(n[t]=[])}return r};t.flattenListeners=function(t){var n=[];var r;for(r=0;r<t.length;r+=1){n.push(t[r].listener)}return n};t.getListenersAsObject=function(t){var n=this.getListeners(t);var r;if(n instanceof Array){r={};r[t]=n}return r||n};t.addListener=function(t,n){var r=this.getListenersAsObject(t);var s=typeof n==="object";var o;for(o in r){if(r.hasOwnProperty(o)&&i(r[o],n)===-1){r[o].push(s?n:{listener:n,once:false})}}return this};t.on=s("addListener");t.addOnceListener=function(t,n){return this.addListener(t,{listener:n,once:true})};t.once=s("addOnceListener");t.defineEvent=function(t){this.getListeners(t);return this};t.defineEvents=function(t){for(var n=0;n<t.length;n+=1){this.defineEvent(t[n])}return this};t.removeListener=function(t,n){var r=this.getListenersAsObject(t);var s;var o;for(o in r){if(r.hasOwnProperty(o)){s=i(r[o],n);if(s!==-1){r[o].splice(s,1)}}}return this};t.off=s("removeListener");t.addListeners=function(t,n){return this.manipulateListeners(false,t,n)};t.removeListeners=function(t,n){return this.manipulateListeners(true,t,n)};t.manipulateListeners=function(t,n,r){var i;var s;var o=t?this.removeListener:this.addListener;var u=t?this.removeListeners:this.addListeners;if(typeof n==="object"&&!(n instanceof RegExp)){for(i in n){if(n.hasOwnProperty(i)&&(s=n[i])){if(typeof s==="function"){o.call(this,i,s)}else{u.call(this,i,s)}}}}else{i=r.length;while(i--){o.call(this,n,r[i])}}return this};t.removeEvent=function(t){var n=typeof t;var r=this._getEvents();var i;if(n==="string"){delete r[t]}else if(n==="object"){for(i in r){if(r.hasOwnProperty(i)&&t.test(i)){delete r[i]}}}else{delete this._events}return this};t.removeAllListeners=s("removeEvent");t.emitEvent=function(t,n){var r=this.getListenersAsObject(t);var i;var s;var o;var u;for(o in r){if(r.hasOwnProperty(o)){s=r[o].length;while(s--){i=r[o][s];if(i.once===true){this.removeListener(t,i.listener)}u=i.listener.apply(this,n||[]);if(u===this._getOnceReturnValue()){this.removeListener(t,i.listener)}}}}return this};t.trigger=s("emitEvent");t.emit=function(t){var n=Array.prototype.slice.call(arguments,1);return this.emitEvent(t,n)};t.setOnceReturnValue=function(t){this._onceReturnValue=t;return this};t._getOnceReturnValue=function(){if(this.hasOwnProperty("_onceReturnValue")){return this._onceReturnValue}else{return true}};t._getEvents=function(){return this._events||(this._events={})};e.noConflict=function(){n.EventEmitter=r;return e};if(typeof define==="function"&&define.amd){define("eventEmitter/EventEmitter",[],function(){return e})}else if(typeof module==="object"&&module.exports){module.exports=e}else{this.EventEmitter=e}}).call(this);(function(e){function r(t){var n=e.event;n.target=n.target||n.srcElement||t;return n}var t=document.documentElement;var n=function(){};if(t.addEventListener){n=function(e,t,n){e.addEventListener(t,n,false)}}else if(t.attachEvent){n=function(e,t,n){e[t+n]=n.handleEvent?function(){var t=r(e);n.handleEvent.call(n,t)}:function(){var t=r(e);n.call(e,t)};e.attachEvent("on"+t,e[t+n])}}var i=function(){};if(t.removeEventListener){i=function(e,t,n){e.removeEventListener(t,n,false)}}else if(t.detachEvent){i=function(e,t,n){e.detachEvent("on"+t,e[t+n]);try{delete e[t+n]}catch(r){e[t+n]=undefined}}}var s={bind:n,unbind:i};if(typeof define==="function"&&define.amd){define("eventie/eventie",s)}else{e.eventie=s}})(this);(function(e,t){imagesLoaded=t(e,e.EventEmitter,e.eventie)})(window,function(t,n,r){function u(e,t){for(var n in t){e[n]=t[n]}return e}function f(e){return a.call(e)==="[object Array]"}function l(e){var t=[];if(f(e)){t=e}else if(typeof e.length==="number"){for(var n=0,r=e.length;n<r;n++){t.push(e[n])}}else{t.push(e)}return t}function c(e,t,n){if(!(this instanceof c)){return new c(e,t)}if(typeof e==="string"){e=document.querySelectorAll(e)}this.elements=l(e);this.options=u({},this.options);if(typeof t==="function"){n=t}else{u(this.options,t)}if(n){this.on("always",n)}this.getImages();if(i){this.jqDeferred=new i.Deferred}var r=this;setTimeout(function(){r.check()})}function h(e){this.img=e}function d(e){this.src=e;p[e]=this}var i=t.jQuery;var s=t.console;var o=typeof s!=="undefined";var a=Object.prototype.toString;c.prototype=new n;c.prototype.options={};c.prototype.getImages=function(){this.images=[];for(var e=0,t=this.elements.length;e<t;e++){var n=this.elements[e];if(n.nodeName==="IMG"){this.addImage(n)}var r=n.nodeType;if(!r||!(r===1||r===9||r===11)){continue}var i=n.querySelectorAll("img");for(var s=0,o=i.length;s<o;s++){var u=i[s];this.addImage(u)}}};c.prototype.addImage=function(e){var t=new h(e);this.images.push(t)};c.prototype.check=function(){function r(r,i){if(e.options.debug&&o){s.log("confirm",r,i)}e.progress(r);t++;if(t===n){e.complete()}return true}var e=this;var t=0;var n=this.images.length;this.hasAnyBroken=false;if(!n){this.complete();return}for(var i=0;i<n;i++){var u=this.images[i];u.on("confirm",r);u.check()}};c.prototype.progress=function(e){this.hasAnyBroken=this.hasAnyBroken||!e.isLoaded;var t=this;setTimeout(function(){t.emit("progress",t,e);if(t.jqDeferred&&t.jqDeferred.notify){t.jqDeferred.notify(t,e)}})};c.prototype.complete=function(){var e=this.hasAnyBroken?"fail":"done";this.isComplete=true;var t=this;setTimeout(function(){t.emit(e,t);t.emit("always",t);if(t.jqDeferred){var n=t.hasAnyBroken?"reject":"resolve";t.jqDeferred[n](t)}})};if(i){i.fn.imagesLoaded=function(e,t){var n=new c(this,e,t);return n.jqDeferred.promise(i(this))}}h.prototype=new n;h.prototype.check=function(){var e=p[this.img.src]||new d(this.img.src);if(e.isConfirmed){this.confirm(e.isLoaded,"cached was confirmed");return}if(this.img.complete&&this.img.naturalWidth!==undefined){this.confirm(this.img.naturalWidth!==0,"naturalWidth");return}var t=this;e.on("confirm",function(e,n){t.confirm(e.isLoaded,n);return true});e.check()};h.prototype.confirm=function(e,t){this.isLoaded=e;this.emit("confirm",this,t)};var p={};d.prototype=new n;d.prototype.check=function(){if(this.isChecked){return}var e=new Image;r.bind(e,"load",this);r.bind(e,"error",this);e.src=this.src;this.isChecked=true};d.prototype.handleEvent=function(e){var t="on"+e.type;if(this[t]){this[t](e)}};d.prototype.onload=function(e){this.confirm(true,"onload");this.unbindProxyEvents(e)};d.prototype.onerror=function(e){this.confirm(false,"onerror");this.unbindProxyEvents(e)};d.prototype.confirm=function(e,t){this.isConfirmed=true;this.isLoaded=e;this.emit("confirm",this,t)};d.prototype.unbindProxyEvents=function(e){r.unbind(e.target,"load",this);r.unbind(e.target,"error",this)};return c})`

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
