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
    resizeLandscapesBy: 200
    resizeRowBy: 15
    landscapeRatios: (i / 10 for i in [10..50])
  options = $.extend _defaults, options
  
  # Globals
  # -------
  frameWidth = 0;
  
  # In memory row and li objects
  # ----------------------------
  class Li
    
    constructor: (el) ->
      @originalWidth = @width = $(el).outerWidth()
      @originalHeight = @height = $(el).outerHeight()
      @originalMargin = @margin = $(el).outerWidth(true) - $(el).outerWidth()
      @$el = $(el)
      
    setHeight: (h) ->
      @width = h * (@width / @height)
      @height = h
    
    setWidth: (w) ->
      @height = w * (@height / @width)
      @width = w
      
    decWidth: -> @setWidth @width - 1
    
    decHeight: -> @setHeight @height - 1
    
    incWidth: -> @setWidth @width + 1
      
    incHeight: -> @setHeight @height + 1
    
    updateDOM: ->
      @$el.width @width
      @$el.css 'margin-right': @margin
      
    reset: ->
      @width = @originalWidth
      @height = @originalHeight
      @margin = @originalMargin
      @$el.css 
        "margin-right": @originalMargin
        width: 'auto'
        height: 'auto'
      
  class Row
    
    constructor: (@lis) ->
      @lis ?= []
      
    width: ->
      width = 0
      width += (li.width + li.margin) for li in @lis
      width
      
    updateDOM: ->
      li.updateDOM() for li in @lis
      
    # Resets the styling of the lis to be able to run calculations on a clean slate
    reset: -> li.reset() for li in @lis
      
    # Get an array of groups of landscapes in order of options.landscapeRatios
    # e.g. [[li,li],[li,li,li]]
    landscapeGroups: ->
      landscapeGroups = []
      for i, ratio of options.landscapeRatios
        ratio = options.landscapeRatios[i]
        landscapeGroups.push (li for li in @lis when (li.width / li.height) >= ratio)
      landscapeGroups
      
    # Resize the landscape's height so that it fits the frame
    resizeLandscapes: ->
      for landscapes in @landscapeGroups()
        continue if landscapes.length is 0
        
        # Reduce the landscapes until we are within the frame or beyond our threshold
        for i in [1..options.resizeLandscapesBy]
          li.decHeight() for li in landscapes
          break if @width() <= frameWidth
        break if @width() <= frameWidth
      @
    
    # Resize the entire row height by a maximum ammount in an attempt make the margins
    resizeHeight: ->
      i = 0
      while @width() > frameWidth and i < options.resizeRowBy
        i++
        li.decHeight() for li in @lis
    
    # Round off all of the li's width
    roundOff: ->
      li.setWidth(Math.floor li.width) for li in @lis 
    
    # Arbitrarily extend lis to fill in any pixels that got rounded off
    fillLeftoverPixels: ->
      @roundOff()
      diff = => frameWidth - @width()
      return if diff() > 20
      
      # Int
      i = 0
      while diff() > 0
        randIndex = Math.round Math.random() * (@lis.length - 1)
        @lis[randIndex].incWidth()
        i++
        i = 0 if @lis.length - 1 is i
        
    # Removes the right margin from the last row element
    removeMargin: ->
      lastLi = @lis[@lis.length - 1]
      lastLi.margin = 0
        
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
      options = $.extend options, arguments[0]
    
      @each ->
        methods.initStyling.apply $(@)
        lineup = => methods.lineUp.apply @
        
        # Decide to run lineUp after all of the child images have loaded, or before hand depending
        # on whether the options to do the latter have been specified.
        initLineup = =>
          $(window).resize debounce lineup, 200
          lineup()
          console.log 'lined up'
        $imgs = $(@).find('img')
        if options.imgTargetHeight? and options.liWidths?
          initLineup()
          $imgs.css(opacity: 0).load -> 
            $(@).height('auto').animate(opacity: 1)
        else
          imagesToLoad = $imgs.length
          $imgs.load ->
            imagesToLoad--
            initLineup() if imagesToLoad is 0
          
    # Initial styling applied to the element to get lis to line up horizontally and images to be 
    # contained well in them.
    initStyling: ->
      $(@).css
        'list-style': 'none'
        padding: 0
        margin: 0
        overflow: 'hidden'
      $(@).append "<div class='fillwidth-clearfix' style='clear:both'></div>"
      $(@).children('li').css float: 'left'
      $(@).find('img').css
        display: 'block'
        'max-width': '100%'
        'max-height': '100%'
      
      if options.imgTargetHeight? and options.liWidths?
        $(@).children('li').each (i) ->
          $(@).find('img').height options.imgTargetHeight
          $(@).width options.liWidths[i]
    
    # Combines all of the magic and lines the lis up
    lineUp: ->
      
      # Unfreeze the container and reset the list items
      if $(@).data('fillwidth.rows')?
        row.reset() for row in $(@).data 'fillwidth.rows'
      $(@).width 'auto'
      
      # Get the new container width and store the new rows
      frameWidth = $(@).width()
      $(@).data 'fillwidth.rows', methods.breakUpIntoRows.apply @
      
      # Go through each row and try various things to line up
      for row in $(@).data 'fillwidth.rows'
        row.removeMargin()
        row.resizeHeight()
        row.resizeLandscapes()
        row.fillLeftoverPixels()
        row.updateDOM()
      
      methods.setRowHeights.apply @  
      methods.firefoxScrollbarBug.apply @
      
      # Defer refreezing the width after all is said and done
      setTimeout (-> $(@).width $(@).width()), 2
    
    # Returns the current in-memory row objects
    rows: -> $(@).data 'fillwidth.rows'
     
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
    setRowHeights: ->
      setTimeout (=>
        rows = methods.rows.apply @
        console.log rows
        for row in rows
          sortedLis = row.lis.sort (a, b) -> b.$el.height() - a.$el.height()
          height = sortedLis[0].$el.height()
          li.$el.height height for li in sortedLis
      ), 1
      
    # Firefox work-around for ghost scrollbar bug
    firefoxScrollbarBug: ->
      return unless $.browser.mozilla
      setTimeout (->
        rows = methods.rows.apply @
        return unless rows?
        for row in rows[0..rows.length - 2]
          $lastLi = row.lis[row.lis.length - 1].$el
          diff = $(@).width() - ($lastLi.outerWidth(true) + $lastLi.position().left)
          if diff is 24
            for i in [1..15]
              index = Math.round Math.random() * (row.lis.length - 1)
              randomRow = row.lis[index]
              randomRow.incWidth()
            row.updateDOM()
      ), 1
          
  # Either call a method if passed a string, or call init if passed an object
  $.fn.fillwidth = (method) ->
    if methods[method]?
      methods[method].apply @, Array::slice.call(arguments)[1..arguments.length]
    else if typeof method is "object" or not method?
      methods.init.apply @, arguments
    else
      $.error "Method " + method + " does not exist on jQuery.fillwidth"
  
) jQuery
