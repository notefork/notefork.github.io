// Generated by CoffeeScript 1.8.0
(function() {
  var get_type, load, save, widget, widget_detective;

  widget_detective = {
    text: function($w) {
      return $w.text();
    },
    image: function($w) {
      return $w.attr("src");
    },
    link: function($w) {
      return $w.attr("href");
    },
    youtube: function($w) {
      return $w.attr("src");
    }
  };

  get_type = function(url) {
    if (url.match("[^\s]+\.(jpg|png|gif|bmp)")) {
      return "image";
    } else if (url.match("[^\s]+\.youtube\.com/watch\\?v=\w*")) {
      return "youtube";
    } else if (url.match("http://\w*")) {
      return "link";
    } else {
      return "text";
    }
  };

  widget = function(url) {
    var id;
    switch (get_type(url)) {
      case "text":
        return "<strong data-spy='text'>" + url + "</strong>";
      case "link":
        return "<a data-spy='link' href=\"" + url + "\" >" + url + "</a>";
      case "image":
        return "<img data-spy='image' src=\"" + url + "\">";
      case "youtube":
        id = url.match("[^\s]+\.youtube\.com/watch\\?v=(\w*)");
        return "<iframe data-spy='youtube' id='ytplayer' type='text/html' width='300' height='250' src='http://www.youtube.com/embed/" + id + "'>";
    }
  };

  save = function(gridster) {
    window.location.hash = encodeURIComponent(btoa(JSON.stringify(gridster.serialize())));
    return console.log("saved!");
  };

  load = function() {
    return console.log("loaded!");
  };

  $(function() {
    var gridster, h, memories, memory, _i, _len;
    gridster = $('.grid').gridster({
      draggable: {
        stop: function(event, ui) {
          return save(this);
        }
      },
      serialize_params: function($w, wgd) {
        return {
          col: wgd.col,
          row: wgd.row,
          size_x: wgd.size_x,
          size_y: wgd.size_y,
          content: widget_detective[$w.data("spy")]($w),
          widget_base_dimensions: [100, 55],
          widget_margins: [5, 5]
        };
      }
    }).data('gridster');
    h = window.location.hash.substring(1);
    memories = [];
    if (h) {
      memories = Gridster.sort_by_row_and_col_asc(JSON.parse(atob(decodeURIComponent(h))));
    }
    for (_i = 0, _len = memories.length; _i < _len; _i++) {
      memory = memories[_i];
      gridster.add_widget(widget(memory.content), memory.size_x, memory.size_y, memory.col, memory.row);
    }
    return $('#search-btn').click(function() {
      var content;
      content = $('#search-box').val();
      gridster.add_widget(widget(content));
      return save(gridster);
    });
  });

}).call(this);
