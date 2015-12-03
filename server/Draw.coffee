DrawWeb = (canvasCtx, canvasWidth, canvasHeight)->
  w = canvasWidth
  h = canvasHeight
  ctx = canvasCtx
  dir =
    x: 0#.0#001
    y: 0
  pos =
    x: w/2
    y: h/2
    z: 20
  col =
    fill:
      r: 255
      g: 0
      b: 0
      a: 1
    stroke:
      r: 255
      g: 255
      b: 255
      a: 1

  setColor = (type, newColor)->
    if newColor? then col[type] = newColor
    c = col[type]
    ctx[type+"Style"] = "rgba("+(c.r)+","+(c.g)+","+(c.b)+","+(c.a)+")"
  draw = ()->
    p = pos
    if p.x>w||p.x<0 then dir.x=-dir.x
    if p.y>h||p.y<0 then dir.y=-dir.y
    p.x+=dir.x
    p.y+=dir.y
    c = col.stroke
    c.r = (c.r++)&255
    c.g = (c.g+=2)&255
    c.b = (c.b+=3)&255
    c.a = 1
    setColor("stroke")

    p.z += 0.01
    wire = (x,y,cnt)->
      if !cnt? then cnt = 0
      cnt++
      xx = Math.sin((y+p.z)/10)*50
      yy = Math.sin((x+p.z)/10)*50
      ctx.beginPath()
      ctx.moveTo x, y
      x -= xx
      y += yy
      c.a-=0.075
      setColor("stroke")
      ctx.lineTo(x, y);
      ctx.stroke()
      if y<0||y>600||x<0||x>800||cnt>2000
        return cnt
      else wire(x,y,cnt)

    console.log wire p.x, p.y
    col.stroke.a = 1
    setColor("stroke")


exports.DrawWeb = DrawWeb



###
function draw1(){
  x+=0.1;
  y++;

  ctx.fillRect(x,y,150,150);   // Draw a rectangle with default settings
  ctx.save();                  // Save the default state

  ctx.fillStyle = '#09F'       // Make changes to the settings
  ctx.fillRect(15+y,15+x,120,120); // Draw a rectangle with new settings

  ctx.save();                  // Save the current state
  ctx.fillStyle = '#FFF'       // Make changes to the settings
  ctx.globalAlpha = 0.5;
  ctx.fillRect(30+x,30+y,90,90);   // Draw a rectangle with new settings

  ctx.restore();               // Restore previous state
  ctx.fillRect(45+x,45+y,60,60);   // Draw a rectangle with restored settings

  ctx.restore();               // Restore original state
  ctx.fillRect(60+y,60+x,30,30);   // Draw a rectangle with restored settings
  startStream();
}
###
