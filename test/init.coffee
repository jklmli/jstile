mosaic = undefined

$(document).ready ->
  $('body').append($("<div id='mosaic'/>"))
  mosaic = $('#mosaic').jstile()
  $('#mosaic').rightClick(add)
  add()
  rescale()

add = ->
  newElement = $('<img/>')
  newTile = mosaic.add(newElement)
  newElement.click(->
    remove(newTile)
  )
  rescale()

remove = (tile) ->
    #mosaic.remove(tile)
    #rescale()
  tile.dom.click(->
    remove(tile)
  )

  console.log(tile.wrapper())
  console.log(tile.sibling.wrapper())

rescale = ->
  for image in $('img')
    $(image).attr('src', "http://placehold.it/#{$(image).parent().width()}x#{$(image).parent().height()}")

window.onresize = ->
  rescale()
