mosaic = undefined

$(document).ready ->
  source = "http://placehold.it/#{$(window).width()}x#{$(window).height()}"
  $('body').append($("<div/>"))

  mosaic = $('div').jstile()
  add()
  rescale()

add = ->
  newTile = mosaic.add($('<img>'))
  rescale()

  newTile

remove = (tile) ->
  replacementTile = mosaic.remove(tile)
  rescale()

  replacementTile

rescale = ->
  for image in $('img')
    $(image).attr('src', "http://placehold.it/#{$(image).parent().width()}x#{$(image).parent().height()}")

window.onresize = ->
  rescale()
