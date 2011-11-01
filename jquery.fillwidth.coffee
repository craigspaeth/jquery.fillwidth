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
(($) ->
  
  # Options
  # -------
  _defaults = 
    callback: null
    resizeLandscapesBy: 95
    landscapeRatios: [3, 2, 1.5, 1.25, 1]
    
  options = $.extend _defaults, options
  
  # Globals
  # -------
  frameWidth = 0; currentRows =[];
  
  # In memory row and li objects
  # ----------------------------
  class Li
    
    constructor: (el) ->
      @originalWidth = @width = $(el).outerWidth()
      @originalHeight = @height = $(el).outerHeight(true)
      @originalMargin = @margin = $(el).outerWidth(true) - $(el).outerWidth()
      @imageHeight = $(el).children('img').height()
      @$el = $(el)
      
    setHeight: (h) ->
      @width = Math.ceil(h * (@width / @height))
      @height = h
    
    setWidth: (w) ->
      @height = Math.ceil(w * (@height / @width))
      @width = w
      
    decWidth: -> @setWidth @width - 1
    
    decHeight: -> @setHeight @height - 1
    
    incWidth: -> @setWidth @width + 1
      
    incHeight: -> @setHeight @height + 1
    
    updateDOM: ->
      @$el.width @width
      @$el.height @height
      
    reset: ->
      @width = @originalWidth
      @height = @originalHeight
      @margin = @originalMargin
      @$el.css 
        "margin-right": @originalMargin
        height: 'auto'
        width: 'auto'
      
  class Row
    
    constructor: (@lis) ->
      @lis ?= []
      
    width: ->
      width = 0
      width += li.width for li in @lis
      width
      
    updateDOM: ->
      li.updateDOM() for li in @lis
      
    # Resets the styling of the lis to be able to run calculations on a clean slate
    reset: ->
      li.reset() for li in @lis
      
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
    init: ->
      methods.initialStyling.apply @
      lineup = =>
        row.reset() for row in currentRows
        @each ->
          $(@).width 'auto'
          methods.lineUp.apply @
          $(@).width $(@).width()
      
      $(window).resize debounce lineup, 250
      lineup()
      
    # Initial styling applied to the element to get lis to line up horizontally and images to be 
    # contained well in them.
    initialStyling: ->
      $(@).css
        'list-style': 'none'
        padding: 0
        margin: 0
      $(@).append "<div class='fillwidth-clearfix' style='clear:both'></div>"
      $(@).children('li').css float: 'left'
      $(@).children('li').children('img').css
        display: 'block'
        'max-width': '100%'
        'max-height': '100%'
    
    # Combines all of the magic and lines the lis up
    lineUp: ->
      frameWidth = $(@).width()
      currentRows = methods.breakUpIntoRows.apply @
      
      # Go through each row and try various things to line up
      for row in currentRows
        methods.removeMargin row
        methods.resizeLandscapes row
        methods.fillLeftoverPixels row
        methods.considerMargins row
        methods.setRowHeight row
        row.updateDOM()
      
      setTimeout (-> methods.firefoxScrollbarBug.apply @), 1
    
    # Firefox work-around for ghost scrollbar bug
    firefoxScrollbarBug: ->
      for row in currentRows[0..currentRows.length - 2]
        $lastLi = row.lis[row.lis.length - 1].$el
        diff = $(@).width() - ($lastLi.outerWidth(true) + $lastLi.position().left)
        if $.browser.mozilla and diff is 24
          for i in [1..15]
            index = Math.round Math.random() * (row.lis.length - 1)
            randomRow = row.lis[index]
            randomRow.incWidth()
          methods.setRowHeight row
          row.updateDOM()
     
    # Determine which set of lis go over the edge of the container, and store their 
    # { width, height, el, etc.. } in an array. Storing the width and height in objects helps run 
    # calculations without waiting for render reflows.
    breakUpIntoRows: ->
      i = 0
      rows = [new Row()]
      for li in $(@).children('li')
        rows[i].lis.push new Li li
        if rows[i].width() >= $(@).width() and _i isnt $(@).children('li').length - 1
          rows.push new Row()
          i++
      rows
    
    # Makes sure all of the lis are the same height (the tallest list item in the row)
    setRowHeight: (row) ->
      unsortedLis = (li for li in row.lis)
      sortedLis = unsortedLis.sort (a, b) -> b.imageHeight - a.imageHeight
      height = sortedLis[0].imageHeight
      li.height = height for li in sortedLis
    
    # Reduces the row so that it fits with margins
    considerMargins: (row) ->
      for li in row.lis
        li.setWidth(li.width - li.margin)
    
    # Removes the right margin from the last row element
    removeMargin: (row) ->
      lastLi = row.lis[row.lis.length - 1]
      lastLi.width -= lastLi.margin
      lastLi.margin = 0
      lastLi.$el.css "margin-right": 0
    
    # Resize the landscape's height so that it fits the frame
    resizeLandscapes: (row) ->
      
      # Determine our landscapes
      for i, ratio of options.landscapeRatios
        ratio = options.landscapeRatios[i]
        landscapes = (li for li in row.lis when (li.width / li.height) >= ratio)
        
        continue if landscapes.length is 0
        
        # Reduce the landscapes until we are within the frame or beyond our threshold
        for i in [1..options.resizeLandscapesBy]
          li.decHeight() for li in landscapes
          break if row.width() <= frameWidth
        break if row.width() <= frameWidth
      
      li.updateWidth() for li in row
      row
      
    # Arbitrarily extend lis in a row to fill in any pixels that got rounded off
    fillLeftoverPixels: (row) ->
      diff = -> frameWidth - row.width()
      return if diff() > 20
      
      # Randomly pick any lis and extend them to fit the row width
      while diff() > 0
        index = Math.round Math.random() * (row.lis.length - 1)
        randomRow = row.lis[index]
        randomRow.incWidth()
          
  # Either call a method if passed a string, or call init if passed an object
  $.fn.fillwidth = (method) ->
    if methods[method]?
      methods[method].apply @, Array::slice.call(arguments)[1..arguments.length]
    else if typeof method is "object" or not method?
      methods.init.apply @, arguments
    else
      $.error "Method " + method + " does not exist on jQuery.fillwidth"
  
) jQuery
