base = undefined

$(document).ready ->
  source = "http://placehold.it/#{$(window).width()}x#{$(window).height()}"
  $('body').append($("<img src=#{source}>"));

  base = $('img').jstile()
  rescale()

split = ->
  base.split($('<img>'))
  rescale()

rescale = ->
  for image in $('img')
    $(image).attr('src', "http://placehold.it/#{$(image).parent().width()}x#{$(image).parent().height()}")

window.onresize = ->
  rescale()