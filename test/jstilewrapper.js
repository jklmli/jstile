$(document).ready(function() {
  var placeholderSource = 'http://placehold.it/' + $(document).width() + 'x' + $(document).height();

  $('div').append($('<img src=http://placehold.it/' + $(document).width() + 'x' + $(document).height() + '>'));

  base = $('img').jstile();
});