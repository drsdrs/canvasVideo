PixelPulator = (ctx, canvasWidth, canvasHeight)->
  Canvas = require('canvas')

  w = canvasWidth
  h = canvasHeight

  zoom =
    x:20
    y:-20

  draw = ()->
    imageData = ctx.getImageData(0, 0, w, h)

    data = imageData.data
    #DATA = new Uint8ClampedArray(data);
    len = data.length
    i = 0
    while i<len
      data[i] -= 1
      i++
    #imageData.data.set DATA

    ctx.putImageData(imageData, 0, 0)

    # zoom.x-=zoom.x/2 if zoom.x>0
    # zoom.y-=zoom.y/2 if zoom.y>0

    # setInterval ->
    #   zoom.x = zoom.y = 20
    # , 5000

    # ctx.drawImage(canvasBuffer, zoom.x, zoom.y, w-zoom.x*2, h-zoom.y*2)


exports.PixelPulator = PixelPulator