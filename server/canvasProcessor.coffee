DrawWeb = require("./Draw.coffee").DrawWeb
PixelPulator = require("./PixelPulator").PixelPulator
Zoom = require("./Zoom.coffee").Zoom



CanvasProcessor = (canvas, canvasWidth, canvasHeight)->
  w = canvasWidth
  h = canvasHeight

  ctx = canvas.getContext("2d")

  drawWeb = DrawWeb ctx, w, h
  pixelPulator = PixelPulator ctx, w, h
  draw:->
    drawWeb()
    pixelPulator()




exports.CanvasProcessor = CanvasProcessor
