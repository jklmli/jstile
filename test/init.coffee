base = undefined

$(document).ready ->
  source = "http://placehold.it/#{$(window).width()}x#{$(window).height()}"
  $('body').append($("<img src=#{source} style='max-width:100%; max-height:100%'>"))

  base = $('img').jstile()
  rescale()

split = ->
  tile = base.split()
  tile.element.append('<img/>')
  rescale()
  return tile

rescale = ->
  for image in $('img')
    $(image).attr('src', "http://placehold.it/#{$(image).parent().width()}x#{$(image).parent().height()}")

window.onresize = ->
  rescale()
