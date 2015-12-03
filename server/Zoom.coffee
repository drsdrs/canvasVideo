Zoom = (canvasCtx, canvasWidth, canvasHeight)->
  Canvas = require('canvas')
  canvasBuffer = new Canvas(w, h)
  ctxBuffer = canvasBuffer.getContext("2d")

  ctx = canvasCtx
  w = canvasWidth
  h = canvasHeight

  draw = ()->
    imageData = ctx.getImageData(0, 0, w, h)

    data = imageData.data
    DATA = new Uint32Array(data);
    DATA.forEach (v,i)-> DATA[i] = v*0.9
    imageData.data.set DATA

    ctxBuffer.putImageData(imageData, 0, 0)

    zoom.x-=zoom.x/2 if zoom.x>0
    zoom.y-=zoom.y/2 if zoom.y>0

    setInterval ->
      zoom.x = zoom.y = 20
    , 5000

    ctx.drawImage(canvasBuffer, zoom.x, zoom.y, w-zoom.x*2, h-zoom.y*2)


exports.Zoom = Zoom