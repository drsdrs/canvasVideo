var stdout = require('stdout-stream')
  , express = require('express')
  , serveStatic = require('serve-static')
  , Canvas = require('canvas')
  , exec = require('child_process').exec
  , spawn = require('child_process').spawn
  , coffee = require('coffee-script').register()
  , CanvasProcessor = require("./server/CanvasProcessor.coffee").CanvasProcessor
  , canvasWidth = 480
  , canvasHeight = 480
  , canvas = new Canvas(canvasWidth, canvasHeight)
  , ctx = canvas.getContext('2d')
  , fs = require('fs')
  , canvasProcessor = CanvasProcessor(canvas, canvasWidth, canvasHeight)
  , debug = false
  , preview = true

function log(arguments){ if(debug===true) console.log(arguments); }

app = express();
app.use(serveStatic(__dirname)).listen(9000);

console.log("Check port 9000 on localhost, dude !")

var postCnt = 0;
app.use("/gimmiDataUri", function(req, res){
  ffwd = 1;
  while(ffwd--){ canvasProcessor.draw(); }
  //console.log(postCnt++);
  canvas.toDataURL(function(err, str){
    if(err) throw err;
    res.end(str);
  });
});

app.use("/record", function(req, res){
  startRecord(res);
});

function startRecord(res){
  if(!res){
    res={};
    res.write = function(){ return null;}
    res.end = function(){ return null;}
  }
  var count = 0;
  var limit = 600;
  var canvasStream = new Canvas(canvasWidth, canvasHeight);
  var ctxStream = canvasStream.getContext('2d');
  ctxStream.patternQuality = 'best'
  var canvasProcessor = CanvasProcessor(canvasStream, canvasWidth, canvasHeight)
  exec("rm ./videos/movie.mp4 -f");
  var avconv = spawn('avconv', ['-f', 'image2pipe', '-r', '25', '-i',  '-', './videos/movie.mp4']);
  console.log("startRecord");

  avconv.stderr.on('data', function (data) {
    console.log(data+"");
    data = data.toString();
    if(data.includes("frame= ")){
      frames = data.split("frame= ")[1].trim().split(" ")[0]
      console.log("progress: "+Math.floor(100/limit*frames)+"%");
      res.write("progress: "+Math.floor(100/limit*frames)+"%")
    }
  });

  avconv.on('close', function (code) {
    if(code!==0) throw "avconv doesnt did well..."+code;
    console.log("avconv done !!!");
    res.end("avconv done !!!");
  });

  function startStream(){
    canvasStream.toBuffer(function(err, buf){
      if(err) throw err;
      avconv.stdin.write(buf);
      //console.log(count);
      checkDraw();
    });
  }

  function checkDraw(){
    if(count<limit){
      count++;
      canvasProcessor.draw();
      startStream();
    } else { avconv.stdin.end(); }
  }

  startStream()
}
//startRecord();