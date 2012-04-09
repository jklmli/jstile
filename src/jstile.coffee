(($) ->

  # Takes in jQuery object
  orientation = (element) ->
    if element.width() > element.height()
      'landscape'
    else
      'portrait'

  orientHorizontally = (element) ->
    element.css('width', '50%')
    element.css('height', '100%')

  orientVertically = (element) ->
    element.css('width', '100%')
    element.css('height', '50%')

  orientElement = (sourceElement, targetElement) ->
    if orientation(sourceElement) is 'portrait'
      orientVertically(targetElement)
    else
      orientHorizontally(targetElement)

  # HTML classes associated with each level of tile & container
  jsTileClass = 'jstile' # Top-level jstile object
  tileClass = 'tile' # Bottom-level single tile object
  tileContainerClass = 'tileContainer' # Inner layers

  class Mosaic
    constructor: (@dom) ->
      ### Creates a top-level Mosaic object from a given jQuery element, with no tiles or tile containers ###

      @dom.addClass(jsTileClass)
      @tiles = []

    add: (element) ->
      ### Returns a new tile split from the oldest tile, break ties left to right, up to down. If no existing tiles, add first ###

      if @tiles.length > 0

        # Split oldest existing tile 
        oldestTile = @tiles[0]
        newTile = oldestTile.split(element)

        # Push the split tiles to the end of the tiles queue
        @tiles.push(oldestTile)
        @tiles.shift() # Dequeue the previously 'oldest' tile
        @tiles.push(newTile)

      else

        # Create new tile and top-level tile 
        newTile = new Tile(element, 0)
        @tiles.push(newTile)
        @dom.append(newTile.wrapper())

      newTile

    remove: (tile) ->
      ### Remove some element from the Mosaic (merging it with its sibling) ###

      # Find the tile & its sibling in the queue of tiles
      tileIndex = @tiles.indexOf(tile)
      siblingTileIndex = tileIndex - 1
      siblingTile = @tiles[siblingTileIndex]

      # Remove both tiles from the queue, remove tile from DOM, and re-insert new tile at beginning of queue
      @tiles.splice(Math.min(siblingTileIndex, tileIndex), 2)
      newTile = tile.join(siblingTile)
      @tiles.splice(0,0,siblingTile)

      newTile
     
  class Tile
    constructor: (@dom) ->
      @dom.wrap('<div/>')

      @wrapper().addClass('tile')
      @wrapper().css('float', 'left')
      @wrapper().css('height', '100%')
      @wrapper().css('width', '100%')

    wrapper: ->
      @dom.parent()

    shrink: ->
      ### Cuts longer dimension of tile in half ###
      orientElement(@dom, @wrapper())

    enclose: ->
      ### Wrap the current element in a new container ###
        
      @wrapper().wrap('<div/>')
      container = @wrapper().parent()

      container.css('float', 'left')
      container.addClass(tileContainerClass)

      # Split the container if it's not the top-level container
      if not container.parent().hasClass('jstile')
        orientElement(container.parent(), container)

    join: (siblingTile) ->
      ### Removes this tile and expands the sibling to take the place of it and its parent ###

      siblingElement = siblingTile.wrapper()

      orientElement(siblingElement, siblingElement)

      siblingElement.unwrap()
      @wrapper().remove()

      siblingTile

    split: (child) ->
      ### Shrinks, and returns a new Tile filling the newly allocated space ###

      @enclose()

      tile = new Tile(child)
      @shrink()
      orientElement(@dom, tile.wrapper())

      container = @wrapper().parent()
      container.append(tile.wrapper())

      tile

  $.fn.jstile = ->
    new Mosaic(this)

)(jQuery)
