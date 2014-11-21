widget_detective = 
  text: ($w)->$w.text()
  image: ($w)->$w.attr("src")
  link: ($w)->$w.attr("href")
  youtube: ($w)->$w.attr("src")

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
            "<strong data-spy='text'>" + url + "</strong>"
        when "link"
            "<a data-spy='link' href=\"" + url + "\" >" + url + "</a>"
        when "image"
            "<img data-spy='image' src=\"" + url + "\">"
        when "youtube"
            id = url.match("[^\s]+\.youtube\.com/watch\\?v=(\w*)")
            "<iframe data-spy='youtube' id='ytplayer' type='text/html' width='300' height='250' src='http://www.youtube.com/embed/" + id + "'>"

save = (gridster) -> 
  window.location.hash = encodeURIComponent btoa JSON.stringify gridster.serialize()
  console.log "saved!"

load = () -> 
  console.log "loaded!"

$ ->
  gridster = $('.grid').gridster(
    draggable: 
      stop: (event, ui) -> save(this)
    serialize_params: ($w,wgd) -> 
      col: wgd.col
      row: wgd.row
      size_x: wgd.size_x
      size_y: wgd.size_y
      content: widget_detective[$w.data("spy")]($w)
      widget_base_dimensions: [100,55]
      widget_margins: [5,5] 
  ).data('gridster')
  
  h = window.location.hash.substring(1)
  
  memories = []

  if h then memories =  Gridster.sort_by_row_and_col_asc JSON.parse atob decodeURIComponent h
  
  for memory in memories
    gridster.add_widget widget(memory.content),memory.size_x,memory.size_y,memory.col,memory.row
     
 # $('#publish-btn').click -> console.log 'publish'

  $('#search-btn').click -> 
    content = $('#search-box').val()
    gridster.add_widget widget(content)
    save(gridster)
  
