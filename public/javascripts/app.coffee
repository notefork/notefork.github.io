get_type = (url) ->
  if url.match "[^\s]+\.(jpg|png|gif|bmp)"
    "image"
  else if url.match "[^\s]+\.youtube\.com/watch\\?v=\w*"
    "youtube"
  else if url.match "http://\w*"
      "link"
  else "text"

widget = (url) ->
    switch get_type(url)
        when "text"
            "<strong>" + url + "</string>"
        when "link"
            "<a href=\"" + url + "\" >" + url + "</a>"
        when "image"
            "<img src=\"" + url + "\">"
        when "youtube"
            id = url.match("[^\s]+\.youtube\.com/watch\?v=(\w*)")
            "<iframe id=\"ytplayer\" type=\"text/html\" width=\"300\" height=\"250\"
              src=\"http://www.youtube.com/embed/" + id + "?autoplay=1&origin=http://example.com\"frameborder=\"0\"/>"

$ ->
  defer = (fn) -> setTimeout 500, fn
  gridster = $('.grid').gridster().data('gridster')

  $('#publish-btn').click -> console.log 'publish'

  $('#search-btn').click ->
      gridster.add_widget widget(encodeURIComponent($('#search-box').val()))
  
