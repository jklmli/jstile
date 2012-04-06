mosaic = undefined

$(document).ready ->
  $('body').append($("<div id='mosaic'/>"))
  mosaic = $('#mosaic').jstile()
  add()
  rescale()

add = ->
  newElement = $('<img/>')
  newTile = mosaic.add(newElement)
  newElement.click(->
    remove(newTile)
  )
  rescale()

  newTile

remove = (tile) ->
  replacementTile = mosaic.remove(tile)
  replacementTile.dom.click(->
    remove(newTile)
  )
  rescale()

  replacementTile

rescale = ->
  for image in $('img')
    $(image).attr('src', "http://placehold.it/#{$(image).parent().width()}x#{$(image).parent().height()}")

window.onresize = ->
  rescale()
