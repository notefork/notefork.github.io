express = require 'express'
body_parser = require 'body-parser'
app = express()

app.set 'port', (process.env.PORT || 5000)
app.use express.static(__dirname + '/public')
app.use body_parser.json()
app.use body_parser.urlencoded(extended: true) 

http = require 'http'
util = require 'util'
#-----------------------------config



wikipedia = (query,deliver) ->
  http.get { host: "http://en.wikipedia.org/w/api.php?action=opensearch&search="+query }, (res) -> deliver(res[1])

youtube = (query,deliver) ->
  http.get { host: "http://en.wikipedia.org/w/api.php?action=opensearch&search="+"bla"+query }, (res) -> deliver(res[1])

search = (term, cb) ->
  results = []
  done = 2
  deliver = (items) ->
    done -= 1
    results += items
    if done == 0
      cb(results)
  for api in [wikipedia,youtube]
    api(term,deliver)

#ddg = (query,cb) -> http.get("http://duckduckgo.com/?q="+query , (res1) -> res1.on('data', (data)->cb(data)))
ddg = (query,cb) -> 
  str = ""
  callb = (resp) ->
    resp.on('data',(data)->str+=data)
    resp.on('end',(data)->cb(str))

  http.get("http://api.duckduckgo.com/?q="+query+"&format=json",callb)
#----------------------------actions
html_dir = './public/'
home = ->
  res.sendFile html_dir + 'index.html'

app.get '/', (req, res) -> home()

app.get '/note/:id', (req, res) ->
  if req.params.id
    res.send new Buffer(decodeURIComponent(req.params.id), 'base64').toString 'ascii'
  else home()

app.post '/search', (req, res) ->
  #f = (x) -> console.log step(step(check(x).input).input)
  f = (x) ->
    #console.log check(x)
    res.send x+""
    #[0].match("\"data\":{"))
  ddg req.body.term,f
#res.send

app.get '/widget/:query', (req, res) -> widget(decodeURIComponent(req.params.query))

app.post '/publish', (req, res) ->
  res.send encodeURIComponent(new Buffer(widget(decodeURIComponent(req.body.input))).toString 'base64')

app.get '/*', (req,res) -> res.send "not found"
app.listen app.get('port'), ->
  console.log "Node app is running at localhost:" + app.get('port')
