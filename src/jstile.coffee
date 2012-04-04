(($) ->

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
      child = oldest.fission(element)

      # Push the split tiles to the end of the tiles queue
      @tiles.push(oldest)
      @tiles.shift()

      @tiles.push(child)

      child

  class Tile
    constructor: (@dom, @type) ->
      @dom.wrap('<div/>')

      @wrapper().addClass('tile')
      @wrapper().css('float', 'left')
      @wrapper().css('height', '100%')
      @wrapper().css('width', '100%')

    wrapper: ->
      @dom.parent()

    # A human readable form of @type.
    orientation: ->
      if @type is 0
        'horizontal'
      else
        'vertical'

    flip: ->
      @type = 1 - @type

    # Cuts longer dimension of tile in half.
    shrink: ->
      if @orientation() is 'vertical'
        @wrapper().css('width', '100%')
        @wrapper().css('height', '50%')
      else
        @wrapper().css('width', '50%')
        @wrapper().css('height', '100%')

      @flip()

    # Wrap the current element in a new container
    enclose: ->
      @wrapper().wrap('<div/>')
      container = @wrapper().parent()

      container.css('float', 'left')
      container.addClass(tileContainerClass)

      container.css('width', @wrapper().css('width'))
      container.css('height', @wrapper().css('height'))

    # Shrinks, and returns a new Tile filling the newly allocated space.
    fission: (child) ->
      @enclose()

      tile = new Tile(child, @type)
      @shrink()
      tile.shrink()

      container = @wrapper().parent()
      container.append(tile.wrapper())

      tile

  $.fn.jstile = ->
    new Mosaic(this)

)(jQuery)
