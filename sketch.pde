/*
Shaders performance on video processing
Author: Diego Andrés Vásquez Ávila


Videos contributions:
- Ai Otsuka - 360.mp4: https://www.youtube.com/watch?v=ac1pI0iLhdA
- PSY GANGNAM STYLE.mp4: https://www.youtube.com/watch?v=9bZkp7q19f0
- Interstellar - Docking Scene.mp4: https://www.youtube.com/watch?v=C28qipaYUyI

Shaders contributions:
- black-white: https://github.com/codeanticode/pshader-tutorials
- edge-detector: https://github.com/codeanticode/pshader-tutorials
- emboss: https://github.com/codeanticode/pshader-tutorials
- bump-mapping: Code adapted from https://github.com/asalga/p55hade
- fog: Code adapted from http://glslsandbox.com/e#40767.0
- bubbles: Code adapted from http://glslsandbox.com/e#40742.0
- water: Code adapted from http://glslsandbox.com/e#40730.1
*/

import processing.video.*;

//Videos variables
Movie video1;
Movie video2;
Movie video3;
//Selected video
Movie selVideo;


//Shaders variables
PShader bwShader;
PShader edgesShader;
PShader embossShader;
PShader bumpMappingShader;
PShader fogShader;
PShader bubblesShader;
PShader waterShader;
//Selected shaders
PShader selShader;


//FPS counter variables
int fcount, lastm;
float frate;
int fint = 1;

void setup() {
  size(600,400, P3D);
  
  //Load videos
  video1 = new Movie(this,"videos/Ai Otsuka - 360.mp4");
  video2 = new Movie(this,"videos/PSY GANGNAM STYLE.mp4");
  video3 = new Movie(this,"videos/Interstellar - Docking Scene.mp4");
  
  //Preselect first video
  selVideo = video1;
  selVideo.loop();
  selVideo.play();
  
  //Load shaders 
  bwShader = loadShader("shaders/black-white/frag.glsl");
  edgesShader = loadShader("shaders/edge-detector/frag.glsl");
  embossShader = loadShader("shaders/emboss/frag.glsl");
  bumpMappingShader = loadShader("shaders/bump-mapping/frag.glsl", "shaders/bump-mapping/vert.glsl");
  fogShader = loadShader("shaders/fog/frag.glsl");
  bubblesShader = loadShader("shaders/bubbles/frag.glsl");
  waterShader = loadShader("shaders/water/frag.glsl");
  
  //Set very high framerate for test performance
  frameRate(1000);
}

//Read a new frame when is available
void movieEvent(Movie video) {
  video.read();
}

void draw(){ 
  background(0);
  hint(DISABLE_DEPTH_TEST);
  if(selShader != null){
    selShader.set("time", millis() / 1000.0);
    selShader.set("mouse", float(mouseX), float(mouseY));
    selShader.set("resolution", width, height);
  }
  image(selVideo,0,0, width, height);
  hint(ENABLE_DEPTH_TEST);
  
  drawFPSCounter();
}

void keyPressed() {
  
  //Shaders selection
  switch(key){
    case '0':
      println("No shaders");
      selShader = null;
      resetShader();
      break;
    case '1':
      println("Black&white texture filtering");
      selShader = bwShader;
      break;
    case '2':
      println("Edge detection filtering");
      selShader = edgesShader;
      break;
    case '3':
      println("Emboss filtering");
      selShader = embossShader;
      break; 
    case '4':
      println("Bump Mapping");
      selShader = bumpMappingShader;
      break;   
    case '5':
      println("Fog filtering");
      selShader = fogShader;
      break;  
     case '6':
      println("Bubbles filtering");
      selShader = bubblesShader;
      break;
     case '7':
      println("Water filtering");
      selShader = waterShader;
      break;
  }
  
  //Video selection
  switch(key){
    case 'q':
      println("Ai Otsuka - 360, 320x218, 29FPS");
      selVideo = video1;
      video2.pause();
      video3.pause();
      selVideo.play();
      selVideo.loop();
      break;
    case 'w':
      println("PSY GANGNAM STYLE, 1920x1080, 23FPS");
      selVideo = video2;
      video1.pause();
      video3.pause();
      selVideo.play();
      selVideo.loop();
      break;
    case 'e':
      println("Interstellar - Docking Scene, 1920x1080, 59FPS");
      selVideo = video3;
      video1.pause();
      video2.pause();
      selVideo.play();
      selVideo.loop();
      break;
  }
  
  if(selShader != null){
    shader(selShader); 
  }
  
}

void drawFPSCounter(){
  fcount += 1;
  int m = millis();
  if (m - lastm > 1000 * fint) {
    frate = float(fcount) / fint;
    fcount = 0;
    lastm = m;
    println("fps: " + frate);
  }
  fill(0);
  text("fps: " + frate, 10, 20);
}