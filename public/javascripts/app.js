// Generated by CoffeeScript 1.8.0
(function() {
  $(function() {
    var defer, gridster;
    defer = function(fn) {
      return setTimeout(500, fn);
    };
    gridster = $('.grid').gridster().data('gridster');
    $('#publish-btn').click(function() {
      return console.log('publish');
    });
    $('#search-btn').click(function() {
      return $.get('/widget/' + encodeURIComponent($('#search-box').val()), function(data) {
        return gridster.add_widget(data);
      });
    });
    return $("#search").autocomplete({
      source: "/search",
      minLength: 3,
      select: function(event, ui) {
        return log(ui.item ? "Selected: " + ui.item.value + " aka " + ui.item.id : "Nothing selected, input was " + this.value);
      }
    });
  });

}).call(this);
