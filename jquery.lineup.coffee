# jQuery.lineup
# 
# A plugin that given a `ul` with images inside their `lis` will do some
# things to line them up so that everything fits inside their container nice 
# and flush to the edges while retaining the integrity of the original images 
# (no cropping or skewing).
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
        methods.initialStyling $(@)
        methods.lineUp $(@)
    
    # Initial styling applied to the element to get lis to line up
    # horizontally and images be contained well in them
    initialStyling: ($el) ->
      $el.css
        'list-style': 'none'
        padding: 0
        margin: 0
      $el.children('li').css
        float: 'left'
      $el.children('li').children('img').css
        display: 'block'
        'max-width': '100%'
    
    # Access the current row li elements
    rows: -> _.pluck(row, 'el') for row in currentRows
    
    # Combines all of the magic and lines the lis up
    lineUp: ($el) ->
      frameWidth = $el.width()
      currentRows = methods.breakUpIntoRows.apply $el
      
      # Go through each row and try various things to line up
      for row in currentRows
        console.log row
    
    # Determine which set of lis go over the edge of the container, and store
    # their { width, height, el, etc.. } in an array. Storing the width and 
    # height in objects helps run calculations without waiting for render 
    # reflows.
    breakUpIntoRows: ->
      rows = [[]]; i = 0
      for li in @children('li')
        rows[i].push
          width: $(li).outerWidth(true)
          height: $(li).height()
          margin: $(li).outerWidth(true) - $(li).outerWidth(false)
          el: $(li)
          setHeight: (h) -> 
            @width = Math.ceil(h * (@width / @height)); @height = h
          setWidth: (w) -> 
            @height = Math.ceil(w * (@height / @width)); @width = w
          decWidth: -> @setWidth(@width - 1)
          decHeight: -> @setHeight(@height - 1)
          updateWidth: -> @el.width @width - @margin
          updateHeight: -> @el.height @height
          updateEl: ->
            @el.width = @width
        if methods.rowWidth(rows[i]) > @width()
          lastLi = rows[i][rows[i].length - 1]
          lastLi.width -= lastLi.margin
          lastLi.margin = 0
          i++; rows[i] = []
          $(li).css 'margin-right': '0px'
      rows
    
    # Get the width of an array of our custom li objects
    rowWidth: (row) ->
      widths = 0
      widths += li.width for li in row
          
  # Either call a method if passed a string, or call init if passed an object
  $.fn.lineup = (method) ->
    if methods[method]?
      methods[method].apply @, arguments[1..arguments.length]
    else if typeof method is "object" or not method?
      methods.init.apply @, arguments
    else
      $.error "Method " + method + " does not exist on jQuery.lineup"
  
) jQuery
