# jQuery.fillwidth
# 
# This plugin will attempt to make a list of images fill the width of it's parent
# so that everything lines up nice and pretty. (See google images)
# 
# Markup should be something like:
# <ul>
#   <li>
#     <img>
#  
# Options
# -------
# 
# jQuery.fillwidth will attempt to fill the rows using a variety of default options.
# Setting false for any of these options will skip that option.
# 
# TODO: shuffle: Boolean
#   Re-arrange the lis so they take up the optimal ammount of width.
# resizeRowBy: Int
#   Attempt to increase or decrease the entire row's height by a max of the given ammount of pixels
# resizeLandscapesBy: Int
#   Attempt to decrease the landscape heights by a max the given ammount of pixels
# adjustMarginsBy: Int
#   Attempt to shave off pixels from the right-margins of the image
# 
# TODOs
# -----
# * Add shuffle option
# * Allow percentages to be passed as Strings as well as Ints by pixel 
# 
(($) ->
  
  # Options
  # -------
  _defaults = 
    shuffle: false
    resizeRowBy: 15
    resizeLandscapesBy: 95
    landscapeRatios: [3, 2, 1.5, 1.25, 1]
    adjustMarginsBy: 15
    callback: null
    
  options = $.extend _defaults, options
  
  # Globals
  # -------
  frameWidth = 0; currentRows =[];
  
  # Methods
  # -------
  methods =
    
    # Called on initialization of the plugin
    init: ->
      @each ->
        
        # Make sure the images are going to fit in their containers
        $(@).find('img').css 
          'max-width': '100%'
          'max-height': '100%'
          display: 'block'
          'height': 'auto'
        
        methods.lineUp $(@)
    
    # Access the current row li elements
    rows: -> _.pluck(row, 'el') for row in currentRows
        
    # Combines all of the magic and lines the lis up
    lineUp: ($el) ->
      frameWidth = $el.width()
      currentRows = methods.breakUpIntoRows.apply $el
      
      # Go through each row and try various things to line them up
      for row in currentRows
        methods.resizeRowHeight.apply $el, [row]
        continue if methods.rowWidth(row) <= frameWidth
        methods.resizeLandscapes.apply $el, [row]
        continue if methods.rowWidth(row) <= frameWidth
    
    # Methods used to try to line up the artworks
    # -------------------------------------------
    
    # Resize the landscape's width to fit the frame
    resizeLandscapes: (row) ->
      
      # Determine our landscapes
      for ratio in options.landscapeRatios
        landscapes = _.select row, (li) ->
          (options.landscapeRatios[_i - 1] ? 9999) >= (li.width / li.height) > ratio
        continue if landscapes.length is 0
        
        # Reduce the landscapes until we are within the frame
        for i in [1..options.resizeLandscapesBy]
          li.decHeight() for li in landscapes
          break if methods.rowWidth(row) <= frameWidth
        break if methods.rowWidth(row) <= frameWidth
        
      li.updateWidth() for li in row
      
    # Resize the entire row's height to fit the frame
    resizeRowHeight: (row) ->
      
      # Resize every list item until we have reached the limit or are within the frame
      for i in [0..options.resizeRowBy]
        for li in row
          li.decHeight()
          break if methods.rowWidth(row) <= frameWidth 
          
      li.updateWidth() for li in row
      
    # Determine which set of lis go over the edge of the container, and store
    # their { width, height, el, etc.. } in an array. Storing the width and height
    # in objects helps run calculations without waiting for render reflows.
    breakUpIntoRows: ->
      rows = [[]]; i = 0
      for li in @children('li')
        rows[i].push
          width: $(li).outerWidth(true)
          height: $(li).height()
          margin: $(li).outerWidth(true) - $(li).outerWidth(false)
          el: $(li)
          setHeight: (h) -> @width = Math.ceil(h * (@width / @height)); @height = h
          setWidth: (w) -> @height = Math.ceil(w * (@height / @width)); @width = w
          decWidth: -> @setWidth(@width - 1)
          decHeight: -> @setHeight(@height - 1)
          updateWidth: -> @el.width @width - @margin
          updateHeight: -> @el.height @height
        if methods.rowWidth(rows[i]) > @width()
          lastLi = rows[i][rows[i].length - 1]
          lastLi.width -= lastLi.margin
          lastLi.margin = 0
          i++; rows[i] = []
          $(li).css 'margin-right': '0px'
      rows
    
    # Get the width of an array of our custom li objects
    rowWidth: (row) -> _.reduce _.pluck(row, 'width'), ((memo, num) -> memo + num), 0
          
  # Either call a method if passed a string, or call init if passed an object
  $.fn.fillwidth = (method) ->
    if methods[method]?
      methods[method].apply @, Array::slice.call(arguments, 1)
    else if typeof method is "object" or not method?
      methods.init.apply @, arguments
    else
      $.error "Method " + method + " does not exist on jQuery.fillwidth"
  
) jQuery
