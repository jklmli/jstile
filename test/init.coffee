base = undefined

$(document).ready ->
  source = "http://placehold.it/#{$(window).width()}x#{$(window).height()}"
  $('body').append($("<img src=#{source} style='max-width:100%; max-height:100%'>"));

  base = $('img').jstile()

split = ->
  base.split().element.append('<img>')
  rescale()

rescale = ->
  for image in $('img')
    $(image).attr('src', "http://placehold.it/#{$(image).parent().width()}x#{$(image).parent().height()}")

window.onresize = ->
  rescale()