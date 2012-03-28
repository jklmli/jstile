(($) ->
  class Mosaic
    constructor: (element) ->
      element.wrap('<div/>')
      @dom = element.parent()
      @tiles = [new Tile(element, 1, 0)]

    # Returns a randomly a new tile split from the oldest tile.
    split: ->
      child = @oldest.fission()
      @tiles.push(new Tile(child, tile.generation, tile.orientation()))

      child

  class Tile
    constructor: (@element, @generation, @type) ->

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

    # Shrinks, and returns a new div filling the newly allocated space
    fission: ->
      container = @element.wrap('<div/>')
      @shrink()

      child = $('<div></div>')
      container.append(child)

      child

  $.fn.jstile = ->
    console.log(this)
    new Mosaic(this)

)(jQuery)