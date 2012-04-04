(($) ->

  # HTML classes associated with each level of tile & container
  jsTileClass = 'jstile'
  tileClass = 'tile'
  tileContainerClass = 'tileContainer'

  class Mosaic
    constructor: (element) ->

      # Wrap the first element to create the first tile & parent element
      element.removeClass(jsTileClass)
      element.wrap('<div/>')
      element.parent().addClass(jsTileClass)
      element.addClass('tile')

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

    # Shrinks, and returns a new tile filling the newly allocated space.
    fission: ->

      # Wrap the current element in a new container
      @element.wrap('<div/>')
      container = @element.parent()
      container.addClass(tileContainerClass)

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
