(($) ->

  # HTML classes associated with each level of tile & container
  jsTileClass = 'jstile'
  tileClass = 'tile'
  tileContainerClass = 'tileContainer'

  class Mosaic
    constructor: (element) ->

      # Wrap the first element to create the jstile parent element
      element.wrap('<div/>')
      element.parent().addClass(jsTileClass)

      # Wrap the first element to create the tile
      element.wrap('<div/>')
      element.parent().addClass('tile')

      # Need to call .parent() since .wrap() is non-mutative.
      @dom = element.parent().parent()
      @tiles = [new Tile(element.parent(), 1, 1)] # Split vertically first

    # Returns a new tile split from the oldest tile, break ties left to right, up to down
    split: ->

      # Pull off the oldest tile from the front of the queue
      oldest = @tiles[0]
      child = oldest.fission()

      # Push the split tiles to the end of the tiles queue
      @tiles.push(oldest)
      @tiles.push(child)

      # Remove the tile split from the front of the queue
      @tiles.shift()

      child

  class Tile
    constructor: (@element, @generation, @type) ->

    # A human readable form of @type.
    orientation: ->
      if @element.width() >= 2*@element.height()
        'horizontal'
      else if @element.height() >= 2*@element.width()
        'vertical'
      else
        if @type is 0
          'horizontal'
        else
          'vertical'

    # Toggle horizontal/vertical orientation (for next split direction)
    flip: ->
      @type = 1 - @type

    # Cuts longer dimension of tile in half.
    shrink: ->
      if @orientation() is 'vertical'
        @element.width(@element.width())
        @element.height(@element.height()/2)
      else
        @element.width(@element.width()/2)
        @element.height(@element.height())

      @flip()
      @generation += 1

    # Shrinks, and returns a new tile filling the newly allocated space.
    fission: ->

      # Wrap the current element in a new container
      @element.wrap('<div/>')
      container = @element.parent()
      container.addClass(tileContainerClass)

      # Mirror current dimensions of tile
      container.width(@element.width())
      container.height(@element.height())

      @shrink()

      # Create the child tile element & add the appropriate class
      child = $('<div></div>')
      child.addClass(tileClass)

      # Mirror dimensions of parent.
      child.width(@element.width())
      child.height(@element.height())

      container.append(child)

      new Tile(child, @generation, @type)

  $.fn.jstile = ->
    new Mosaic(this)

)(jQuery)
