(($) ->

  # Gets the orientation of e jQuery element 
  orientation = (element) ->

    # Get the width as a percentage
    width = ( 100 * parseFloat(element.css('width')) / parseFloat(element.parent().css('width')) ) + '%'
    height = ( 100 * parseFloat(element.css('height')) / parseFloat(element.parent().css('height')) ) + '%'

    if width is '100%' and height is '50%'
      'landscape'
    else if width is '50%' and height is '100%'
      'portrait'
    else
      'fill'

  shrinkVertically = (element) ->
    element.css('width', '100%')
    element.css('height', '50%')

  shrinkHorizontally = (element) ->
    element.css('width', '50%')
    element.css('height', '100%')

  # Orients some 'targetElement' based on the size 'sourceElement'
  orientElement = (sourceElement, targetElement, match=true) ->
    if match
      if orientation(sourceElement) is 'portrait'
        shrinkHorizontally(targetElement)
      else if orientation(sourceElement) is 'landscape'
        shrinkVertically(targetElement)
      else
        shrink(sourceElement, targetElement)
    else
      if orientation(sourceElement) is 'portrait'
        shrinkVertically(targetElement)
      else if orientation(sourceElement) is 'landscape'
        shrinkHorizontally(targetElement)
      else
        shrink(sourceElement, targetElement)

  # Automatically shrinks the 'targetElement' based on the size of the 'sourceElement'
  shrink = (sourceElement, targetElement) ->
    if sourceElement.width() > sourceElement.height()
      shrinkHorizontally(targetElement)
    else
      shrinkVertically(targetElement)

  # HTML classes associated with each level of tile & container
  jsTileClass = 'jstile' # Top-level jstile object
  tileClass = 'tile' # Bottom-level single tile object
  tileContainerClass = 'tileContainer' # Inner layers

  ### Top-level object that contains a tree, with leaves as Tile objects ###
  class Mosaic

    ### Creates a top-level Mosaic object from a given jQuery element, with no tiles or tile containers ###
    constructor: (@dom) ->

      @dom.addClass(jsTileClass)
      @leafTiles = []

      if $.fn.droppable?
        @dom.on('drop', (event, ui) ->
          @add(ui.draggable)
        )

    ### Returns a new tile split from the oldest tile, break ties left to right, up to down. If no existing tiles, add first ###
    add: (element) ->

      if @leafTiles.length > 0

        # Split oldest existing tile 
        oldestTile = @leafTiles[0]
        newChildren = oldestTile.split(element)

        # Push the split tiles to the end of the tiles queue
        @leafTiles.push(oldestTile.leftChild)
        @leafTiles.push(oldestTile.rightChild)
        @leafTiles.shift() # Dequeue the previously 'oldest' tile

        newChildren

      else

        # Create new tile and top-level tile 
        newTile = new Tile(element, null)
        @leafTiles.push(newTile)
        @dom.append(newTile.wrapper())

        [newTile]

    ### Remove some element from the Mosaic (merging it with its sibling) ###
    remove: (tile) ->

      if tile.sibling isnt null

        # Find the tile & its sibling in the queue of leaf tiles, and remove them
        tileIndex = @leafTiles.indexOf(tile)
        siblingTileIndex = @leafTiles.indexOf(tile.sibling)
        @leafTiles.splice(siblingTileIndex, 1)
        @leafTiles.splice(tileIndex, 1)

        # Remove both tiles from the queue, remove tile from DOM, and re-insert replacement tile at beginning of queue
        parentTile = tile.parent
        replacementTile = parentTile.merge(tile)
        @leafTiles.splice(0, 0, replacementTile)

      else

        console.log('Cannot remove tile without a sibling element')

  # Node objects that form a tile tree (full binary tree, each node contains a parent, and 0 or 2 children)
  class Tile

    ### Creates a Tile object, wrapping the given DOM structure with a tile container ###
    constructor: (@dom, @parent, wrap=true) ->
      if wrap
        @dom.wrap('<div/>')
        @wrapper().addClass(tileClass)
        @wrapper().css('float', 'left')
        @wrapper().css('height', '100%')
        @wrapper().css('width', '100%')

      @leftChild = null
      @rightChild = null
      @sibling = null

    wrapper: ->
      @dom.parent()

    ### Wrap the current element in a new tile container ###
    enclose: ->
        
      @wrapper().wrap('<div/>')
      container = @wrapper().parent()

      container.addClass(tileContainerClass)
      container.css('float', 'left')

      @matchSiblingOrientation(container)

    matchSiblingOrientation: (element) ->
      if @sibling isnt null
        orientElement(@sibling.wrapper(), element, true)
      else
        element.css('height', '100%')
        element.css('width', '100%')

    ### Merge this children of this tile, removing the given tile from the tree ###
    merge: (tileToRemove) ->
    
      # Find which child to remove
      if tileToRemove is @leftChild
        tileToKeep = @rightChild
      else
        tileToKeep = @leftChild

      # Remove the tile to remove's elements from the DOM
      tileToRemove.wrapper().remove()
      tileToKeep.wrapper().unwrap()

      # Assimilate the children tiles
      @dom = tileToKeep.dom
      @matchSiblingOrientation(@wrapper())

      # Get a handle on the subtrees of the child tile to keep
      @leftChild = tileToKeep.leftChild
      @rightChild = tileToKeep.rightChild
      if @leftChild isnt null or @rightChild isnt null
        @wrapper().removeClass(tileContainerClass)
        @wrapper().addClass(tileClass)

      return this

    ### Given some new element, split this tile to add two children tiles ###
    split: (newElement) ->

      # Create the tile container DOM element, wrapping the current DOM
      @enclose()

      # Create new children of this tile, the left containing the original DOM
      @leftChild = new Tile(@dom, this, false)
      @rightChild = new Tile(newElement, this, true)
      @rightChild.sibling = @leftChild
      @leftChild.sibling = @rightChild

      # Update the DOM and orient the children DOM elements
      @dom = @wrapper().parent()
      @dom.append(@rightChild.wrapper())
      shrink(@dom, @leftChild.wrapper())
      shrink(@dom, @rightChild.wrapper())

      [@leftChild, @rightChild]

  $.fn.jstile = ->
    new Mosaic(this)

)(jQuery)
