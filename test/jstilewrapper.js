$(document).ready(function() {
  var placeholderSource = 'http://placehold.it/' + $(document).width() + 'x' + ($(document).height() - 50);

  $('div').append($('<img src=http://placehold.it/' + $(document).width() + 'x' + ($(document).height() - 50) + ' style="width: 100%; height: 100%;">'));

  base = $('.jstile').jstile();
});
