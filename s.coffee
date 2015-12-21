fs = require('fs')
stdout = require('stdout-stream')
express = require('express')
serveStatic = require('serve-static')
Canvas = require('canvas')
exec = require('child_process').exec
spawn = require('child_process').spawn
coffee = require('coffee-script').register()
CanvasProcessor = require('./server/CanvasProcessor.coffee').CanvasProcessor

app = express()
canvasWidth = 480
canvasHeight = 360
canvas = new Canvas canvasWidth, canvasHeight
fps = 24
canvasProcessor = CanvasProcessor canvas, canvasWidth, canvasHeight, fps
debug = false
preview = true

recordMovie = process.argv[2]?

startRecord = (res) ->
  res = res || {
    write:-> null
    end:-> null
  }
  startStream = ->
    canvas.toBuffer (err, buf) ->
      if err then throw err
      avconv.stdin.write buf
      checkDraw()

  checkDraw = ->
    if canvasProcessor.draw() then startStream()
    else avconv.stdin.end()



  avconv = spawn('avconv', [
    '-y' # overwrite existing file
    '-f','image2pipe' #,'rawvideo',
    #'-vcodec','rawvideo',
    #'-pix_fmt', 'rgba64le'#'rgb24',
    '-r', fps #, frames per second
    '-i'
    '-'
    './videos/movie.mp4'
  ])
  console.log 'startRecord'
  avconv.stderr.on 'data', (data) ->
    #console.log data + ''
    data = data.toString()
    if data.includes('frame= ')
      frames = data.split('frame= ')[1].trim().split(' ')[0]
      console.log 'progress: ' + frames + 'frames'
      res.write 'progress: ' + frames + 'frames'

  avconv.on 'close', (code) ->
    if code != 0
      throw 'avconv doesnt did well...' + code
    watchMovie = exec 'totem ./videos/movie.mp4'
    console.log 'avconv done !!!'
    res.end 'avconv done !!!'

  startStream()


postCnt = 0
app.use '/gimmiDataUri', (req, res) ->
  if recordMovie then return res.end "still recording..."
  ffwd = 1
  while ffwd-- then canvasProcessor.draw()
  canvas.toDataURL (err, str) ->
    if err then throw err
    res.end str


app.use '/record', (req, res) -> startRecord res
#startRecord();


app.use(serveStatic(__dirname)).listen 9000
console.log 'Check port 9000 on localhost, dude !'

#appView = exec 'chromium-browser --app=http://localhost:9000'

process.on "close", ->
  console.log "END"
  process.end()

if recordMovie then startRecord()
