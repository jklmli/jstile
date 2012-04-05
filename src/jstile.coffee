(($) ->

  # Takes in jQuery object
  orientation = (element) ->
    if element.width() > element.height()
      'landscape'
    else
      'portrait'

  shrinkHorizontally = (element) ->
    element.css('width', '50%')
    element.css('height', '100%')

  shrinkVertically = (element) ->
    element.css('width', '100%')
    element.css('height', '50%')

  # HTML classes associated with each level of tile & container
  jsTileClass = 'jstile'
  tileClass = 'tile'
  tileContainerClass = 'tileContainer'

  class Mosaic
    constructor: (element) ->

      # Wrap the first element to create the first tile & parent element
      element.wrap('<div/>')
      element.parent().addClass(jsTileClass)

      # Need to call .parent() since .wrap() is non-mutative.
      @dom = element.parent()
      @tiles = [new Tile(element, 0)]

    # Returns a new tile split from the oldest tile, break ties left to right, up to down
    split: (element) ->

      # Pull off the oldest tile from the front of the queue
      oldest = @tiles[0]
      child = oldest.split(element)

      # Push the split tiles to the end of the tiles queue
      @tiles.push(oldest)
      @tiles.shift() # Dequeue the previously 'oldest' tile
      @tiles.push(child)

      child

  class Tile
    constructor: (@dom) ->
      @dom.wrap('<div/>')

      @wrapper().addClass('tile')
      @wrapper().css('float', 'left')
      @wrapper().css('height', '100%')
      @wrapper().css('width', '100%')

    wrapper: ->
      @dom.parent()

    # Cuts longer dimension of tile in half.
    shrink: ->
      if orientation(@dom) is 'portrait'
        shrinkVertically(@wrapper())
      else
        shrinkHorizontally(@wrapper())

    # Wrap the current element in a new container
    enclose: ->
      @wrapper().wrap('<div/>')
      container = @wrapper().parent()

      container.css('float', 'left')
      container.addClass(tileContainerClass)

      # Split the container if it's not the top-level container
      if not container.parent().hasClass('jstile')
        if orientation(container.parent()) is 'portrait'
          shrinkVertically(container)
        else
          shrinkHorizontally(container)

    # Removes this tile and expands the sibling to take the place of it and its parent 
    remove : ->

      # Expand the sibling of this tile to replace the parent in the DOM
      sibling = @wrapper().siblings()
      @wrapper().remove()
      sibling.parent().html(sibling.html())

      # Remove this element from the list of tiles



    # Shrinks, and returns a new Tile filling the newly allocated space.
    split: (child) ->
      @enclose()

      tile = new Tile(child)
      @shrink()

      if orientation(@dom) is 'portrait'
        shrinkVertically(tile.wrapper())
      else
        shrinkHorizontally(tile.wrapper())

      container = @wrapper().parent()
      container.append(tile.wrapper())

      tile

  $.fn.jstile = ->
    new Mosaic(this)

)(jQuery)
