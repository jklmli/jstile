base = undefined

$(document).ready ->
  source = "http://placehold.it/#{$(window).width()}x#{$(window).height()}"
  $('div').append($("<img src=#{source}>"))

  base = $('.jstile').jstile()
