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
      @width = $(el).outerWidth()
      @height = $(el).outerHeight(true)
      @margin = $(el).outerWidth(true) - $(el).outerWidth()
      @$el = $(el)
      
    setHeight: (h) ->
      @width = Math.floor(h * (@width / @height))
      @height = h
    
    setWidth: (w) ->
      @height = Math.floor(w * (@height / @width))
      @width = w
      
    decWidth: ->
      @setWidth @width - 1
      
    decHeight: ->
      @setHeight @height - 1
      
    updateDOM: ->
      @$el.width @width
      @$el.height @height
    
  class Row
    
    constructor: (@lis) ->
      @lis ?= []
      
    width: ->
      width = 0
      width += li.width for li in @lis
      width
      
    updateDOM: ->
      li.updateDOM() for li in @lis
  
  # Methods
  # -------
  methods =
    
    # Called on initialization of the plugin
    init: ->
      @each ->
        methods.initialStyling.apply @
        methods.lineUp.apply @
    
    # Initial styling applied to the element to get lis to line up horizontally and images to be 
    # contained well in them.
    initialStyling: ->
      $(@).css
        'list-style': 'none'
        padding: 0
        margin: 0
      $(@).children('li').css float: 'left'
      $(@).children('li').children('img').css
        display: 'block'
        'max-width': '100%'
    
    # Combines all of the magic and lines the lis up
    lineUp: ->
      frameWidth = $(@).width()
      currentRows = methods.breakUpIntoRows.apply @
      
      # Go through each row and try various things to line up
      for row in currentRows
        methods.removeMargin row
        methods.resizeLandscapes row
      
      for row in currentRows
        methods.considerMargins row
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
      sortedLis = unsortedLis.sort (a, b) -> b.height - a.height
      height = sortedLis[0].height
      li.height = height for li in sortedLis
    
    # Reduces the row so that it fits with margins
    considerMargins: (row) ->
      li.setWidth li.width - li.margin for li in row.lis
    
    # Removes the right margin from the last row element
    removeMargin: (row) ->
      lastLi = row.lis[row.lis.length - 1]
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
          
  # Either call a method if passed a string, or call init if passed an object
  $.fn.fillwidth = (method) ->
    if methods[method]?
      methods[method].apply @, Array::slice.call(arguments)[1..arguments.length]
    else if typeof method is "object" or not method?
      methods.init.apply @, arguments
    else
      $.error "Method " + method + " does not exist on jQuery.fillwidth"
  
) jQuery
