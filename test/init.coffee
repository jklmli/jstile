mosaic = undefined

$(document).ready ->
  $('body').append($("<div id='mosaic'/>"))
  mosaic = $('#mosaic').jstile()
  $('#mosaic').rightClick(add)
  add(log=false)
  rescale()

add = (log=true) ->
  newElement = $('<img/>')
  newTiles = mosaic.add(newElement)
  newElement.click(->
    remove(newTile)
  )
  rescale()

  if log
    console.log(newTiles[0].wrapper())
    console.log(newTiles[1].wrapper())

remove = (tile) ->
  mosaic.remove(tile)
  rescale()
  #tile.dom.click(->
  #  remove(tile)
  #)

rescale = ->
  for image in $('img')
    $(image).attr('src', "http://placehold.it/#{$(image).parent().width()}x#{$(image).parent().height()}")

window.onresize = ->
  rescale()
