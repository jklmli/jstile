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

      @tiles = [new Tile(element, 1, 0)]

    # Returns a new tile split from a random oldest tile.
    split: (element) ->
      child = @oldest().fission(element)
      @tiles.push(child)

      child

    # Returns a least-recently-split tile.  If there are several matches,
    # the result is random, since children of splits may be appended out of order.
    # TODO: Order matching tiles by left-to-right, then top-to-down
    oldest: ->
      generations = (tile.generation for tile in @tiles)

      minGeneration = Math.min(generations...)
      minIndex = generations.indexOf(minGeneration)

      @tiles[minIndex]

  class Tile
    constructor: (@dom, @generation, @type) ->
      @dom.wrap('<div/>')

      @wrapper().addClass('tile')
      @wrapper().css('float', 'left')
      @wrapper().css('max-height: 100%')
      @wrapper().css('max-width: 100%')

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
        @wrapper().css('max-width', '100%')
        @wrapper().css('max-height', '50%')
      else
        @wrapper().css('max-width', '50%')
        @wrapper().css('max-height', '100%')

      @flip()
      @generation += 1

    # Wrap the current element in a new container
    enclose: ->
      @wrapper().wrap('<div/>')
      container = @wrapper().parent()

      container.css('float', 'left')
      container.addClass(tileContainerClass)

      container.css('max-width', @wrapper().css('max-width'))
      container.css('max-height', @wrapper().css('max-height'))

    # Shrinks, and returns a new Tile filling the newly allocated space.
    fission: (child) ->
      @enclose()

      tile = new Tile(child, @generation, @type)
      @shrink()
      tile.shrink()

      container = @wrapper().parent()
      container.append(tile.wrapper())

      tile

  $.fn.jstile = ->
    new Mosaic(this)

)(jQuery)
