(($) ->
  class Mosaic
    constructor: (element) ->
      element.wrap('<div/>')
      @dom = element.parent()
      @tiles = [new Tile(element, 1, 0)]

    # Returns a randomly a new tile split from the oldest tile.
    split: ->
      child = @oldest().fission()
      @tiles.push(child)

      child

    # Returns a random least-recently-split tile.
    # TODO: Order matching tiles by left-to-right, then top-to-down
    oldest: ->
      generations = (tile.generation for tile in @tiles)

      minGeneration = Math.min.apply(this, generations)
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
      container.append(child)

      new Tile(child, @generation, @type)

  $.fn.jstile = ->
    new Mosaic(this)

)(jQuery)