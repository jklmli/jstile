(($) ->
  class Mosaic
    constructor: (element) ->
      element.wrap('<div/>')

      # Need to call .parent() since .wrap() is non-mutative.
      @dom = element.parent()
      @tiles = [new Tile(element, 1, 0)]

    # Returns a new tile split from a random oldest tile.
    split: ->
      child = @oldest().fission()
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
    constructor: (@element, @generation, @type) ->

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
        @element.height(@element.height()/2)
      else
        @element.width(@element.width()/2)

      @flip()
      @generation += 1

    # Shrinks, and returns a new Tile filling the newly allocated space.
    fission: ->
      @element.wrap('<div/>')
      container = @element.parent()

      @shrink()

      child = $('<div></div>')

      # Mirror dimensions of parent.
      child.width(@element.width())
      child.height(@element.height())

      container.append(child)

      new Tile(child, @generation, @type)

  $.fn.jstile = ->
    new Mosaic(this)

)(jQuery)